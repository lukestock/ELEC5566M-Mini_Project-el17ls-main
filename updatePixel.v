/*
 * Update pixel module
 * ------------------------
 * ELEC5566M: Mini-project
 * By: Luke Stock 
 * SID: 201148579
 * Date: 22nd May 2022
 * 
 * Short Description
 * -----------------
 * This module is designed to determine the x and y origin of a pixel to be drawn on the LT24 Terasic display
 * from key buttons pressed by user input. 
 *
 */	

 
 module updatePixel (
	// Declare parameters
	input				clock,
	input 			reset, 
	input				[3:0] keys,
	
	output reg   		[7:0] xorigin,
	output reg   		[8:0] yorigin

);


// Declare variable data types
reg [7:0]	xo;
reg [8:0]	yo;
		
// Define state-machine definition registers
reg [4:0] state;

// Local Parameters used to define state names
localparam UPDATE_STATE     = 5'b00001;
localparam YINCREMENT_STATE = 5'b00010;
localparam YDECREMENT_STATE = 5'b00100;
localparam XINCREMENT_STATE = 5'b01000;
localparam XDECREMENT_STATE = 5'b10000;


// Define the outputs for each state, which are only dependent on the state
always @(state) begin 
	
	// Initialise state outputs

	
	case (state)
	
		UPDATE_STATE: begin  // Set update flagged HIGH
		end
		
		YINCREMENT_STATE: begin  // Set yincr flagged HIGH
		end
		
		
		YDECREMENT_STATE: begin  // Set ydecr flagged HIGH
		end
		
		XINCREMENT_STATE: begin  // Set xincr flagged HIGH
		end
		
		XDECREMENT_STATE: begin  // Set xdecr flagged HIGH
		end

				
	endcase	
end

always @ (posedge clock or posedge reset) begin
	if (reset) begin 
		
		xorigin        <= 8'd0;
		yorigin         <= 9'd0;
	
	end else begin 
			case (state)
				// Determine whether to increse or decrease x or y value from user input of buttons
				UPDATE_STATE : begin 
					if (keys[0]) begin 
							
						state <= YINCREMENT_STATE;
						
					end else if (keys[1]) begin 
						
						state <= YDECREMENT_STATE;
							
					end else if (keys[2]) begin 
						
						state <= XINCREMENT_STATE;
							
					end else if (keys[3]) begin 
						
						state <= YDECREMENT_STATE;
							
					end
				end
				// Following states increment or decrement x or y value and contains pixel to screen voundary limits 240x320	
				YINCREMENT_STATE : begin
						
					if (yorigin  <= 319) begin
						
						yorigin <= yorigin  +1;
							
						state <= UPDATE_STATE;
						
					end else begin 
						
					state <= UPDATE_STATE;
											
					end
				end
					
				YDECREMENT_STATE : begin
						
					if (yorigin  >= 1 ) begin
						
						yorigin <= yorigin  - 1;
							
						state <= UPDATE_STATE;
						
					end else begin 
						
					state <= UPDATE_STATE;
												
					end
				end
					
				XINCREMENT_STATE : begin
							
					if (xorigin  <= 239) begin
						
						xorigin <= xorigin  +1;
							
						state <= UPDATE_STATE;
						
					end else begin 
						
					state <= UPDATE_STATE;
												
					end
				end
					
				XDECREMENT_STATE : begin

					if (xorigin  >= 1 ) begin
						
						xorigin <= xorigin  - 1;
							
						state <= UPDATE_STATE;
						
					end else begin 
						
						state <= UPDATE_STATE;
												
				end
			end
		endcase
	end
end												


endmodule

