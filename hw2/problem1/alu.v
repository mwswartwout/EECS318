module alu(actualC, actualOverflow, a, b, alu_code, enable);

output reg [15:0] actualC;
output reg actualOverflow;

input [15:0] a,b;
input [4:0] alu_code;
input enable;

wire [15:0] arithmeticC, logicC, shiftC, setC;
wire arithmeticOverflow, logicOverflow, shiftOverflow, setOverflow;

arithmetic arithmetic(arithmeticC, arithmeticOverflow, a, b, alu_code, enable);
logic logic(logicC, logicOverflow, a, b, alu_code, enable);
shift shift(shiftC, shiftOverflow, a, b, alu_code, enable);
set set(setC, setOverflow, a, b, alu_code, enable);

always @(enable) begin
	if (alu_code[4:3] == 2'b00)
	begin
		actualC = arithmeticC;
		actualOverflow = arithmeticOverflow;
	end

	else if (alu_code[4:3] == 2'b01)
	begin
		actualC = logicC;
		actualOverflow = logicOverflow;
	end

	else if (alu_code[4:3] == 2'b10)
	begin
		actualC = shiftC;
		actualOverflow = shiftOverflow;
	end

	else if (alu_code[4:3] == 2'b11)
	begin
		actualC = setC;
		actualOverflow = setOverflow;
	end
end

endmodule
