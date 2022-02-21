
`timescale 1ns / 1ns

module Signal_Source_dpi
( 
    input clk,
	input reset,
	input clk_enable,
    
/* Simulink signal name: 'PhaseOffset' */
input real PhaseOffset ,
/* Simulink signal name: 'FreqOffset' */
input real FreqOffset ,

/* Simulink signal name: 'Data' Complex Signal Name: 'creal_T' */
	/* Simulink signal name: 're' */
	output real Data_re ,
	/* Simulink signal name: 'im' */
	output real Data_im 
); 

    parameter loop_factor = 1;
    parameter overclocking_factor = 5;
    reg [63:0] overclocking_counter;

    chandle objhandle=null;

real  Data_re_temp;
real  Data_im_temp;

    import "DPI-C" function chandle DPI_Signal_Source_initialize(chandle existhandle);
    import "DPI-C" function void DPI_Signal_Source_output(input chandle objhandle,
/*Simulink signal name: 'PhaseOffset'*/
input real PhaseOffset,
/*Simulink signal name: 'FreqOffset'*/
input real FreqOffset,
/*Simulink signal name: 're'*/
inout real Data_re,
/*Simulink signal name: 'im'*/
inout real Data_im);
    import "DPI-C" function void DPI_Signal_Source_update(input chandle objhandle,
/*Simulink signal name: 'PhaseOffset'*/
input real PhaseOffset,
/*Simulink signal name: 'FreqOffset'*/
input real FreqOffset);
    

	always @(reset) begin
        objhandle = DPI_Signal_Source_initialize(objhandle);
        overclocking_counter <= 64'b1;
	end 

	always @(posedge clk) begin 
        if(clk_enable == 1'b1) begin
            if(overclocking_counter==1) begin
                for(int ii=0; ii < loop_factor; ii=ii+1) begin       
                    DPI_Signal_Source_output(objhandle,
PhaseOffset, FreqOffset, Data_re_temp, Data_im_temp);
                    DPI_Signal_Source_update(objhandle,
PhaseOffset, FreqOffset);   
                end
                Data_re <=Data_re_temp;
Data_im <=Data_im_temp;

            end
            if(overclocking_counter == overclocking_factor)
                overclocking_counter <= 64'b1;
            else
                overclocking_counter <= overclocking_counter + 1'b1;
        end
	end

endmodule


