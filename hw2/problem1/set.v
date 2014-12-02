module set(c, overflow, a, b, alu_code, enable);

output reg [15:0] c;
output reg overflow;

input [15:0] a,b;
input [4:0] alu_code;
input enable;

initial
begin
	overflow = 1'b0;
	c = 16'b0000000000000000;
end

always @(enable) begin

	//sle
	if (alu_code[2:0] == 3'b000)
	begin
		if (a <= b)
			c = 16'b0000000000000001;
	end

	//slt
	if (alu_code[2:0] == 3'b001)
	begin
		if (a < b)
			c = 16'b0000000000000001;
	end
	
	//sge
	if (alu_code[2:0] == 3'b010)
	begin
		if (a >= b)
			c = 16'b0000000000000001;
	end
	
	//sgt
	if (alu_code[2:0] == 3'b011)
	begin
		if (a > b)
			c = 16'b0000000000000001;
	end
	
	//seq
	if (alu_code[2:0] == 3'b100)
	begin
		if (a == b)
			c = 16'b0000000000000001;
	end
	
	//sne
	if (alu_code[2:0] == 3'b101)
	begin
		if (a != b)
			c = 16'b0000000000000001;
	end
end

endmodule

