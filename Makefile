test:
	vsim -do run.do

clean:
	rm -Rf Signal_Source_build
	rm -Rf Channel_build
	rm -Rf QAM_PLL_build
	rm -Rf slprj
	rm -Rf work
	rm -f transcript
	rm -f *.wlf
	
