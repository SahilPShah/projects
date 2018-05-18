module computation_unit(input A_,B_, input [2:0] F,output A,B,func)
//A and B come from the register unit
//F[2:0] is the function select and come from the switches
//the computation_unit module outputs the original inputs A and B and the result, func
logic temp
always_comb
begin
	case(F[1:0])
		2'b00 : temp = A_ & B_;
		2'b01 : temp = A_ | B_;
		2'b10 : temp = A_ ^ B_;;
		default : temp = 1;//case where F[1:0] is 11;
	endcase
	
	func = temp ^ F[2]; // selectively invert the signal
	A=A_;
	B=B_;
end
endmodule	
	
		
	
		