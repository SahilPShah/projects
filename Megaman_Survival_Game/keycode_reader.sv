// this guide to create this module was provided by Kttech 

module keycode_reader(input logic [31:0] keycode, 
							 output logic up_on, left_on, down_on, right_on, z_jump_on, x_shoot_on);
							 
							 
			//look up
			assign up_on = (keycode[31:24] == 8'h52 |
								 keycode[23:16] == 8'h52 |
								 keycode[15: 8] == 8'h52 |
								 keycode[ 7: 0] == 8'h52); 
			
			//look/move left
			assign left_on = (keycode[31:24] == 8'h50 |
									keycode[23:16] == 8'h50 |
									keycode[15: 8] == 8'h50 |
									keycode[ 7: 0] == 8'h50);
				
			//roll button
			assign down_on = (keycode[31:24] == 8'h51 |
									keycode[23:16] == 8'h51 |
									keycode[15: 8] == 8'h51 |
									keycode[ 7: 0] == 8'h51);
			
			//look/move right
			assign right_on = (keycode[31:24] == 8'h4f |
									 keycode[23:16] == 8'h4f |
									 keycode[15: 8] == 8'h4f |
									 keycode[ 7: 0] == 8'h4f);
				
			// jump up (should have a max limit set at some point)
			assign z_jump_on = (keycode[31:24] == 8'h1d |
									  keycode[23:16] == 8'h1d |
									  keycode[15: 8] == 8'h1d |
									  keycode[ 7: 0] == 8'h1d);
									  
			//shoot
			assign x_shoot_on = (keycode[31:24] == 8'h1b |
										keycode[23:16] == 8'h1b |
										keycode[15: 8] == 8'h1b |
										keycode[ 7: 0] == 8'h1b); 
			
			
endmodule
