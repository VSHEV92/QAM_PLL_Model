`timescale 1ns/1ps
module model_tb;

bit clk, reset = 1'b1, ce;

real phase_offset, freq_offset; 
real SNR, KP, KI;
bit PLL_enable;

real source_output_I, source_output_Q;
real channel_output_I, channel_output_Q;
real PLL_output_I, PLL_output_Q;
real PLL_phase_error, PLL_freq_error;

// тактовый сигнал
initial begin
    forever #10 clk = ~clk;
end

// сигнал сброса
initial begin
    #100 reset = 1'b0;
end

// сигналы управления 
assign ce = 1'b1;
assign phase_offset = 0;
assign freq_offset = 0.001;
assign SNR = 100;
assign KP = 0.01;
assign KI = 0.00001;
assign PLL_enable = 1'b1;


// источник сигнала
Signal_Source_dpi Signal_Source
( 
    .clk(clk),
	.reset(reset),
	.clk_enable(ce),
    .PhaseOffset(phase_offset),
    .FreqOffset(freq_offset),
	.Data_re(source_output_I),
	.Data_im(source_output_Q) 
); 

// канал
Channel_dpi Channel
( 
    .clk(clk),
	.reset(reset),
	.clk_enable(ce),
    .SNR(SNR),
	.DataIn_re(source_output_I),
	.DataIn_im(source_output_Q),
	.DataOut_re(channel_output_I),
	.DataOut_im(channel_output_Q) 
); 

// фазовая автомподстройка частоты
QAM_PLL_dpi QAM_PLL
( 
    .clk(clk),
	.reset(reset),
	.clk_enable(ce),
    .KP(KP),
    .KI(KI),
    .Enable(PLL_enable),
	.InData_re(channel_output_I),
	.InData_im(channel_output_Q),
    .OutData_re(PLL_output_I),
	.OutData_im(PLL_output_Q),
    .PhaseError(PLL_phase_error),
    .FreqError(PLL_freq_error) 
); 
endmodule