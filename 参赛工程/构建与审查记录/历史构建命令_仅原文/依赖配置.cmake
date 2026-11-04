add_library(PkgConfig::tcl INTERFACE IMPORTED GLOBAL)
set_target_properties(PkgConfig::tcl PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "R:/deps/tcl头文件8615" INTERFACE_LINK_LIBRARIES "R:/deps/tcl86.lib")
set(tcl_FOUND TRUE CACHE BOOL "Official Tcl DLL with MSVC import library")
