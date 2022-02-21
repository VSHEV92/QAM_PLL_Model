
`timescale 1ns / 1ns

module Channel_dpi
( 
    input clk,
	input reset,
	input clk_enable,
    
/* Simulink signal name: 'DataIn' Complex Signal Name: 'creal_T' */
	/* Simulink signal name: 're' */
	input real DataIn_re ,
	/* Simulink signal name: 'im' */
	input real DataIn_im ,
/* Simulink signal name: 'SNR' */
input real SNR ,

/* Simulink signal name: 'DataOut' Complex Signal Name: 'creal_T' */
	/* Simulink signal name: 're' */
	output real DataOut_re ,
	/* Simulink signal name: 'im' */
	output real DataOut_im 
); 

    parameter loop_factor = 1;
    parameter overclocking_factor = 5;
    reg [63:0] overclocking_counter;

    chandle objhandle=null;

real  DataOut_re_temp;
real  DataOut_im_temp;

    import "DPI-C" function chandle DPI_Channel_initialize(chandle existhandle);
    import "DPI-C" function void DPI_Channel_output(input chandle objhandle,
/*Simulink signal name: 're'*/
input real DataIn_re,
/*Simulink signal name: 'im'*/
input real DataIn_im,
/*Simulink signal name: 'SNR'*/
input real SNR,
/*Simulink signal name: 're'*/
inout real DataOut_re,
/*Simulink signal name: 'im'*/
inout real DataOut_im);
    import "DPI-C" function void DPI_Channel_update(input chandle objhandle,
/*Simulink signal name: 're'*/
input real DataIn_re,
/*Simulink signal name: 'im'*/
input real DataIn_im,
/*Simulink signal name: 'SNR'*/
input real SNR);
    

	always @(reset) begin
        objhandle = DPI_Channel_initialize(objhandle);
        overclocking_counter <= 64'b1;
	end 

	always @(posedge clk) begin 
        if(clk_enable == 1'b1) begin
            if(overclocking_counter==1) begin
                for(int ii=0; ii < loop_factor; ii=ii+1) begin       
                    DPI_Channel_output(objhandle,
DataIn_re, DataIn_im, SNR, DataOut_re_temp, DataOut_im_temp);
                    DPI_Channel_update(objhandle,
DataIn_re, DataIn_im, SNR);   
                end
                DataOut_re <=DataOut_re_temp;
DataOut_im <=DataOut_im_temp;

            end
            if(overclocking_counter == overclocking_factor)
                overclocking_counter <= 64'b1;
            else
                overclocking_counter <= overclocking_counter + 1'b1;
        end
	end

endmodule


