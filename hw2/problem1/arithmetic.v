module arithmetic(actualC, overflow, a, b, alu_code, enable);

output reg [15:0] actualC;
output reg overflow;

input [15:0] a,b;
input [4:0] alu_code;
input enable;

reg signed [16:0] signedC;
reg unsigned [16:0] unsignedC;
wire signed [15:0] signedA, signedB;

assign signedA = a;
assign signedB = b;

initial
	overflow = 1'b0;

always @(enable) begin
	
	//add	
	if (alu_code[2:0] == 3'b000)
	begin
		signedC = signedA + signedB;
		actualC = signedC[15:0] ;
		
		if (signedC > 32767 || signedC < -32768)
			overflow = 1'b1;
	end

	//addu
	if (alu_code[2:0] == 3'b001)
	begin
		unsignedC = a + b;
		actualC = unsignedC[15:0];
		
		if (unsignedC[16] == 1'b1)
			overflow = 1'b1;
	end
	
	//sub
	if (alu_code[2:0] == 3'b010)
	begin
		signedC = signedA - signedB;
		actualC = signedC[15:0];
		
		if (signedC > 32767 || signedC < -32768)
			overflow = 1'b1;
	end
	
	//subu
	if (alu_code[2:0] == 3'b011)
	begin
		unsignedC = a - b;
		actualC = unsignedC[15:0];
		
		if (unsignedC[16] == 1'b1)
			overflow = 1'b1;
	end
	
	//inc
	if (alu_code[2:0] == 3'b100)
	begin
		signedC = signedA + 1'b1;
		actualC = signedC[15:0];
		
		if (signedC > 32767 || signedC < -32768)
			overflow = 1'b1;
	end
	
	//dec
	if (alu_code[2:0] == 3'b101)
	begin
		signedC = signedA - 1'b1;
		actualC = signedC[15:0];
		
		if (signedC > 32767 || signedC < -32768)
			overflow = 1'b1;
	end
	
end

endmodule
