//module bullet_fsm(input Clk, RESET, x_shoot_key
//						input logic [9:0] Megaman_x_position, Megaman_y_position, bullet1X, bullet2X bullet3X, bullet1Y, bullet2Y, bullet3Y
//						input frame_clk
//						input direction
//						input bullet1_off, bullet2_off, bullet3_off
//						output is_bullet1, is_bullet2, is_bullet3);
//						
//
//logic frame_clk_delayed, frame_clk_rising_edge;
//enum logic [2:0] {NoBullets,Bullet1, Bullet2, Bullet3,} 
//						State;
//						Next_state;
//logic [9:0] bullet1X_in, bullet2X_in, bullet3X_in;
//logic bullet1dir = 1'd0;		//default to zero, doesnt matter. Will be reset whenever the shoot key is pressed
//logic bullet2dir = 1'd0;
//logic bullet3dir = 1'd0; 
//logic bullet1dir_in, bullet2dir_in, bullet3dir_in;
//logic is_bullet1_in, is_bullet2_in, is_bullet3_in;
//						
//always_ff @ (posedge Clk)
//	begin
//		frame_clk_delayed <= frame_clk;
//      frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
//	end
//always_ff @ (posedge frame_clk_rising_edge)		//update next state
//	begin
//		if(RESET)
//			State <= NoBullets
//		else
//			Next_state <= state;
//	end
//	
//always_comb						//next-state logic 
//	begin
//		unique case(State)
//			NoBullets:
//				if(x_shoot_key)
//					Next_state = Bullet1;
//				else
//					Next_state = NoBullets;
//			Bullet1:
//				if(bullet1_off)
//					Next_state = NoBullets;
//				if(x_shoot_key)
//					Next_state = Bullet2;
//				else
//					Next_state = Bullet1;
//			Bullet2: 
//				if(bullet2_off)
//					Next_state = Bullet1;
//				if(x_shoot_key)
//					Next_state = Bullet3;
//				else
//					Next_state = Bullet2;
//			Bullet3:
//				if(bullet3_off)
//					Next_state = Bullet2;
//				else
//					Next_state = Bullet3;
//		endcase
//	end
//	
//always_ff @ (posedge frame_clk_rising_edge)
//	begin
//		if(RESET)
//			begin
//				bullet1X <= Megaman_x_position;	//RESET TO MEGAMANS POSITION
//				bullet2X <= Megaman_x_position;	//RESET TO MEGAMANS POSITION
//				bullet3X <= Megaman_x_position;	//RESET TO MEGAMANS POSITION
//			end
//		bullet1X <= bullet1X_in
//		bullet2X <= bullet2X_in;
//		bullet3X <= bullet3X_in;
//		bullet1dir <= bullet1dir_in;
//		bullet2dir <= bullet2dir_in;
//		bullet3dir <= bullet3dir_in;
//		is_bullet1 <= is_bullet1_in;
//		is_bullet2 <= is_bullet2_in;
//		is_bullet3 <= is_bullet3_in;
//	end
//	
//always_comb
//	begin
//			bullet1X_in = bullet1X;
//			bullet2X_in = bullet2X;
//			bullet3X_in = bullet3X; 
//			is_bullet1_in = is_bullet1;
//			is_bullet2_in = is_bullet2;
//			is_bullet3_in = is_bullet3;
//			unique case(State)
//			NoBullets:
//				if(x_shoot_key)
//					begin
//						bullet1X_in = Megaman_x_position;
//						bullet1dir_in = direction;
//						is_bullet1_in = 1'd1;
//					end
//				else
//					//NOT SURE WHAT TO DO HERE
//			Bullet1:
//				if(bullet1_off)
//					is_bullet1_in = 1'd0;
//				else if(x_shoot_key && !is_bullet1)
//					begin
//						bullet2X_in = Megaman_x_position;
//						bullet2dir_in = direction;
//						is_bullet2_in = 1'd1;
//					end
//				else if(is_bullet1)
//					//BULLET IS MOVING
//					begin
//						if(bullet1dir)
//							//MOVING RIGHT
//						else
//							//MOVING LEFT
//					end
//				else
//					//NOT SURE WHAT TO DO HERE
//			Bullet2: 
//				if(bullet1_off)
//					is_bullet1_in = 1'd0;
//				else if(x_shoot_key && !is_bullet)
//					begin
//						bullet3X_in = Megaman_x_position;
//						bullet2dir_in = direction;
//						is_bullet2_in = 1'd1;
//					end
//				else if(is_bullet2)
//							//BULLET IS MOVING
//					begin
//						if(bullet1dir)
//							//MOVING RIGHT
//						else
//							//MOVING LEFT
//					end
//				else
//					//NOT SURE WHAT TO DO HERE
//			Bullet3:
//				if(bullet1_off)
//					is_bullet1_in = 1'd0;
//				else if(is_bullet3)
//						//BULLET IS MOVING
//					begin
//						if(bullet1dir)
//							//MOVING RIGHT
//						else
//							//MOVING LEFT
//					end
//				else
//					//NOT SURE WHAT TO DO HERE
//		endcase
//	end
//endmodule 