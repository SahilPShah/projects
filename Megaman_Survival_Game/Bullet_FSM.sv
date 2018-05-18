module bullet_FSM(input logic x_shoot_key, last_horizontal,
						input logic [9:0] Megaman_x_position, Megaman_y_position,
						input logic frame_clk,
						input logic Clk, RESET, collision,
						output logic [9:0] x_position, y_position,
						output logic bullet,
						output logic LEDR0 
						);
			
					
logic frame_clk_delayed, frame_clk_rising_edge;	
logic [9:0] bullet_y, bullet_x;
logic [9:0] x_position_next, y_position_next;
logic bullet_next;
logic LEDR0_next;
logic input_direction, input_direction_next; 

parameter bullet_width = 10'd10;
			
  always_ff @ (posedge Clk) 
	begin
      frame_clk_delayed <= frame_clk;
      frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
    
   always_ff @ (posedge Clk) 
	begin
		if(RESET)
			begin
				bullet <= 1'b0;
				LEDR0  <= 1'b0;
			end
		else
			begin
				x_position <= x_position_next;
				y_position <= y_position_next;
				bullet <= bullet_next;
				LEDR0 <= LEDR0_next;
				input_direction <= input_direction_next;
			end
	end	
	always_comb
		begin
			x_position_next = x_position;
			y_position_next = y_position;
			bullet_next = bullet;
			LEDR0_next = LEDR0;
			input_direction_next = input_direction;
			
			if (frame_clk_rising_edge)
				begin
					
					if(x_shoot_key)
							begin
							if(!bullet)
								begin
									input_direction_next = last_horizontal;
								end
							
								case(input_direction)
									1'b1 : 
										begin
											x_position_next = Megaman_x_position + 10'd60;	 
											y_position_next = Megaman_y_position + 10'd22;
										end
									1'b0 : 
										begin
											x_position_next = Megaman_x_position;	 
											y_position_next = Megaman_y_position + 10'd22;
										end
								endcase
								bullet_next = 1'b1;
							end
								
					if(bullet)
						begin
							case(input_direction)
									1'b1 :
										x_position_next = x_position + 10'd9;	 
									1'b0 : 
										x_position_next = x_position - 10'd9;	 
								endcase
								
							y_position_next = y_position;
							LEDR0_next = 1'b1;
						end
						
					if(x_position + bullet_width >= 10'd639 || x_position <= 10'd2 || collision)
						begin
							bullet_next = 1'b0;
							LEDR0_next = 1'b0;
						end
				end		
		end

endmodule
