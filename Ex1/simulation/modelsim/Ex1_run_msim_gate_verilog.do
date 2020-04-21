transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {Ex1_8_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+D:/MyProject/CEET/Ex1 {D:/MyProject/CEET/Ex1/tb_Ex1.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  tb_Ex1

add wave *
view structure
view signals
run -all
