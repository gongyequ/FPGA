from pathlib import Path
import json

root=Path(__file__).resolve().parent
raw=json.loads((root/'答疑原文_完整提取.json').read_text(encoding='utf-8'))
cells={c['cell']:c['value'] for c in raw['sheets'][0]['cells']}
requirements=[]
def rule(key,title,decision,refs,**fields):
    requirements.append({'id':key,'标题':title,'执行口径':decision,
                         '依据':[{'位置':'Sheet1!'+r,'原文':cells[r]} for r in refs],**fields})

rule('baseline','基线版本','大版本必须为0.69，允许0.69范围内小版本差异。固定所选公开提交；原版与优化版使用对应的同一ABC版本、同一构建环境与参数进行成对比较。不得把0.70当合规基线。',['C92','C161','C162','C165'],major_version='0.69',micro_version_choice_allowed=True,official_baseline_unmodified=True)
rule('integration','统一入口及插件接入','新增优化pass静态编入yosys.exe，并在synth_intel默认路径中调用。原版和优化版用相同脚本，仅替换可执行程序；不能依赖仅候选才有的外部脚本命令或选项，不使用动态plugin加载方案。',['C24','C37','C41','C53','C145','C165'],required_command='synth_intel -family cycloneiv -top <top>',script_flag='-s')
rule('allowed_changes','允许与禁止的改动','允许新增优化pass与修改ABC脚本。ABC必须为所选Yosys对应版本并保留ABC9流程；所有用例用同一ABC脚本。不允许修改其他原有pass/依赖程序代码，不允许调节原有调用顺序，不得额外多次调用ABC。ABC9后、map_cells前自定义$lut重构明确不允许。新增pass的插入位置可在synth_intel内部调试，但不能把这解释成自由重排既有pass。',['C22','C23','C53','C114','C130','C147','C162','C166'],uniform_abc_script=True,extra_abc_calls_allowed=False,post_abc_lut_rewrite_allowed=False)
rule('case_set','测评集合和参数','第一批4例加第二批5例，全部9例纳入。第二批同时用于效率测试，面积优化率也算全部用例逐例平均；用例之外电路不测。保留原始RTL、顶层名和默认LANES/WIDTH参数，不对案例特判。',['C115','C146','C147','C150','C165'],official_case_count=9,default_parameters=True)
rule('area','逻辑面积口径','对每个用例计算(原版逻辑单元数-优化版逻辑单元数)/原版逻辑单元数，最后对9个比例取算术平均，不按总单元数加权。逻辑单元包括LUT及取反单元；不把DFF/IO直接并入逻辑面积。任何单例逻辑面积不得增加。',['C21','C25','C53','C67','C115','C130'],logic_count_formula='LUT_count + inverter_count',per_case_formula='(baseline_logic - candidate_logic) / baseline_logic',aggregate='arithmetic_mean_over_all_9_cases',any_case_logic_increase_allowed=False)
rule('nonlogic','其他资源','最新口径为DFF或IO相对原版增幅超过20%会影响评分；先前“DFF不得增加”或“DFF不关注”被更具体的最新答复修正。保留各类原始cell计数；当基线为0时增幅无定义，应单独报告新增数量，不把除零当0%或通过。',['C53','C130','C166'],dff_io_increase_threshold_fraction=0.20)
rule('time','运行时间','最终明确是墙钟时间，覆盖整个Yosys进程从启动到结束的完整综合流程：启动/初始化、读取RTL、综合含ABC、脚本中输出等。编译C++构建Yosys的时间与EQY证明时间不计。用Windows同一测量工具同时测试原版和优化版；早先CPU口径由后来的明确纠正覆盖。',['C68','C87','C92','C101','C102','C147','C151','C165'],metric='wall_clock_process_start_to_exit',source_build_time_included=False,eqy_time_included=False,abc_elapsed_time_included=True)
rule('memory','运行内存','只看yosys.exe主进程峰值工作内存；不是提交内存，也不是所有子进程峰值之和。时间和内存必须在同一次综合运行中测得，原版与优化版使用同一工具。建议使用Windows Process.PeakWorkingSet64或对应Win32峰值工作集接口，不把定期采样的低估当峰值。',['C54','C133','C147','C165'],process='yosys_main_only',metric='peak_working_set_bytes',measure_in_same_run_as_time=True)
rule('efficiency','5%与15%分母及逐例要求','对每个用例分别计算时间和内存相对原版的增幅：(候选-原版)/原版。每例两项均不超过5%为效率满分条件；任一例任一项超过15%则效率项不得分。5%/15%不是60秒或2GB的百分比；处于5%到15%的具体线性扣分公式并未给出，不能自行发明准确分数。',['C41','C86','C87','C105','C166'],full_score_overhead_fraction=0.05,zero_score_overhead_strictly_greater_than=0.15,per_case=True)
rule('warmup','预热','测试开始或系统重启后的预热事件：只用原版，对pmux_case05_nested运行10次，然后开始正式测试。不是每个case各10次，也不是只跑1次命令。',['C132','C148','C164','C166'],warmup_variant='baseline',warmup_top='pmux_case05_nested',warmup_runs=10)
rule('review','初测与复核','初测原版先跑、优化版后跑；后台环境一致。任一性能指标相对开销超过5%时，小用例可复核5次；1~10秒按小用例复核，10秒以上只有一次机会。复核时原版和优化版都运行5次，分别求平均后计算比值，不能使用中位数、最好一次或先算比例再平均。首测是否计入5次、恰好10秒边界仍未被完全统一，实施选择应公开且不能择优。',['C91','C132','C147','C164','C166'],initial_order=['baseline','candidate'],review_trigger='any_time_or_memory_overhead_above_0.05',review_repeats_per_variant=5,review_aggregation='ratio_of_variant_means',recommended_explicit_choice='五对全新复核样本，不含触发初测；max(原版时间,候选时间)>=10秒保守视为单次机会。此为工程选择，不冒称官方原文。')
rule('eqy_boundary','形式等价检查边界','使用synth_intel -family cycloneiv，证明ABC之后、最终CycloneIV技术单元映射之前的输出，导出ilang进行EQY，与gold比较。应实际执行ABC/ABC9后再导出，不能把-range结束标签尚未执行的文件称为post-ABC。允许整设计证明模式；EQY版本、验证策略可选择，提交脚本。',['C53','C54','C105','C165','C166'],boundary='after_abc9_before_final_cycloneiv_mapping',required_status='EQY_PASS_all_9',whole_design_strategy_allowed=True)
rule('eqy_unknowns','初值与未知值','答疑允许“按0初始化”，最新写明“x/z按0初始化，验证方法策略自行修改决定”。这是验证语义许可，并不自动证明优化规则严格保留四态X。应记录对哪些对象、在什么阶段归一化；已有显式初值/ROM应保留。关于综合前还是综合后补0的具体追问，C167仅回复“见上面答复”，故该细节仍无精准官方定义。不得通过删输出、约束掉合法输入或只证明中间小片段伪造全设计PASS。',['C149','C166','B167','C167'],normalization='zero_initialization_per_disclosed_verification_strategy',normalization_stage_fully_specified_by_official=False)
rule('delivery','交付和环境','提交优化源码、新增pass、修改的ABC脚本、编译后的Windows yosys.exe及运行依赖，提供EQY验证脚本。解包可启动、相对路径配置。EQY/OSS CAD Suite验证环境可由赛事方预装；版本/路径需外部配置，不能硬编码本机绝对路径。赛事方WSL支持并非已保证。选题二不要求开发板/eLinx工程或eLinx仿真报告。',['C55','C66','C71','C106','C116','C131','C152','C163','C166','C168'],require_eqy_script=True,relative_paths=True,native_windows_exe_preferred=True)

result={'source':raw['source'],'source_sha256':raw['sha256'],'sheet':'Sheet1','nonempty_cells':len(raw['sheets'][0]['cells']),
        'precedence':'按答疑后文明确修订覆盖先前冲突；问题文字不等于官方回答；仅允许条款按其精确范围解释。',
        'requirements':requirements,
        'guide_targets_from_user_screenshot':{
            'area_mean_reduction_min_fraction':0.10,'area_full_score_reduction_fraction':0.20,
            'absolute_runtime_seconds':60,'absolute_memory_text':'2GB','node_limit_cells':1000,
            'weights':{'functional_correctness':10,'area':40,'efficiency':30,'design_document':5,'defense':15},
            'source':'用户本轮提供的选题指南截图，第4页和第5页。数值没有在答疑文件中重新列齐；不要将此项误写为仅来自xlsx。',
            'absolute_limit_exception':'Sheet1!C37：若原版超过，优化版超过也允许；相对原版的性能要求仍适用。'},
        'unresolved_not_blocking_implementation':[
            'C167未明确X/Z/未定初值归一化发生在综合前还是证明阶段；自行选择并披露，保留原始RTL和原始网表。',
            'C132/C147在恰好10秒阈值处措辞有交叠；初测是否计入复核5次未直接答复。',
            'C163/C168赛事方预装验证环境路径、版本、是否有WSL仍需赛事方告知；交付提供相对路径和可配置工具路径。',
            'C149/C166未正面说明自研规则消融是否必交或最低独立收益；没有足够依据声称存在额外最低比例。',
            '效率5%到15%之间精确扣分函数、DFF/IO超过20%具体扣分量未明确。'],
        'scope_note':'本文件是验收口径整理，不是测试通过报告，也不保证将来的实现达标。'}
(root/'最终验收标准.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
lines=['零点六九基线重做：最终验收标准（依据2026-11-03收到的最新版答疑）',
       f'原文文件：{raw["source"]}',f'SHA256：{raw["sha256"]}',
       '工作表：Sheet1。提取全部236个非空单元格，包含题一内容；以下只整理题二。',
       '优先级：后文明确修订覆盖先前冲突。提问本身不是官方规定；未回答部分不得当已确认。']
for n,r in enumerate(requirements,1):
    lines.append(f'\n{n}、{r["标题"]}\n{r["执行口径"]}\n依据：'+', '.join(x['位置'] for x in r['依据']))
    for cite in r['依据']:
        lines.append(f'[{cite["位置"]}] {cite["原文"]}')
lines.extend(['\n题目截图中的指标与评分：平均面积缩减至少10%；20%以上面积项满分；完整优化<=60秒、峰值<=2GB、规模<=1000cells。功能10分、面积40分、效率30分、文档5分、答辩15分。依据为用户本轮提供的指南截图第4/5页。C37允许原版超绝对限制时优化版也可超，但仍比较相对开销。',
              '\n需要如实披露、但不应阻碍现在推进的细节：',*['- '+s for s in result['unresolved_not_blocking_implementation']],
              '\n旧项目迁移时最重要的修正：',
              '- 0.70必须迁移到0.69；不能只把版本字符串改成0.69。',
              '- 删除按case名或按结构选择不同ABC脚本的配置，全部9例统一一个脚本。',
              '- 不得新增ABC后$lut重构；不得改其他既有pass代码或调换原调用顺序来抵消开销。',
              '- 面积计数包含取反单元。旧RAR_Test1中286 LUT+2 $not=288逻辑单元；不能只看286。',
              '- 性能以墙钟+主进程峰值工作集，同一次运行取得；按新预热/复核规则，不再用每例7次中位数代替正式判定。',
              '- 最终EQY确实取ABC后边界；旧范围map_bram:map_luts在该版本的命令范围语义中会在执行map_luts前停下，不能沿用旧命名作最终证明。',
              '- X归一化策略允许自行决定，但要解释对象、阶段及语义范围；未初始化/X边界测试不能被悄悄删除。',
              '\n本文件整理验收口径，不是任何实现的达标证书。'])
(root/'最终验收标准.txt').write_text('\n\n'.join(lines),encoding='utf-8')

focusrows=[8,9,20,21,22,23,24,25,26,34,37,41,53,54,55,66,67,68,69,70,71,72,73,86,87,88,89,90,91,92,101,102,104,105,106,107,114,115,116,117,130,131,132,133,134,145,146,147,148,149,150,151,152,161,162,163,164,165,166,167,168]
focus=[]
for row in focusrows:
    focus.extend([f'\n第{row}行',f'[Sheet1!B{row}] '+cells.get(f'B{row}',''),f'[Sheet1!C{row}] '+cells.get(f'C{row}','（未填写解答）')])
(root/'赛题二答疑_逐条原文.txt').write_text('\n\n'.join(focus),encoding='utf-8')
print('Created standards: '+str(len(requirements))+' sections; extracted '+str(len(raw['sheets'][0]['cells']))+' nonempty cells.')
