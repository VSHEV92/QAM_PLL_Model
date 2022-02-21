
`timescale 1ns / 1ns

module QAM_PLL_dpi
( 
    input clk,
	input reset,
	input clk_enable,
    
/* Simulink signal name: 'InData' Complex Signal Name: 'creal_T' */
	/* Simulink signal name: 're' */
	input real InData_re ,
	/* Simulink signal name: 'im' */
	input real InData_im ,
/* Simulink signal name: 'KP' */
input real KP ,
/* Simulink signal name: 'KI' */
input real KI ,
/* Simulink signal name: 'Enable' */
input byte unsigned Enable ,

/* Simulink signal name: 'OutData' Complex Signal Name: 'creal_T' */
	/* Simulink signal name: 're' */
	output real OutData_re ,
	/* Simulink signal name: 'im' */
	output real OutData_im ,
/* Simulink signal name: 'PhaseError' */
output real PhaseError ,
/* Simulink signal name: 'FreqError' */
output real FreqError 
); 

    parameter loop_factor = 1;
    parameter overclocking_factor = 5;
    reg [63:0] overclocking_counter;

    chandle objhandle=null;

real  OutData_re_temp;
real  OutData_im_temp;
real  PhaseError_temp;
real  FreqError_temp;

    import "DPI-C" function chandle DPI_QAM_PLL_initialize(chandle existhandle);
    import "DPI-C" function void DPI_QAM_PLL_output(input chandle objhandle,
/*Simulink signal name: 're'*/
input real InData_re,
/*Simulink signal name: 'im'*/
input real InData_im,
/*Simulink signal name: 'KP'*/
input real KP,
/*Simulink signal name: 'KI'*/
input real KI,
/*Simulink signal name: 'Enable'*/
input byte unsigned Enable,
/*Simulink signal name: 're'*/
inout real OutData_re,
/*Simulink signal name: 'im'*/
inout real OutData_im,
/*Simulink signal name: 'PhaseError'*/
inout real PhaseError,
/*Simulink signal name: 'FreqError'*/
inout real FreqError);
    import "DPI-C" function void DPI_QAM_PLL_update(input chandle objhandle,
/*Simulink signal name: 're'*/
input real InData_re,
/*Simulink signal name: 'im'*/
input real InData_im,
/*Simulink signal name: 'KP'*/
input real KP,
/*Simulink signal name: 'KI'*/
input real KI,
/*Simulink signal name: 'Enable'*/
input byte unsigned Enable);
    

	always @(reset) begin
        objhandle = DPI_QAM_PLL_initialize(objhandle);
        overclocking_counter <= 64'b1;
	end 

	always @(posedge clk) begin 
        if(clk_enable == 1'b1) begin
            if(overclocking_counter==1) begin
                for(int ii=0; ii < loop_factor; ii=ii+1) begin       
                    DPI_QAM_PLL_output(objhandle,
InData_re, InData_im, KP, KI, Enable, OutData_re_temp, OutData_im_temp, PhaseError_temp, FreqError_temp);
                    DPI_QAM_PLL_update(objhandle,
InData_re, InData_im, KP, KI, Enable);   
                end
                OutData_re <=OutData_re_temp;
OutData_im <=OutData_im_temp;
PhaseError <=PhaseError_temp;
FreqError <=FreqError_temp;

            end
            if(overclocking_counter == overclocking_factor)
                overclocking_counter <= 64'b1;
            else
                overclocking_counter <= overclocking_counter + 1'b1;
        end
	end

endmodule


