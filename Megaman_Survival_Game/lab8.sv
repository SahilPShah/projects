//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX6, HEX7,
				 output logic [7:0]  LEDG, 
				 output logic [17:0]  LEDR,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [31:0] keycode;
	 logic [9:0] DrawX, DrawY, bullet_x_position, bullet_y_position;
	 logic [10:0] sprite_addr_x, sprite_addr_y;
	 logic [3:0] sprite_data;
	 logic [4:0] sprite_select;
	 logic [9:0] Megaman_x_position, Megaman_y_position, hat_enemy_position_x, hat_enemy_position_y;
	 logic print_background;
	 logic up_arrow, down_arrow, left_arrow, right_arrow, z_jump_key, x_shoot_key;
	 logic direction_h;
	 logic bullet_on, print_bullet, print_hat_enemy, hat_on;
	 logic last_horizontal;
	 logic is_collision, damage /*collision*/;
	 logic [7:0] score, Lifepoints;
	 logic dead;
	     
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(1'b0),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
	 
	 font_rom ROM_instance1(.Clk(Clk), .addr_x(sprite_addr_x), .addr_y(sprite_addr_y), .sprite_select(sprite_select), .DrawX(DrawX), .DrawY(DrawY), .print_background(print_background), .print_bullet(print_bullet), .print_hat_enemy(print_hat_enemy),
									.data(sprite_data));
									
	 bullet_FSM bullet_FSM0(.Clk(Clk), .RESET(Reset_h), .x_shoot_key(x_shoot_key), .Megaman_x_position(Megaman_x_position), .Megaman_y_position(Megaman_y_position), .frame_clk(VGA_VS), .last_horizontal(last_horizontal), .collision(is_collision),
								   .x_position(bullet_x_position), .y_position(bullet_y_position), .bullet(bullet_on), .LEDR0(LEDR[0]));
	 
    FSM FSM0(.Clk(Clk), .frame_clk(VGA_VS), .RESET(Reset_h), .up_arrow(up_arrow), .left_arrow(left_arrow), .down_arrow(down_arrow), .right_arrow(right_arrow), .z_jump_key(z_jump_key), .x_shoot_key(x_shoot_key), .damage(damage),
			 .sprite_select(sprite_select), .Megaman_x_position(Megaman_x_position), .Megaman_y_position(Megaman_y_position), .LED0(LEDG[0]), .LED1(LEDG[1]), .LED2(LEDG[2]), .LED3(LEDG[3]), .LED4(LEDG[4]), .last_horizontal(last_horizontal), .Lifepoints(Lifepoints), .dead(dead));
			 
	
	 Hat_Enemy_FSM Hat0( .Clk(Clk), .RESET(Reset_h), .frame_clk(VGA_VS), .Megaman_x_position(Megaman_x_position), .Megaman_y_position(Megaman_y_position), .is_collision(is_collision), .dead(dead),
							.hat_enemy_position_x(hat_enemy_position_x), .hat_enemy_position_y(hat_enemy_position_y), .hat_on(hat_on), .LEDG7(LEDG[7]), .LEDR17(LEDR[17]), .score(score));



	 keycode_reader keycode_reader0(.keycode(keycode), 
											  .up_on(up_arrow), .left_on(left_arrow), .down_on(down_arrow), .right_on(right_arrow), .z_jump_on(z_jump_key), .x_shoot_on(x_shoot_key));
			 
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
  
    VGA_controller vga_controller_instance(.Clk(CLOCK_50), .Reset(Reset_h), .VGA_CLK(VGA_CLK), 
														 .DrawX(DrawX), .DrawY(DrawY), .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS)); 
    
  
    ball ball_instance(.Clk(CLOCK_50), .Reset(Reset_h), .DrawX(DrawX), .DrawY(DrawY), .Megaman_x_position(Megaman_x_position), .Megaman_y_position(Megaman_y_position), .hat_enemy_position_x(hat_enemy_position_x), .hat_enemy_position_y(hat_enemy_position_y),
							  .bullet_x_position(bullet_x_position), .bullet_y_position(bullet_y_position), .bullet_on(bullet_on), .hat_on(hat_on),
							  //outputs:
							  .addr_x(sprite_addr_x), .addr_y(sprite_addr_y), .print_background(print_background), /*.collision_status(collision),*/ .print_bullet(print_bullet), .is_collision(is_collision), .damage(damage), .print_hat_enemy(print_hat_enemy), .LEDG6(LEDG[6]));
    
    color_mapper color_instance(.DrawX(DrawX), .DrawY(DrawY), .sprite_data(sprite_data), 
										  .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));				
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (score[3:0], HEX0);
    HexDriver hex_inst_1 (score[7:4], HEX1);
	 
//	 HexDriver hex_inst_2 (keycode[11:8], HEX2);
//    HexDriver hex_inst_3 (keycode[15:12], HEX3);
//	 
//	 HexDriver hex_inst_4 (keycode[19:16], HEX4);
//    HexDriver hex_inst_5 (keycode[23:20], HEX5);
//	 
	 HexDriver hex_inst_6 (Lifepoints[3:0], HEX6);
    HexDriver hex_inst_7 (Lifepoints[7:4], HEX7);
endmodule
