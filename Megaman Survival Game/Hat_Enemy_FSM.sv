module Hat_Enemy_FSM(input logic Clk,                // 50 MHz clock
											RESET, dead,
							input logic frame_clk ,
							input logic [9:0] Megaman_x_position, Megaman_y_position,
							input logic is_collision,
							output logic [9:0] hat_enemy_position_x, hat_enemy_position_y,
							output logic [7:0] score,
							output logic hat_on, LEDG7, LEDR17
//							output logic collision		//need to make collision a register
					      );
logic frame_clk_delayed, frame_clk_rising_edge;
logic collision_next, collision;
logic [9:0] hat_enemy_position_x_next, hat_enemy_position_y_next, hat_enemy_motion_x, hat_enemy_motion_y, hat_enemy_motion_x_next, hat_enemy_motion_y_next;
logic [7:0] dive_counter, dive_counter_next, wait_counter, wait_counter_next, score_next;
logic LEDR17_next;

parameter hat_enemy_size = 9'd30;
							
  always_ff @ (posedge Clk) 
	begin
      frame_clk_delayed <= frame_clk;
      frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
    
   always_ff @ (posedge Clk) 
	begin
		if(RESET || dead)
			begin
				LEDG7  <= 1'b0;
				hat_enemy_position_x <= 10'd300;
				hat_enemy_position_y <= 10'd240;
				collision <= 1'd0;
				score <= 8'b0;
			end
		else
			begin
				hat_enemy_position_x <= hat_enemy_position_x_next;
				hat_enemy_position_y <= hat_enemy_position_y_next;
				hat_enemy_motion_x <= hat_enemy_motion_x_next;
				hat_enemy_motion_y <= hat_enemy_motion_y_next;
				LEDG7 <= LEDG7_next;
				hat_on <= hat_on_next;
				collision <= collision_next;
				dive_counter <= dive_counter_next;
				LEDR17 <= LEDR17_next;
				wait_counter <= wait_counter_next;
				score <= score_next;
			end
	end	
	
logic LEDG7_next, hat_on_next; 
	
	always_comb
		begin
			hat_enemy_position_x_next = hat_enemy_position_x;
			hat_enemy_position_y_next = hat_enemy_position_y;
			hat_enemy_motion_x_next = hat_enemy_motion_x;
			hat_enemy_motion_y_next = hat_enemy_motion_y;
			LEDG7_next = LEDG7 ;
			hat_on_next = hat_on;
			collision_next = collision;
			dive_counter_next = dive_counter;
			LEDR17_next = dive_counter[7];
			wait_counter_next = wait_counter;
			score_next = score;
			
			if (frame_clk_rising_edge)
				begin
					hat_on_next = 1'b1;
					LEDG7_next = 1'b0;
					collision_next = 1'b0;
					hat_enemy_motion_y_next = 10'b0;
					
					if(hat_enemy_position_y > Megaman_y_position - 10'd100) //is the enemy below 100 pixels above megaman's position
						begin																  //move up
							hat_enemy_motion_y_next = ~(9'd5) + 1'b1;
						end

					if(Megaman_x_position - 10'd60 > hat_enemy_position_x)				 
						begin
							hat_enemy_motion_x_next = 10'd2;
						end
					
					else if(Megaman_x_position + 10'd120 < hat_enemy_position_x)
						begin
							hat_enemy_motion_x_next = ~(10'b010) + 1'b1;
						end
					
					if(dive_counter[7] == 1'b1) 
						begin
							if(Megaman_x_position + 10'd30 > hat_enemy_position_x + hat_enemy_size)
								hat_enemy_motion_x_next = 10'd6;
							else 
								hat_enemy_motion_x_next = ~(10'd6) + 1'b1;

							hat_enemy_motion_y_next = 10'd15;
						end
					dive_counter_next = dive_counter + 8'd1;

					if(hat_enemy_position_y > Megaman_y_position + 10'd30)
						begin
							dive_counter_next = 8'd0;
							hat_enemy_motion_y_next =  ~(9'd5) + 1'b1;
							
							if(Megaman_x_position + 10'd30 > hat_enemy_position_x + hat_enemy_size)
								hat_enemy_motion_x_next = 10'd2;
							else 
								hat_enemy_motion_x_next = ~(10'd2) + 1'b1;
						end
						
					if(hat_enemy_position_x < 10'd5) 
						hat_enemy_motion_x_next = 10'd2;
					if(hat_enemy_position_x + hat_enemy_size > 10'd635)
						hat_enemy_motion_x_next = ~(10'd2) + 1'b1;
					
					if(is_collision || collision)
						begin
							hat_on_next = 1'b0;
							collision_next = 1'b1;
							LEDG7_next = 1'b1;
							wait_counter_next = wait_counter + 1'b1;
						end
						
					if(wait_counter == 8'd1)
						score_next = score + 1'b1;
						
						
					if(wait_counter == 8'd120)
						begin
							collision_next = 1'b0;
							wait_counter_next = 8'd0;
						end

				hat_enemy_position_x_next = hat_enemy_position_x + hat_enemy_motion_x;
				hat_enemy_position_y_next = hat_enemy_position_y + hat_enemy_motion_y;		
				end
			
			
			
		end
	
	
endmodule
