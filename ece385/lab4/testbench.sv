module testbench();
timeunit 10ns; //half clock cycle at 50Hz
timeprecision 1ns; //This is the amount of time represented by #1

logic Clk = 0;
logic Reset, LoadA, LoadB, Execute;
logic [7:0] Din;
logic [2:0] F;
logic [1:0] R;
logic [3:0] LED;
logic [7:0] Aval,Bval;
logic [6:0] AhexL,AhexU,BhexL,BhexU;

logic [7:0] ans_la, ans_2b;

integer ErrorCnt = 0;

processor processor0(.*);//make sure the module and signal names match wit those in the design

always begin : CLOCK_GENERATION
	#1 Clk = ~Clk;
end

//testing begins here
//the initial block is not synthesizable
//everything happens sequentially inside an initial block
//as in a software program

Reset=0;
LoadA=1;
LoadB=1;
Execute=1;
Din=8'h33;
F=3'b010;
R=2'b10;

#2 Reset=1;
#2 LoadA=0;
#2 LoadA=1;//toggle loadA
#2 LoadB=0;
#2 Din=8'h55;//change Din
#2 LoadB=1;//toggle loadB

Din=8'h00; //change Din again

#2 Execute=0//toggle execute;

#22 Execute=1;
	 ans_la = (8'h33 ^ 8'h55); //expected result of the first cycle
	 //aval is expected to 8'h33 XOR 8'h55
	 //bval is expected to be the original 8'55
	 if(Aval!=ans_la)
		ErrorCnt++;
	 if(Bval!=8'h55)
		ErrorCnt++;
	 //change routing and function select
	 F=3'b110;
	 R=2'b01;
	 
#2 Execute=0;
#2 Execute=1;

#22 Execute=0;
	 //aval should stay the same
	 //bval is expected to be the answer of the first cycle XNOR 8'h55
	 ans_2b = ~(ans_la ^ 8'h55);
	 if(Aval!= ans_la)
		ErrorCnt++;
	 if(Bval!=ans2b)
		ErrorCnt++;
	 
	 R=2'b11;

#2 Execute=1;
//aval and bval are expected to swap

#22 if(Aval!= ans_2b)
		ErrorCnt++;
	 if(Bval!=ans_la)
		ErrorCnt++;
		
if(ErrorCnt == 0)
	$display("Success!");
else
	$display("Errors detected. Try Again");
	
end

endmodule 