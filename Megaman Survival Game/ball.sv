//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
					input logic [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [9:0]   Megaman_x_position, Megaman_y_position, bullet_x_position, bullet_y_position, hat_enemy_position_x, hat_enemy_position_y,
					//input logic collision_status,		//need to make collision a register
					input logic bullet_on, hat_on,
					output logic [10:0] addr_x, addr_y,
					output logic print_background, print_bullet, print_hat_enemy,	
					output logic is_collision, damage, LEDG6
					);
					
logic [11:0] shape_size_x = 9'd60;
logic [11:0] shape_size_y  = 9'd60;
logic [11:0] bullet_size_x = 9'd10;	
logic [11:0] bullet_size_y = 9'd10;
logic [11:0] hat_enemy_size_x = 9'd30;	
logic [11:0] hat_enemy_size_y = 9'd30;
logic print_megaman;


    always_comb 
		begin
		addr_x = DrawX;
		addr_y = DrawY;
		print_background = 1'b0;
		print_bullet = 1'b0;
		print_megaman = 1'b0;
		print_hat_enemy = 1'b0;
		is_collision = 1'b0;
		damage = 1'b0;
		LEDG6 = 1'b0;
		
			 if((bullet_x_position + bullet_size_x >= hat_enemy_position_x) && (bullet_x_position <= hat_enemy_position_x + hat_enemy_size_x) 
				 && (bullet_y_position + shape_size_y >= hat_enemy_position_y) && (bullet_y_position <= hat_enemy_position_y + hat_enemy_size_y) && hat_on && bullet_on)
						begin
							LEDG6 = 1'b1;
							is_collision = 1'b1;
						end
						
			if((Megaman_x_position + shape_size_x >= hat_enemy_position_x) && (Megaman_x_position <= hat_enemy_position_x + hat_enemy_size_x) 
				 && (Megaman_y_position + bullet_size_y >= hat_enemy_position_y) && (Megaman_y_position <= hat_enemy_position_y + hat_enemy_size_y) && hat_on)
						begin
							damage = 1'b1;
						end
		
		
			 if ((DrawX >= Megaman_x_position) && (DrawX < Megaman_x_position + shape_size_x) &&		//draw Megaman
				 (DrawY >= Megaman_y_position) && (DrawY < Megaman_y_position + shape_size_y))
				begin
					addr_x = (DrawX - Megaman_x_position);
					addr_y = (DrawY - Megaman_y_position);
					print_megaman = 1'b1;
				end
				
			 if(((DrawX >= bullet_x_position) && (DrawX < bullet_x_position + bullet_size_x) &&		//draw the bullet
				 (DrawY >= bullet_y_position) && (DrawY < bullet_y_position + bullet_size_y)) && bullet_on)
					begin
						addr_x = (DrawX - bullet_x_position);
						addr_y = (DrawY - bullet_y_position);
						print_bullet = 1'b1;
					end
					
			if(((DrawX >= hat_enemy_position_x) && (DrawX < hat_enemy_position_x + hat_enemy_size_x) &&		//draw the hat enemy
				 (DrawY >= hat_enemy_position_y) && (DrawY < hat_enemy_position_y + hat_enemy_size_y)) && (hat_on))	//will draw say to draw a hat if draw Hat is 1 or if there is a collision
				begin
					addr_x = (DrawX - hat_enemy_position_x);
					addr_y = (DrawY - hat_enemy_position_y);
					print_hat_enemy = 1'b1;
				end
			
			if(!print_megaman && !print_bullet && !print_hat_enemy)
				print_background = 1'b1;
				
			
			
		end   
endmodule
