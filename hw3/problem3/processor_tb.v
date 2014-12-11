module processor_tb();

reg [31:0] instruction;
wire [4:0] psr;
reg clock;

processor UUT(.instruction(instruction), .clock(clock), .psr(psr));

initial begin
	instruction = 31'd0;
	clock = 1'b0;
end

always begin
	#5 clock <= ~clock;
end

always begin

	//Problem 3
	//First test is to load N = 6 into memory 0, then complement it and store it in memory one
	instruction[31:28] <= 4'd2; //Store
	instruction[27] <= 1'b1; //Source = immediate
	instruction[23:12] <= 12'd6; //N = 6
	instruction[11:0] <= 12'd0; //Stored in memory 0
	#10
	resetInstruction;
	#10
	instruction[31:28] <= 4'd1; // Load
	instruction[27] <= 1'b0; //Source = memory
	instruction[23:12] <= 12'd0; //Source address = memory 0
	instruction[11:0] <= 12'd0; // Destination address = register 0
	#10
	resetInstruction;
	#10
	instruction[31:28] <= 4'd9; //Complement
	instruction[27] <= 1'b0; //Source = register
	instruction[26] <= 1'b0; //Destination = register
	instruction[23:12] <= 12'd0; //Source address = register 0
	instruction[11:0] <= 12'd0; //Destination address = register 0;
	#10
	resetInstruction;
	#10
	instruction[31:28] <= 4'd5; //Add
	instruction[27] <= 1'b1; //Source = immediate
	instruction[26] <= 1'b0; //Destination = register
	instruction[23:12] <= 12'd1; //Source value
	instruction[11:0] <= 12'd0; //Destination address = register 0;
	#10
	resetInstruction;
	#10
	instruction[31:28] <= 4'd2; //Store
	instruction[27] <= 1'b0; // Source = register
	instruction[23:12] <= 12'd0; // Source = register 0;
	instruction[11:0] <= 12'd1; // Destination = memory 1;
	#10
	resetInstruction;
	#10
	
	//Problem 4
	//Added an OPCODE 10 to count the 1s in memory 0 and store the sum in memory 1
	instruction[31:28] = 4'd10;
	#10
	resetInstruction;
	#10
	
	//Problem 5
	//Added an OPCODE 11 to multiply memory 0 and 1 and store the product in memory 2
	instruction[31:28] = 4'd11;
	#10
	
	$finish;
end

task resetInstruction; begin
	instruction = 32'd0;
end
endtask
endmodule 
