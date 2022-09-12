/* updatePixel testbench
 * -------------------------
 * ELEC5566M: Mini-project
 * By: Luke Stock 
 * SID: 201148579
 * Date: 22nd May 2022
 *
 * Module Description:
 * -------------------
 * Auto-verifying testbench for updaePixel module. 
 */
 
// Create a timescale to indicate units of delay 
// Here: units = 1 ns; precision = 100 ps. 
`timescale 1 ns/100 ps

// Declare test bench module 
module updatePixel_tb; 

// Test bench generated signals 
reg clock, reset;
reg [3:0] keys;

// DUT output signals
wire [7:0] xorigin;
wire [8:0] yorigin;

// DUT
updatePixel updatePixel_dut (
	// Declare parameters
	.clock		 (clock),
	.reset		 (reset), 
	.xorigin     (xorigin),
	.yorigin     (yorigin)

);

 localparam NUM_CYCLES = 50;      //Simulate this many clock cycles. Max. 1 billion
 localparam CLOCK_FREQ = 5000000; //Clock frequency (in Hz)
 localparam RST_CYCLES = 2;       //Number of cycles of reset at beginning.

 // Initialise loop counter value and expected value
 integer i;

// Initialise clock to zero.
 initial begin 
 
	clock = 1'b0;
	
 end 
 
 // Toggle clock every 5 ns
 always begin 
 
	#2;
	clock = ~clock;
	
 end

 
 initial begin 
	
	// Initialise in reset 
	reset_task();
		
		// Test unlocked state
		$display("TESTING KEY INPUT");
		
		// Test for all buttons pushes
		for (i = 0; i < 5; i = i + 1) begin
			
								
			keys <= i;
			
			@(posedge clock);
			
			if (keys == 4'b0000) begin 
			
				$display("ERROR! When no key is pressed state transitions to UPDATE state. Outputs: xorigin = %b; yorigin = %b.",
							xorigin, yorigin);
				
				$stop;
				
			end
		
			if (xorigin == 0) begin 
					
				$display("ERROR! When a key is pressed state does NOT update xorigin. Outputs: xorigin = %b; yorigin = %b..",
							xorigin, yorigin);
							
				
			end
			
			if (yorigin == 0) begin 
					
				$display("ERROR! When a key is pressed state does NOT update xorigin. Outputs: xorigin = %b; yorigin = %b..",
							xorigin, yorigin);
							
				
			end
			
				
			#10; //Wait 10 units.
		
		end 
	

	$stop;
end

	

 
 task reset_task();
	begin
		
		// Initialise reset then clear reset 
		reset = 1'b1;
		repeat(RST_CYCLES) @(negedge clock);
		reset = 1'b0;
		
	end  
 endtask
 
 endmodule
