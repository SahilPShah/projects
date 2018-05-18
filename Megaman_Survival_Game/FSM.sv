module FSM (
				input logic  up_arrow, left_arrow, down_arrow, right_arrow, z_jump_key, x_shoot_key, damage,
				input logic frame_clk,
				input logic Clk, RESET,
				output logic LED0, LED1, LED2, LED3, LED4,  
				output logic [4:0] sprite_select,
				output logic [9:0] Megaman_x_position, Megaman_y_position,
				output logic [7:0] Lifepoints,
				output logic last_horizontal, dead
			   );

	     // Detect rising edge of frame_clk
logic frame_clk_delayed, frame_clk_rising_edge;				
  always_ff @ (posedge Clk) begin
      frame_clk_delayed <= frame_clk;
      frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
  end

  logic [9:0] Megaman_x_motion_in, Megaman_x_motion, Megaman_x_position_in, Megaman_y_motion_in, Megaman_y_motion, Megaman_y_position_in;
  logic [4:0] sprite_select_in, sprite_select_stop, sprite_select_stop_in;
  logic [4:0] jump_count, jump_count_next;
  logic ladder_snap1, ladder_snap1_next;
  logic [3:0] i, j, i_next, j_next;
  logic [4:0] k, k_next;
  logic LED0_next, LED1_next, LED2_next, LED3_next, LED4_next;
  logic last_horizontal_next, dead_next;
  logic [7:0] Lifepoints_next, damage_wait, damage_wait_next;
  
  always_ff @ (posedge Clk) 
	begin
		if(RESET || dead)
			begin
				Megaman_x_position <= 10'd0;
				Megaman_x_motion <= 10'd0;
				Megaman_y_position <= 10'd337;
				Megaman_y_motion <= 10'd0;
				i <= 4'b0;
				j <= 4'b0;
				k <= 5'b0;
				jump_count <= 5'b0;
				ladder_snap1 <= 1'b0;
				LED0 <= 0;
				LED1 <= 0;
				LED2 <= 0;
				LED3 <= 0;
				LED4 <= 0;
				last_horizontal <= 1'b0;
				Lifepoints <= 8'd10;
				dead <= 1'b0;
				damage_wait <= 8'b0;
			end
		else
			begin
				Megaman_x_motion <= Megaman_x_motion_in;
				Megaman_x_position <= Megaman_x_position_in;
				Megaman_y_motion <= Megaman_y_motion_in;
				Megaman_y_position <= Megaman_y_position_in;
				sprite_select <= sprite_select_in;
				sprite_select_stop <= sprite_select_stop_in;
				i <= i_next;
				j <= j_next;
				jump_count <= jump_count_next;
				ladder_snap1 <= ladder_snap1_next;
				k <= k_next;
				LED0 <= LED0_next;
				LED1 <= LED1_next;
				LED2 <= LED2_next;
				LED3 <= LED3_next;
				LED4 <= LED4_next;
				last_horizontal <= last_horizontal_next;
				Lifepoints <= Lifepoints_next;
				dead <= dead_next;
				damage_wait <= damage_wait_next;
			end
	end
	
  always_comb
  begin
  
  	Megaman_x_position_in = Megaman_x_position;
	Megaman_x_motion_in = Megaman_x_motion;
	Megaman_y_position_in = Megaman_y_position;
	Megaman_y_motion_in = Megaman_y_motion;
	sprite_select_in = sprite_select;											
	sprite_select_stop_in = sprite_select_stop;					
	i_next = i;
	j_next = j;
	k_next = k;
	jump_count_next = jump_count;
	ladder_snap1_next = ladder_snap1;
	LED0_next = LED0;
	LED1_next = LED1;
	LED2_next = LED2;
	LED3_next = LED3;
	LED4_next = LED4;
	last_horizontal_next = last_horizontal;
	Lifepoints_next = Lifepoints;
	dead_next = dead;
	damage_wait_next = damage_wait;
	
	
      // Update position and motion only at rising edge of frame clock
     if (frame_clk_rising_edge)
     begin
		dead_next = 1'b0;
		
			if(left_arrow)
				last_horizontal_next = 1'b0;
			else if(right_arrow)
				last_horizontal_next = 1'b1;
		
			if((Megaman_x_position + 9'd30 < 10'd238) && (Megaman_x_position + 9'd30 > 10'd205) && (Megaman_y_position + 9'd60 <= 10'd400) && (Megaman_y_position + 9'd60 > 10'd190)	&& (up_arrow || down_arrow || ladder_snap1))
				begin															//Is Megaman going up or down a ladder?
				LED0_next = 0;
				LED1_next = 0;
				LED2_next = 0;
				LED3_next = 0;
				LED4_next = 1;
					Megaman_y_motion_in = 11'd0;
					Megaman_x_motion_in = 11'd0;
		
					if(up_arrow)	//y constraints moved to outer statement
						begin
							ladder_snap1_next = 1'b1;
							Megaman_y_motion_in = (~(11'b010) + 1'b1);
							if(k[4])	
								sprite_select_in = 5'd10;					//climbing up right hand
							else	
								sprite_select_in = 5'd9;					//climbing up left hand 
							k_next = k + 1'd1; 
						end
					else if(down_arrow && (Megaman_y_position + 9'd60 <= 10'd385)) //additional y constraint needed to ensure down arrow doesnt go below the ground
						begin
							ladder_snap1_next = 1'b1;
							Megaman_y_motion_in = 11'd2;
							if(k[4])	
								sprite_select_in = 5'd10;					//climbing up right hand
							else	
								sprite_select_in = 5'd9;					//climbing up left hand
							k_next = k + 1'd1;
						end
						
					if((last_horizontal == 1'b1) && x_shoot_key)
						begin
						sprite_select_in = 5'd20;							//climbing shooting facing right NEED TO CHANGE*************************************************
						end
						
					if((last_horizontal == 1'b0) && x_shoot_key)
						begin
						sprite_select_in = 5'd19;							//climbing shooting facing left NEED TO CHANGE*************************************************
						end
						
						
					if(((Megaman_y_position + 9'd60 > 10'd385) || (Megaman_y_position + 9'd60 < 10'd188)) && ladder_snap1)	//Megaman has hit the bottom of the ladder, or is on top of the ladder
						begin
						LED0_next = 0;
						LED1_next = 0;
						LED2_next = 0;
						LED3_next = 1;
						LED4_next = 0;
							ladder_snap1_next = 1'b0;	
						end
					
					if(z_jump_key && right_arrow)
						begin
							ladder_snap1_next = 1'b0;
							Megaman_x_motion_in = 11'd02;
							sprite_select_in = 5'd8;							//jumping facing right ANIMATION ADDED
							if(x_shoot_key)
								sprite_select_in = 5'd13;							//jumping shooting facing right 
						end
					if(z_jump_key && left_arrow)
						begin
							ladder_snap1_next = 1'b0;
							Megaman_x_motion_in = (~(11'b010) + 1'b1); 
							sprite_select_in = 5'd7;							//jumping facing left ANIMATION ADDED
							if(x_shoot_key)
								sprite_select_in = 5'd12;							//jumping shooting facing left 
						end
						
					if(!z_jump_key && !up_arrow && !down_arrow && !right_arrow && !left_arrow)
						sprite_select_in = 5'd10;					//climbing up right hand
				end
			
			
			else if(((Megaman_y_position + 9'd60 < 10'd394) && (Megaman_y_position > 10'd225) && (Megaman_x_position + 9'd60 < 10'd330) && (jump_count == 5'b0) && (ladder_snap1 == 1'b0)) || 	//"first stairs area"
					  ((Megaman_y_position + 9'd60 < 10'd191) && (Megaman_x_position + 9'd60 < 330) && (jump_count == 5'b0) && (ladder_snap1 == 1'b0)) ||		 												//"second level area"
					  ((Megaman_y_position + 9'd60 <= 10'd327) && (Megaman_y_position > 10'd200) && (Megaman_x_position + 9'd60 < 10'd405) && (jump_count == 5'b0) && (ladder_snap1 == 1'b0)) || 	//on top of left box
					  ((Megaman_y_position + 9'd60 < 10'd118) && (jump_count == 5'b0) && (ladder_snap1 == 1'b0)) ||																										   //on top of top box
					  ((Megaman_y_position + 9'd60 < 10'd191) && (Megaman_x_position > 10'd400) && (Megaman_x_position + 9'd60 < 10'd490) && (jump_count == 5'b0) && (ladder_snap1 == 1'b0)) ||	//second level past top box
					  ((Megaman_y_position + 9'd60 < 10'd394) && (Megaman_x_position > 10'd485) && (Megaman_x_position < 10'd530) && (jump_count == 5'b0) && (ladder_snap1 == 1'b0)) ||				//Rightmost gap under 2nd level
					  ((Megaman_y_position + 9'd60 < 10'd191) && (Megaman_x_position > 10'd525) && (jump_count == 5'b0) && (ladder_snap1 == 1'b0)) &&
					  ((Megaman_y_position + 9'd60 < 10'd400) && (Megaman_y_position >= 10'd225) && (Megaman_x_position + 10'd60 > 10'd480) && (jump_count == 5'b0) && (ladder_snap1 == 1'b0))) 																//Rightmost platform
					  
				begin
				LED0_next = 0;												//Is Megaman in the falling sequence?
				LED1_next = 0;
				LED2_next = 1;
				LED3_next = 0;
				LED4_next = 0;
				Megaman_y_motion_in = 10'd03;
					
				/*1*/	if(left_arrow && !right_arrow)			//Keypress of only left arrow
							begin
								sprite_select_stop_in = 5'd7;
								Megaman_x_motion_in = (~(11'b010) + 1'b1); 		//Moving left
								sprite_select_in = 5'd7; 
								if(x_shoot_key)
									sprite_select_in = 5'd12;							//jumping shooting facing left 
							end
									
				/*2*/	if(right_arrow && !left_arrow)								//Keypress of only right arrow
							begin
								sprite_select_stop_in = 5'd8;
								Megaman_x_motion_in = 11'd02;							//moving right
								sprite_select_in = 5'd8;
								if(x_shoot_key)
									sprite_select_in = 5'd13;							//jumping shooting facing right 
							end
							
				/*3*/	if((right_arrow && left_arrow) || (!right_arrow && !left_arrow))								//Keypress of right and left arrow or no keypress will have the same 
							begin																											//properties
								sprite_select_in = sprite_select_stop_in;			
								Megaman_x_motion_in = 10'b0;							//Don't move right
								if(x_shoot_key && (last_horizontal == 1))
									sprite_select_in = 5'd13;							//jumping shooting facing right
								else if(x_shoot_key && (last_horizontal == 0))
									sprite_select_in = 5'd12;							//jumping shooting facing left 
								else if(last_horizontal)
									sprite_select_in = 5'd8;
								else if(!last_horizontal)
									sprite_select_in = 5'd7;
							end
					
				
				end
				
			else if(z_jump_key  == 1'b1 || jump_count != 5'b0)																//Is megaman in the jumping sequnce?
				begin
				LED0_next = 0;
				LED1_next = 1;
				LED2_next = 0;
				LED3_next = 0;
				LED4_next = 0;
				/*1*/	if(left_arrow && !right_arrow)			//Keypress of only left arrow
							begin
								sprite_select_stop_in = 5'd7;
								Megaman_x_motion_in = (~(11'b010) + 1'b1); 		//Moving left
								sprite_select_in = 5'd7;
								if(x_shoot_key)
									sprite_select_in = 5'd12;							//jumping shooting facing left
							end
									
				/*2*/	else if(right_arrow && !left_arrow)								//Keypress of only right arrow
							begin
								sprite_select_stop_in = 5'd8;
								Megaman_x_motion_in = 11'd02;							//moving right
								sprite_select_in = 5'd8;
								if(x_shoot_key)
									sprite_select_in = 5'd13;							//jumping shooting facing right
							end
				/*3*/	else if((right_arrow && left_arrow) || (!right_arrow && !left_arrow))								//Keypress of right and left arrow or no keypress will have the same 
							begin																											//properties
								sprite_select_in = sprite_select_stop_in;			//face right
								Megaman_x_motion_in = 10'b0;							//Don't move right
								if(x_shoot_key && (last_horizontal == 1))
									sprite_select_in = 5'd13;							//jumping shooting facing right
								else if(x_shoot_key && (last_horizontal == 0))
									sprite_select_in = 5'd12;							//jumping shooting facing left
								else if(last_horizontal)
									sprite_select_in = 5'd8;
								else if(!last_horizontal)
									sprite_select_in = 5'd7;
							end
					
					
					if((Megaman_y_position + 9'd60 < 10'd387) && (Megaman_y_position > 10'd190) && (Megaman_x_position + 9'd60 < 10'd340) && (jump_count == 5'b0) ) //Is Megaman already in the air from 
						begin																																														//a previous jump?
							Megaman_y_motion_in = 11'b0;
						end
					else if(jump_count < 5'd14)											//If not, then commence the jumping sequence
						begin
							Megaman_y_motion_in = (~(11'b0100) + 1'b1);
							jump_count_next = jump_count + 2'b01;
						end
					else if(jump_count < 5'd22)
						begin
							Megaman_y_motion_in = (~(11'b010) + 1'b1);
							jump_count_next = jump_count + 2'b01;
						end
					else 
						begin
							Megaman_y_motion_in = (~(11'b01) + 1'b1);
							jump_count_next = jump_count + 2'b01;
						end
				end
			
			else if(z_jump_key == 1'b0)												//Megaman is just running
				begin
				LED0_next = 1;
				LED1_next = 0;
				LED2_next = 0;
				LED3_next = 0;
				LED4_next = 0;
					jump_count_next = 5'b0;
					ladder_snap1_next = 1'b0;
	
				/*1*/	if(left_arrow && !right_arrow)			//Keypress of only left arrow
							begin
								sprite_select_stop_in = 5'd1;
								Megaman_x_motion_in = (~(11'b011) + 1'b1); 		//Moving left
								Megaman_y_motion_in = 11'b0;
								if (i[3] == 0)
									begin
										sprite_select_in = 5'd4; 							//Running right
										if(x_shoot_key)
											sprite_select_in = 5'd11;
									end
								else 
									begin
										sprite_select_in = 5'd6; 							//Running right intermediate
										if(x_shoot_key)
											sprite_select_in = 5'd16;
									end
								i_next = i + 1;
								
							end
									
				/*2*/	if(right_arrow && !left_arrow)								//Keypress of only right arrow
							begin
								sprite_select_stop_in = 5'b0;
								Megaman_x_motion_in = 11'd03;							//moving right
								Megaman_y_motion_in = 11'b0;
								if (j[3] == 0)
									begin
										sprite_select_in = 5'd2; 							//Running right
										if(x_shoot_key)
											sprite_select_in = 5'd17;
									end
								else 
									begin
										sprite_select_in = 5'd3; 							//Running right intermediate
										if(x_shoot_key)
											sprite_select_in = 5'd18;
									end
								j_next = j + 1;
							
							end
							
				/*3*/	if((right_arrow && left_arrow) || (!right_arrow && !left_arrow))								//Keypress of right and left arrow or no keypress will have the same 
							begin																											//properties
								sprite_select_in = sprite_select_stop_in;			//face right
								Megaman_x_motion_in = 11'b0;							//Don't move right
								Megaman_y_motion_in = 11'b0;
								
								if(x_shoot_key && (last_horizontal == 1))
									sprite_select_in = 5'd14;							//shooting facing right 
								else if(x_shoot_key && (last_horizontal == 0))
									sprite_select_in = 5'd15;							//shooting facing left 
							end
				end
			
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////BOUNDARY CONDITIONS///////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if( (Megaman_x_position + 9'd60 >= 10'd639) && right_arrow )  			// Megaman is at the Right edge, STOP
		begin
        Megaman_x_motion_in = 10'd0;
		  sprite_select_in = sprite_select_stop;
		end
	if( (Megaman_x_position <= 10'd5) && left_arrow) 			// Megaman is at the Left edge, STOP 
		begin																							
        Megaman_x_motion_in = 10'd0;
		  sprite_select_in = sprite_select_stop;
		end	
	if(Megaman_y_position <= 10'd4) 			// Megaman is at the top edge, STOP 
		begin																							
		  jump_count_next = 5'd0;
		  sprite_select_in = sprite_select_stop;
		end
	if((Megaman_y_position + 9'd60 > 10'd332) && (Megaman_y_position >= 10'd225) && (Megaman_x_position + 9'd60 >= 10'd320) && (Megaman_x_position  <= 10'd405) && right_arrow)	//Megaman has hit the bottom block left edge, STOP
		begin
        Megaman_x_motion_in = 10'd0;
		  sprite_select_in = sprite_select_stop;
		end
	if((Megaman_y_position >= 10'd225) && (Megaman_y_position + 9'd60 <= 10'd327) && (Megaman_x_position + 9'd60 >= 10'd405) && (Megaman_x_position <= 10'd475) && right_arrow)	//Megaman has hit the larger block on the bottom, STOP
		begin
			Megaman_x_motion_in = 10'd0;
			sprite_select_in = sprite_select_stop;	
		end
	if((Megaman_y_position + 9'd60 > 10'd124) && (Megaman_y_position + 9'd60 < 10'd200) && (Megaman_x_position + 9'd60 >= 10'd320) && (Megaman_x_position + 9'd60 <= 10'd405) && right_arrow)	//Megaman has hit the top block left edge, STOP
		begin
        Megaman_x_motion_in = 10'd0;
		  sprite_select_in = sprite_select_stop;
		end
		
	if((Megaman_y_position < 10'd230) && (Megaman_y_position > 10'd220) && (Megaman_x_position + 9'd60 < 10'd461))		//Megaman has hit the second level, BOUNCE
		begin
			jump_count_next = 5'b0;
		end
	if((Megaman_y_position + 9'd60 > 10'd220) && (Megaman_y_position + 9'd60 < 10'd400) && (Megaman_x_position >= 10'd405) && (Megaman_x_position <= 10'd475) && left_arrow)	//Megaman has hit the lower big block right edge
		begin
        Megaman_x_motion_in = 10'd0;
		  sprite_select_in = sprite_select_stop;
		end
	if((Megaman_y_position + 9'd60 > 10'd124) && (Megaman_y_position + 9'd60 < 10'd220) && (Megaman_x_position > 10'd330) && (Megaman_x_position < 10'd405) && left_arrow)	//Megaman has hit the upper block right edge
		begin
        Megaman_x_motion_in = 10'd0;
		  sprite_select_in = sprite_select_stop;
		end
	
	
	Megaman_x_position_in = Megaman_x_position + Megaman_x_motion;  
	Megaman_y_position_in = Megaman_y_position + Megaman_y_motion;
	
	
	if(ladder_snap1)
		Megaman_x_position_in = 10'd191; 
		
	if(damage || damage_wait != 8'b0)
		begin
			damage_wait_next = damage_wait + 2'd2;
		end
		
	if(damage_wait == 8'd2)				
		Lifepoints_next = Lifepoints - 1'b1;
		
	if(Lifepoints == 0)
		dead_next = 1'b1;
	end
		
		
end

  
endmodule
