transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/lukes/Workspace/ELEC5566M-Mini-Project-el17ls {C:/Users/lukes/Workspace/ELEC5566M-Mini-Project-el17ls/KeyPressed.v}
vlog -vlog01compat -work work +incdir+C:/Users/lukes/Workspace/ELEC5566M-Mini-Project-el17ls {C:/Users/lukes/Workspace/ELEC5566M-Mini-Project-el17ls/LT24Display.v}
vlog -vlog01compat -work work +incdir+C:/Users/lukes/Workspace/ELEC5566M-Mini-Project-el17ls {C:/Users/lukes/Workspace/ELEC5566M-Mini-Project-el17ls/Top.v}

vlog -vlog01compat -work work +incdir+C:/Users/lukes/Workspace/ELEC5566M-Mini-Project-el17ls/output_files {C:/Users/lukes/Workspace/ELEC5566M-Mini-Project-el17ls/output_files/updatePixel_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  updatePixel_tb

add wave *
view structure
view signals
run -all
