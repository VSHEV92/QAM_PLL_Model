vlib work

vlog HDL_Verifier_Source/*.sv
vlog model_tb.sv

vsim model_tb -sv_lib HDL_Verifier_Source/Signal_Source_win64 \
              -sv_lib HDL_Verifier_Source/Channel_win64 \
              -sv_lib HDL_Verifier_Source/QAM_PLL_win64 \

add wave -position end  sim:/model_tb/phase_offset
add wave -position end  sim:/model_tb/freq_offset
add wave -position end  sim:/model_tb/source_output_I
add wave -position end  sim:/model_tb/source_output_Q
add wave -position end  sim:/model_tb/channel_output_I
add wave -position end  sim:/model_tb/channel_output_Q
add wave -position end  sim:/model_tb/PLL_output_I
add wave -position end  sim:/model_tb/PLL_output_Q
add wave -position end  sim:/model_tb/PLL_phase_error
add wave -position end  sim:/model_tb/PLL_freq_error

run 3 ms