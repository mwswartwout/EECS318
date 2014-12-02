module logic(c, overflow, a, b, alu_code, enable);

output reg [15:0] c;
output reg overflow;

input [15:0] a,b;
input [4:0] alu_code;
input enable;

initial 
	overflow = 1'b0;

always @(enable) begin

	//and
	if (alu_code[2:0] == 3'b000)
	begin
		c = a && b;
	end

	//or
	if (alu_code[2:0] == 3'b001)
	begin
		c = a || b;
	end
	
	//xor
	if (alu_code[2:0] == 3'b010)
	begin
		c = a ^ b;
	end
	
	//not
	if (alu_code[2:0] == 3'b011)
	begin
		c = ~a;
	end	
end

endmodule
