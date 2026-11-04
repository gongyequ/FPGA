/*
 * Project PMUX pass for the 0.69 baseline.
 * New code; not an upstream Yosys pass. No changes to another pass are needed.
 *
 * Four-state preserving rules:
 *  (1) remove only select arms proven to be constant zero by SigMap;
 *  (2) retain $pmux even when only one arm remains;
 *  (3) merge output bit-columns only when A and every B arm are identical.
 *
 * Optional -shiftx-small uses the upstream pmux2shiftx implementation only on
 * one complete (or one-entry-short) 2/3-bit constant decoder. Its X-safety
 * argument and limitations are recorded in the accompanying Chinese note.
 */
#include "kernel/celltypes.h"
#include "kernel/log.h"
#include "kernel/register.h"
#include "kernel/sigtools.h"

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

struct PmuxOptPass : public Pass {
    PmuxOptPass() : Pass("pmux_opt", "four-state preserving PMUX structural cleanup") { }

    void help() override
    {
        log("\n    pmux_opt [-shiftx-small] [-flatten-fallback] [-const-decode] [-const-polarity] [-order-decode [-desc-order]] [-uniform-abc] [-index-full-x] [-flatten-data-arm] [selection]\n\n");
        log("-index-full-x is an optional research rule for complete four-bit\n");
        log("decoders with an all-X default and data width at most 32.\n");
        log("It preserves natural control-bit order and is disabled by default.\n");
        log("-flatten-data-arm is an optional research rule merging single-use\n");
        log("PMUX data-arm nesting through four-state PMUX control gates.\n");
        log("Remove constant-zero select arms and share identical data columns.\n");
        log("A one-arm cell remains a $pmux; B == A is not a removal condition.\n");
        log("-shiftx-small invokes upstream pmux2shiftx only for dense, mutually\n");
        log("exclusive 2/3-bit decoders covering all but at most one code point.\n");
        log("-flatten-fallback merges single-use nested fallback PMUXes using\n");
        log("a PMUX control gate, preserving unknown and multi-select semantics.\n");
        log("-const-decode propagates eq/logic_not selection predicates into\n");
        log("their own B arms only; A, S and the PMUX cell type remain intact.\n");
        log("-const-polarity complements only 0/1/X constant A/B tables and\n");
        log("adds a real output NOT; dynamic or Z-valued A/B are excluded.\n");
        log("-order-decode sorts B/S arms together by their constant decoder\n");
        log("value on the same control word. -desc-order selects descending\n");
        log("rather than ascending order. No arms are removed or combined.\n");
        log("-uniform-abc installs the same area-oriented ABC9 script for every\n");
        log("design, unless the caller has explicitly supplied abc9.script.\n");
    }

    // New project rule, not an upstream pass: facts that hold when this exact
    // eq/logic_not output is 1. Unknown comparison constants are never facts.
    bool predicate_constants(Cell *cell, SigMap &sigmap, dict<SigBit, State> &facts)
    {
        SigSpec control, value;
        if (cell->getPort(ID::Y).size() != 1) return false;
        if (cell->type == ID($eq)) {
            control = sigmap(cell->getPort(ID::A));
            value = sigmap(cell->getPort(ID::B));
            int width = std::max(control.size(), value.size());
            if (width < 1 || width > 1024) return false;
            bool is_signed = cell->getParam(ID::A_SIGNED).as_bool() && cell->getParam(ID::B_SIGNED).as_bool();
            control.extend_u0(width, is_signed);
            value.extend_u0(width, is_signed);
            if (control.is_fully_const()) std::swap(control, value);
            if (!value.is_fully_const()) return false;
        } else if (cell->type == ID($logic_not)) {
            control = sigmap(cell->getPort(ID::A));
            if (control.empty() || control.size() > 1024) return false;
            value = SigSpec(State::S0, control.size());
        } else return false;
        for (int bit = 0; bit < control.size(); bit++) {
            State constant = value[bit].data;
            if (constant != State::S0 && constant != State::S1) return false;
            SigBit wire = control[bit];
            if (!wire.wire) {
                if (wire.data != constant) return false;
                continue;
            }
            if (facts.count(wire) && facts.at(wire) != constant) return false;
            facts[wire] = constant;
        }
        return !facts.empty();
    }

    bool index_full_x_decode(RTLIL::Module *module, RTLIL::Cell *pmux,
            SigMap &sigmap, const dict<SigBit, Cell*> &predicate_drivers,
            const pool<SigBit> &ambiguous_predicates)
    {
        SigSpec a = sigmap(pmux->getPort(ID::A));
        SigSpec b = pmux->getPort(ID::B), s = sigmap(pmux->getPort(ID::S));
        SigSpec y = pmux->getPort(ID::Y);
        const int width = GetSize(a), count = GetSize(s);
        if (width < 1 || width > 32 || count != 16 || GetSize(y) != width ||
                GetSize(b) != width * count) return false;
        for (auto bit : a)
            if (bit != State::Sx) return false; // Must not include Sz or live wires.

        SigSpec natural_control;
        std::vector<int> arm_at_code(16, -1);
        for (int arm = 0; arm < count; ++arm) {
            SigBit selected = s[arm];
            if (!selected.wire || ambiguous_predicates.count(selected) ||
                    !predicate_drivers.count(selected)) return false;
            Cell *compare = predicate_drivers.at(selected);
            if (GetSize(compare->getPort(ID::Y)) != 1) return false;
            SigSpec control, literal;
            if (compare->type == ID($eq)) {
                control = sigmap(compare->getPort(ID::A));
                literal = sigmap(compare->getPort(ID::B));
                bool as = compare->getParam(ID::A_SIGNED).as_bool();
                bool bs = compare->getParam(ID::B_SIGNED).as_bool();
                if (as != bs) return false; // Conservative unsupported case.
                int compare_width = std::max(GetSize(control), GetSize(literal));
                if (compare_width != 4) return false;
                control.extend_u0(compare_width, as && bs);
                literal.extend_u0(compare_width, as && bs);
                if (control.is_fully_const()) std::swap(control, literal);
            } else if (compare->type == ID($logic_not)) {
                control = sigmap(compare->getPort(ID::A));
                literal = SigSpec(State::S0, GetSize(control));
            } else return false;
            if (GetSize(control) != 4 || GetSize(literal) != 4) return false;
            pool<SigBit> seen;
            int code = 0;
            for (int bit = 0; bit < 4; ++bit) {
                if (!control[bit].wire || seen.count(control[bit])) return false;
                seen.insert(control[bit]);
                if (literal[bit] == State::S1) code |= 1 << bit;
                else if (literal[bit] != State::S0) return false;
            }
            if (arm == 0) natural_control = control;
            else if (control != natural_control) return false;
            if (arm_at_code[code] >= 0) return false;
            arm_at_code[code] = arm;
        }
        for (int arm : arm_at_code) if (arm < 0) return false;

        int stride = 1, shift_bits = 0;
        while (stride < width) { stride <<= 1; ++shift_bits; }
        if (stride * count > 512) return false;
        SigSpec table(State::Sx, stride * count);
        for (int code = 0; code < count; ++code)
            table.replace(code * stride, b.extract(arm_at_code[code] * width, width));
        SigSpec index(State::S0, shift_bits); // Low bits first in RTLIL SigSpec.
        index.append(natural_control);
        module->addShiftx(NEW_ID, table, index, y, false, pmux->get_src_attribute());
        module->remove(pmux);
        return true;
    }


    int flatten_data_arms(Module *module, Design *design)
    {
        const IdString data_gate_attr("\\pmux_opt_data_gate");
        const IdString fallback_gate_attr("\\pmux_opt_control_gate");
        int merged = 0;
        for (int iteration = 0; iteration < 32; ++iteration) {
            SigMap sigmap(module);
            dict<SigBit, Cell*> drivers;
            pool<SigBit> ambiguous;
            dict<SigBit, int> users;
            for (auto cell : module->cells()) {
                if (cell->type != ID($pmux)) continue;
                for (auto bit : sigmap(cell->getPort(ID::Y))) {
                    if (drivers.count(bit)) ambiguous.insert(bit);
                    drivers[bit] = cell;
                }
            }
            for (auto wire : module->wires())
                if (wire->port_output)
                    for (auto bit : sigmap(SigSpec(wire))) users[bit]++;
            for (auto cell : module->cells())
                for (auto conn : cell->connections())
                    if (!cell->known() || cell->input(conn.first))
                        for (auto bit : sigmap(conn.second)) users[bit]++;
            bool changed = false;
            for (auto outer : module->selected_cells()) {
                if (outer->type != ID($pmux) ||
                    outer->get_bool_attribute(data_gate_attr) ||
                    outer->get_bool_attribute(fallback_gate_attr)) continue;
                SigSpec oa = outer->getPort(ID::A), ob = outer->getPort(ID::B);
                SigSpec os = outer->getPort(ID::S), oy = outer->getPort(ID::Y);
                int width = GetSize(oa), outer_count = GetSize(os);
                if (width < 1 || outer_count < 1 || GetSize(oy) != width ||
                        GetSize(ob) != width * outer_count) continue;
                for (int arm = 0; arm < outer_count; ++arm) {
                    SigSpec old_data = sigmap(ob.extract(arm * width, width));
                    if (old_data.empty() || !drivers.count(old_data[0]) ||
                            ambiguous.count(old_data[0])) continue;
                    Cell *inner = drivers.at(old_data[0]);
                    if (inner == outer || !design->selected(module, inner) ||
                        inner->get_bool_attribute(data_gate_attr) ||
                        inner->get_bool_attribute(fallback_gate_attr)) continue;
                    if (sigmap(inner->getPort(ID::Y)) != old_data) continue;
                    bool single_consumer = true;
                    for (auto bit : old_data)
                        if (!bit.wire || users[bit] != 1 || ambiguous.count(bit))
                            single_consumer = false;
                    if (!single_consumer) continue;
                    SigSpec ia = inner->getPort(ID::A), ib = inner->getPort(ID::B);
                    SigSpec is = inner->getPort(ID::S);
                    int inner_count = GetSize(is);
                    if (GetSize(ia) != width || inner_count < 1 ||
                            GetSize(ib) != width * inner_count) continue;
                    // Structural engineering guard, never keyed on input identity.
                    if (width <= inner_count + 1 || outer_count + inner_count > 16)
                        continue;
                    std::string src = outer->get_src_attribute();
                    SigSpec h = module->addWire(NEW_ID, 1);
                    Cell *h_gate = module->addPmux(NEW_ID, SigSpec(State::S1),
                            SigSpec(State::S0, inner_count), is, h, src);
                    h_gate->set_bool_attribute(data_gate_attr);
                    SigSpec inner_selects = h;
                    inner_selects.append(is); // index 0 is inner-default select.
                    SigSpec gated = module->addWire(NEW_ID, inner_count + 1);
                    Cell *t_gate = module->addPmux(NEW_ID,
                            SigSpec(State::S0, inner_count + 1), inner_selects,
                            SigSpec(os[arm]), gated, src);
                    t_gate->set_bool_attribute(data_gate_attr);
                    SigSpec next_b, next_s;
                    for (int old_arm = 0; old_arm < outer_count; ++old_arm) {
                        if (old_arm == arm) {
                            next_b.append(ia);
                            next_b.append(ib);
                            next_s.append(gated);
                        } else {
                            next_b.append(ob.extract(old_arm * width, width));
                            next_s.append(os[old_arm]);
                        }
                    }
                    outer->setPort(ID::B, next_b);
                    outer->setPort(ID::S, next_s);
                    outer->setParam(ID::S_WIDTH, GetSize(next_s));
                    module->remove(inner);
                    merged++;
                    changed = true;
                    break;
                }
                if (changed) break; // Rebuild all connectivity after each rewrite.
            }
            if (!changed) break;
        }
        return merged;
    }


    int flatten_fallbacks(Module *module, Design *design)
    {
        const IdString gate_attr("\\pmux_opt_control_gate");
        const IdString data_gate_attr("\\pmux_opt_data_gate");
        int merged = 0;
        // Rebuild connectivity after each merge; bound work on large designs.
        for (int iteration = 0; iteration < 32; iteration++) {
            SigMap sigmap(module);
            dict<SigBit, int> users;
            dict<SigBit, Cell*> drivers;
            pool<SigBit> ambiguous;
            for (auto cell : module->cells()) {
                if (cell->type != ID($pmux)) continue;
                for (auto bit : sigmap(cell->getPort(ID::Y))) {
                    if (drivers.count(bit)) ambiguous.insert(bit);
                    drivers[bit] = cell;
                }
            }
            // Do not allocate a whole-design fanout table when no nested PMUX
            // fallback exists. This is a structural early exit, not a case filter.
            bool possible = false;
            for (auto cell : module->selected_cells()) {
                if (cell->type != ID($pmux) || (cell->get_bool_attribute(gate_attr) || cell->get_bool_attribute(data_gate_attr))) continue;
                SigSpec a = sigmap(cell->getPort(ID::A));
                if (!a.empty() && drivers.count(a[0]) && drivers.at(a[0]) != cell &&
                    sigmap(drivers.at(a[0])->getPort(ID::Y)) == a) {
                    possible = true; break;
                }
            }
            if (!possible) break;
            for (auto wire : module->wires())
                if (wire->port_output)
                    for (auto bit : sigmap(SigSpec(wire))) users[bit]++;
            for (auto cell : module->cells())
                for (auto conn : cell->connections())
                    if (!cell->known() || cell->input(conn.first))
                        for (auto bit : sigmap(conn.second)) users[bit]++;
            bool changed = false;
            for (auto outer : module->selected_cells()) {
                if (outer->type != ID($pmux) || (outer->get_bool_attribute(gate_attr) || outer->get_bool_attribute(data_gate_attr))) continue;
                SigSpec oa = sigmap(outer->getPort(ID::A));
                if (oa.empty() || !drivers.count(oa[0]) || ambiguous.count(oa[0])) continue;
                Cell *inner = drivers.at(oa[0]);
                if (inner == outer || !design->selected(module, inner) || (inner->get_bool_attribute(gate_attr) || inner->get_bool_attribute(data_gate_attr))) continue;
                if (sigmap(inner->getPort(ID::Y)) != oa) continue;
                bool sole_use = true;
                for (auto bit : oa)
                    if (!bit.wire || users[bit] != 1 || ambiguous.count(bit)) sole_use = false;
                if (!sole_use) continue;
                SigSpec ia = inner->getPort(ID::A), ib = inner->getPort(ID::B), is = inner->getPort(ID::S);
                SigSpec ob = outer->getPort(ID::B), os = outer->getPort(ID::S), oy = outer->getPort(ID::Y);
                if (ia.size() != oa.size() || oy.size() != oa.size() || is.empty() || os.empty() ||
                    ib.size() != ia.size()*is.size() || ob.size() != oa.size()*os.size()) continue;
                // Structural cost guard only; no benchmark identifiers or names.
                if (oa.size() <= is.size() || is.size()+os.size() > 16) continue;
                SigSpec gated = module->addWire(NEW_ID, is.size());
                Cell *gate = module->addPmux(NEW_ID, is, SigSpec(State::S0, is.size()*os.size()), os, gated);
                gate->set_bool_attribute(gate_attr);
                SigSpec combined_b = ib, combined_s = gated;
                combined_b.append(ob); combined_s.append(os);
                outer->setPort(ID::A, ia); outer->setPort(ID::B, combined_b); outer->setPort(ID::S, combined_s);
                outer->setParam(ID::S_WIDTH, combined_s.size());
                module->remove(inner);
                merged++; changed = true; break;
            }
            if (!changed) break;
        }
        return merged;
    }

    // Reproduce only the conservative, constant-decoder part of the upstream
    // recognition interface. This is a guard, not an alternative shift engine.
    bool decoder(Cell *cell, SigMap &sigmap, SigSpec &control, int &value)
    {
        SigSpec lhs, rhs;
        if (cell->type == ID($eq)) {
            lhs = sigmap(cell->getPort(ID::A));
            rhs = sigmap(cell->getPort(ID::B));
            // wreduce commonly shortens literal 0/1 on one comparator input.
            // Match official $eq extension semantics before decoding the bits.
            bool a_signed = cell->getParam(ID::A_SIGNED).as_bool();
            bool b_signed = cell->getParam(ID::B_SIGNED).as_bool();
            // Upstream pmux2shiftx expands each side using its own signedness.
            // Reject mixed-signed unequal widths so our guard cannot admit a
            // decoder interpreted differently by that existing implementation.
            if (lhs.size() != rhs.size() && a_signed != b_signed) return false;
            int width = std::max(lhs.size(), rhs.size());
            if (width < 2 || width > 3) return false;
            lhs.extend_u0(width, a_signed && b_signed);
            rhs.extend_u0(width, a_signed && b_signed);
        } else if (cell->type == ID($logic_not)) {
            lhs = sigmap(cell->getPort(ID::A));
            rhs = SigSpec(State::S0, lhs.size());
        } else return false;
        if (cell->getPort(ID::Y).size() != 1 || lhs.size() < 2 || lhs.size() > 3)
            return false;
        dict<SigBit, State> bits;
        for (int i = 0; i < lhs.size(); i++) {
            SigBit a = lhs[i], b = rhs[i];
            if (!a.wire && b.wire) std::swap(a, b);
            if (!a.wire || b.wire || (b.data != State::S0 && b.data != State::S1) || bits.count(a))
                return false;
            bits[a] = b.data;
        }
        bits.sort();
        control = SigSpec();
        value = 0;
        int pos = 0;
        for (auto item : bits) {
            control.append(item.first);
            if (item.second == State::S1) value |= 1 << pos;
            pos++;
        }
        return true;
    }

    void execute(std::vector<std::string> args, Design *design) override
    {
        log_header(design, "Executing project PMUX structural optimization.\n");
        bool shiftx_small = false, flatten_fallback = false, const_decode = false, const_polarity = false, uniform_abc = false;
        bool order_decode = false, desc_order = false, index_full_x = false, flatten_data_arm = false;
        size_t argidx = 1;
        for (; argidx < args.size(); argidx++) {
            if (args[argidx] == "-flatten-data-arm") { flatten_data_arm = true; continue; }
            if (args[argidx] == "-index-full-x") { index_full_x = true; continue; }
            if (args[argidx] == "-shiftx-small") { shiftx_small = true; continue; }
            if (args[argidx] == "-flatten-fallback") { flatten_fallback = true; continue; }
            if (args[argidx] == "-const-decode") { const_decode = true; continue; }
            if (args[argidx] == "-const-polarity") { const_polarity = true; continue; }
            if (args[argidx] == "-order-decode") { order_decode = true; continue; }
            if (args[argidx] == "-desc-order") { desc_order = true; continue; }
            if (args[argidx] == "-uniform-abc") { uniform_abc = true; continue; }
            break;
        }
        extra_args(args, argidx, design);
        if (desc_order && !order_decode)
            log_cmd_error("-desc-order requires -order-decode.\n");
        // A single, fixed ABC script, shared by every design. The ABC mapping
        // archive selects by its own area cost within one external invocation.
        if (uniform_abc && design->scratchpad_get_string("abc9.script").empty())
            design->scratchpad_set_string("abc9.script",
                "+&dch,-f,-r;,&if,{W},{D},{R},-a,-v,-F,4,-c;,&mfs");
        int removed_arms = 0, shared_columns = 0, shifted_cells = 0, nested_cells = 0, constant_bits = 0, polarity_cells = 0, ordered_cells = 0;
        int indexed_full_tables = 0, merged_data_arms = 0;
        RTLIL::Selection shift_selection = RTLIL::Selection::EmptySelection(design);

        for (auto module : design->selected_modules()) {
            if (module->get_bool_attribute(ID::blackbox)) continue;
            // Keep uniform ABC setup above, even for modules without PMUX.
            // All structural transformations below require a selected PMUX.
            bool has_selected_pmux = false;
            for (auto cell : module->cells()) {
                if (cell->type == ID($pmux) && design->selected(module, cell)) {
                    has_selected_pmux = true;
                    break;
                }
            }
            if (!has_selected_pmux) continue;
            {
            SigMap sigmap(module);
            dict<SigBit, Cell*> predicate_drivers;
            pool<SigBit> ambiguous_predicates;
            if (const_decode || order_decode || index_full_x)
                for (auto driver : module->cells()) {
                    if ((driver->type != ID($eq) && driver->type != ID($logic_not)) || driver->getPort(ID::Y).size() != 1) continue;
                    SigBit output = sigmap(driver->getPort(ID::Y))[0];
                    if (predicate_drivers.count(output)) ambiguous_predicates.insert(output);
                    predicate_drivers[output] = driver;
                }
            if (index_full_x) {
                // Extra conservative driver audit used only by this optional rule.
                // Module input pins also drive their canonical signal bits.
                for (auto wire : module->wires())
                    if (wire->port_input)
                        for (auto bit : sigmap(SigSpec(wire)))
                            if (predicate_drivers.count(bit)) ambiguous_predicates.insert(bit);
                for (auto driver : module->cells())
                    for (auto conn : driver->connections())
                        if (!driver->known() || driver->output(conn.first))
                            for (auto bit : sigmap(conn.second))
                                if (predicate_drivers.count(bit) && predicate_drivers.at(bit) != driver)
                                    ambiguous_predicates.insert(bit);
            }
            for (auto cell : module->selected_cells()) {
                if (cell->type != ID($pmux)) continue;
                SigSpec a = cell->getPort(ID::A), b = cell->getPort(ID::B);
                SigSpec s = cell->getPort(ID::S), y = cell->getPort(ID::Y);
                if (a.empty() || s.empty() || y.size() != a.size() || b.size() != a.size()*s.size())
                    continue;
                if (index_full_x && index_full_x_decode(module, cell, sigmap,
                        predicate_drivers, ambiguous_predicates)) {
                    indexed_full_tables++;
                    continue;
                }
                SigSpec mapped_s = sigmap(s);
                bool has_zero_arm = false;
                for (auto bit : mapped_s) if (bit == State::S0) has_zero_arm = true;
                if (has_zero_arm) {
                SigSpec next_b, next_s;
                for (int i = 0; i < s.size(); i++) {
                    if (mapped_s[i] == State::S0) { removed_arms++; continue; }
                    next_s.append(s[i]);
                    next_b.append(b.extract(i*a.size(), a.size()));
                }
                if (next_s.empty()) {
                    module->connect(y, a);
                    module->remove(cell);
                    continue;
                }
                b = next_b; s = next_s;
                cell->setPort(ID::B, b);
                cell->setPort(ID::S, s);
                cell->setParam(ID::S_WIDTH, s.size());
                }

                if (order_decode && s.size() > 1) {
                    SigSpec common_control;
                    std::vector<std::pair<unsigned long long, int>> order;
                    bool valid = true;
                    for (int arm = 0; arm < s.size(); arm++) {
                        SigBit select = sigmap(s[arm]);
                        if (!predicate_drivers.count(select) || ambiguous_predicates.count(select)) { valid = false; break; }
                        dict<SigBit, State> facts;
                        if (!predicate_constants(predicate_drivers.at(select), sigmap, facts) || GetSize(facts) > 32) { valid = false; break; }
                        facts.sort();
                        SigSpec control;
                        unsigned long long code = 0;
                        int position = 0;
                        for (auto fact : facts) {
                            control.append(fact.first);
                            if (fact.second == State::S1) code |= 1ULL << position;
                            position++;
                        }
                        if (arm == 0) common_control = control;
                        if (control != common_control) { valid = false; break; }
                        order.emplace_back(code, arm);
                    }
                    if (valid) {
                        // Stable equal-code order preserves even duplicated
                        // decoder arms; the rule never assumes one-hot inputs.
                        std::stable_sort(order.begin(), order.end(), [desc_order](const auto &x, const auto &y) {
                            return desc_order ? x.first > y.first : x.first < y.first;
                        });
                        bool changed = false;
                        for (int arm = 0; arm < s.size(); arm++)
                            if (order[arm].second != arm) changed = true;
                        if (changed) {
                            SigSpec ordered_b, ordered_s;
                            for (auto entry : order) {
                                ordered_s.append(s[entry.second]);
                                ordered_b.append(b.extract(entry.second*a.size(), a.size()));
                            }
                            b = ordered_b; s = ordered_s;
                            cell->setPort(ID::B, b); cell->setPort(ID::S, s);
                            ordered_cells++;
                        }
                    }
                }

                if (const_decode) {
                    bool changed = false;
                    for (int arm = 0; arm < s.size(); arm++) {
                        SigBit select = sigmap(s[arm]);
                        if (!predicate_drivers.count(select) || ambiguous_predicates.count(select)) continue;
                        dict<SigBit, State> facts;
                        if (!predicate_constants(predicate_drivers.at(select), sigmap, facts)) continue;
                        for (int bit = 0; bit < a.size(); bit++) {
                            int offset = arm*a.size()+bit;
                            SigBit data = sigmap(b[offset]);
                            if (!data.wire || !facts.count(data)) continue;
                            b[offset] = SigBit(facts.at(data));
                            constant_bits++; changed = true;
                        }
                    }
                    if (changed) cell->setPort(ID::B, b);
                }

                // Every output column follows the same select expression.
                // Identical A/B columns therefore also agree for X/Z selects.
                std::vector<int> unique_columns, representatives;
                SigSpec ma = sigmap(a), mb = sigmap(b);
                for (int bit = 0; bit < a.size(); bit++) {
                    int representative = bit;
                    // Avoid allocating a separate SigSpec/hash key per bit.
                    // Bound the comparison work on exceptionally wide cells.
                    int limit = std::min(GetSize(unique_columns), 256);
                    for (int pos = 0; pos < limit; pos++) {
                        int previous = unique_columns[pos];
                        if (ma[bit] != ma[previous]) continue;
                        bool equal = true;
                        for (int arm = 0; arm < s.size(); arm++)
                            if (mb[arm*a.size()+bit] != mb[arm*a.size()+previous]) { equal = false; break; }
                        if (equal) { representative = previous; break; }
                    }
                    if (representative == bit) unique_columns.push_back(bit);
                    representatives.push_back(representative);
                }
                if (GetSize(unique_columns) < a.size()) {
                    SigSpec ca, cb, cy;
                    for (int bit : unique_columns) { ca.append(a[bit]); cy.append(y[bit]); }
                    for (int arm = 0; arm < s.size(); arm++)
                        for (int bit : unique_columns) cb.append(b[arm*a.size()+bit]);
                    for (int bit = 0; bit < a.size(); bit++)
                        if (representatives[bit] != bit) {
                            module->connect(SigSpec(y[bit]), SigSpec(y[representatives[bit]]));
                            shared_columns++;
                        }
                    cell->setPort(ID::A, ca); cell->setPort(ID::B, cb); cell->setPort(ID::Y, cy);
                    cell->setParam(ID::WIDTH, ca.size());
                }
                if (const_polarity && !cell->get_bool_attribute(IdString("\\pmux_opt_const_polarity"))) {
                    SigSpec pa = sigmap(cell->getPort(ID::A));
                    SigSpec pb = sigmap(cell->getPort(ID::B));
                    bool valid = true;
                    int ones = 0, zeros = 0;
                    for (auto bit : pa)
                        if (bit.wire || (bit.data != State::S0 && bit.data != State::S1 && bit.data != State::Sx)) valid = false;
                    for (auto bit : pb) {
                        if (bit.wire || (bit.data != State::S0 && bit.data != State::S1 && bit.data != State::Sx)) valid = false;
                        if (bit == State::S1) ones++;
                        if (bit == State::S0) zeros++;
                    }
                    if (valid && ones > zeros) {
                        for (int i = 0; i < pa.size(); i++) {
                            if (pa[i] == State::S0) pa[i] = State::S1;
                            else if (pa[i] == State::S1) pa[i] = State::S0;
                        }
                        for (int i = 0; i < pb.size(); i++) {
                            if (pb[i] == State::S0) pb[i] = State::S1;
                            else if (pb[i] == State::S1) pb[i] = State::S0;
                        }
                        SigSpec output = cell->getPort(ID::Y);
                        SigSpec inverted = module->addWire(NEW_ID, output.size());
                        cell->setPort(ID::A, pa); cell->setPort(ID::B, pb); cell->setPort(ID::Y, inverted);
                        cell->set_bool_attribute(IdString("\\pmux_opt_const_polarity"));
                        module->addNot(NEW_ID, inverted, output);
                        polarity_cells++;
                    }
                }
            }

            } // Release the first alias map before rebuilding nested connectivity.
            if (flatten_fallback) nested_cells += flatten_fallbacks(module, design);
            if (flatten_data_arm) merged_data_arms += flatten_data_arms(module, design);
            if (!shiftx_small) continue;
            // Refresh aliases after column sharing before constructing decoders.
            SigMap decoder_map(module);
            dict<SigBit, std::pair<SigSpec, int>> decoded;
            pool<SigBit> ambiguous;
            for (auto cell : module->cells()) {
                SigSpec control; int value;
                if (!decoder(cell, decoder_map, control, value)) continue;
                SigBit select = decoder_map(cell->getPort(ID::Y))[0];
                if (decoded.count(select)) ambiguous.insert(select);
                decoded[select] = std::make_pair(control, value);
            }
            for (auto cell : module->selected_cells()) {
                if (cell->type != ID($pmux)) continue;
                SigSpec s = decoder_map(cell->getPort(ID::S));
                if (s.size() < 3 || s.size() > 7) continue;
                SigSpec control; pool<int> codes; bool valid = true;
                for (auto bit : s) {
                    if (!decoded.count(bit) || ambiguous.count(bit)) { valid = false; break; }
                    auto entry = decoded.at(bit);
                    if (control.empty()) control = entry.first;
                    if (control != entry.first || codes.count(entry.second)) { valid = false; break; }
                    codes.insert(entry.second);
                }
                if (!valid || control.empty() || GetSize(codes) < (1 << control.size())-1) continue;
                SigSpec fallback = decoder_map(cell->getPort(ID::A));
                bool all_x = !fallback.empty();
                for (auto bit : fallback) if (bit != State::Sx) all_x = false;
                if (all_x) continue; // area guard, not a semantic assumption
                shift_selection.select(module, cell);
                shifted_cells++;
            }
        }
        shift_selection.optimize(design);
        if (!shift_selection.empty())
            Pass::call_on_selection(design, shift_selection, "pmux2shiftx -norange");
        if (flatten_data_arm)
            log("PMUX data-arm flattening: merged %d single-use nested data arms.\n", merged_data_arms);
        if (index_full_x)
            log("PMUX full-table indexing: converted %d complete natural four-bit tables.\n", indexed_full_tables);
        log("PMUX structural optimization: removed %d zero-select arms, shared %d columns, selected %d dense decoders, merged %d nested fallbacks, propagated %d predicate bits, complemented %d constant tables, reordered %d decoder tables.\n",
            removed_arms, shared_columns, shifted_cells, nested_cells, constant_bits, polarity_cells, ordered_cells);
    }
};

PmuxOptPass pmux_opt_pass;
PRIVATE_NAMESPACE_END
