/*
 * Etchosketch Top Level module
 * ------------------------
 * By: Luke Stock
 * For: University of Leeds
 * Date: 22nd May 2022
 *
 *
 * Short Description
 * -----------------
 * This module is designed to interface with the LT24 Display Module
 * from Terasic. Inputs are recieved from updatePixel module to set the xy coordiate location of pixel to the written.
 * Whilst the colour of the pixel is determined by the switches from user input. 
 * It makes use of the LT24Display IP core created by Thomas Carpenter.
 * 
 *
 */

module Etchosketch (
    // Global Clock/Reset
    
    input              clock,       // - Clock
    input              globalReset, // - Global Reset
	 input 				  [3:0] SW,   // Switch input
   
    output             resetApp,     // - Application Reset - for debug
    // LT24 Interface
    output             LT24Wr_n,
    output             LT24Rd_n,
    output             LT24CS_n,
    output             LT24RS,
    output             LT24Reset_n,
    output [     15:0] LT24Data,
    output             LT24LCDOn
);

//
// Local Variables
//
reg  [ 7:0] xAddr;
reg  [ 8:0] yAddr;
reg  [15:0] pixelData;
wire        pixelReady;
reg         pixelWrite;

wire [ 7:0] xorigin;
wire [ 8:0] yorigin;
wire [ 3:0] keys;

//
// LCD Display
//
localparam LCD_WIDTH  = 240;
localparam LCD_HEIGHT = 320;

LT24Display #(
    .WIDTH       (LCD_WIDTH  ),
    .HEIGHT      (LCD_HEIGHT ),
    .CLOCK_FREQ  (50000000   )
) Display (
    //Clock and Reset In
    .clock       (clock      ),
    .globalReset (globalReset),
    //Reset for User Logic
    .resetApp    (resetApp   ),
    //Pixel Interface
    .xAddr       (xAddr      ),
    .yAddr       (yAddr      ),
    .pixelData   (pixelData  ),
    .pixelWrite  (pixelWrite ),
    .pixelReady  (pixelReady ),
    //Use pixel addressing mode
    .pixelRawMode(1'b0       ),
    //Unused Command Interface
    .cmdData     (8'b0       ),
    .cmdWrite    (1'b0       ),
    .cmdDone     (1'b0       ),
    .cmdReady    (           ),
    //Display Connections
    .LT24Wr_n    (LT24Wr_n   ),
    .LT24Rd_n    (LT24Rd_n   ),
    .LT24CS_n    (LT24CS_n   ),
    .LT24RS      (LT24RS     ),
    .LT24Reset_n (LT24Reset_n),
    .LT24Data    (LT24Data   ),
    .LT24LCDOn   (LT24LCDOn  )
);

KeyPressed (
	.clock               ( clock               ),                 
	.key                 ( key                 ),             
	.key_pressed_posedge ( key_pressed_posedge )

);

updatePixel (
	// Declare parameters
	.clock		( clock    ),
	.reset 		( reset    ), 
	.keys			( keys     ),
	.xorigin    ( xorigin  ),
	.yorigin    ( yorigin  )

);
reg [3:0] state;

localparam WAIT_STATE               = 4'b0001;
localparam PREPAREPIXEL_STATE       = 4'b0010;
localparam DRAWPIXEL_STATE          = 4'b0100;
localparam COLOUR_STATE             = 4'b1000;

// State Machine Transitions and Output Generations
always @(posedge clock or posedge resetApp) begin
	if (resetApp) begin
		pixelWrite          <= 1'd0;          // do not write to the addressed pixel
		pixelData           <= 4'h0001;       // Reset colour
      xAddr               <= 8'b00001010;   // reset to x = 0
      yAddr               <= 9'b000001010;  // reset to y = 0
		
		state            <= WAIT_STATE;
		
		end else begin 
			case (state)
			
				// stay in wait state until last pixel has been drawn
				WAIT_STATE : begin 
				
					if ( pixelReady  ) begin// last pixel has been drawn and ready to draw next pixel
						
						state       <= PREPAREPIXEL_STATE;
						
					end
				end
					
				// adjust xy location from updatePixel output values
				PREPAREPIXEL_STATE : begin 
											
					yAddr          <= yorigin;
					xAddr          <= xorigin;
					state          <= COLOUR_STATE;
					
				end
				
				COLOUR_STATE : begin
				
						// Set the colour for pixel from user input 
						
						if (SW[1]  &&  (!SW[2])  &&  (!SW[3])) begin 
						
							pixelData         <= 16'b1111100000000000;   // RED
							state             <= DRAWPIXEL_STATE;
						
						end else if (SW[2]  &&  !SW[1]  &&  !SW[3]) begin 
						
							pixelData         <= 16'b0000011111100000;   // GREEN
							state             <= DRAWPIXEL_STATE;
							
						end else if   (SW[3]  &&  !SW[1]   &&  !SW[3]) begin 
						
							pixelData         <= 16'b0000000000011111;   // BLUE
							state             <= DRAWPIXEL_STATE;
							
						end 
											
					end 

				// Send command to write pixel to screen based on xAddr and yAddr
				DRAWPIXEL_STATE : begin 
				
				if (SW[0]) begin

					pixelWrite  <= 1'd1;
					
					state       <= WAIT_STATE;
					
				end else begin 
				
					state       <= WAIT_STATE;
				
				end
			end
		endcase
	end
end

endmodule
