module shiftRegister(out, in, clk);

output reg [7:0] out;
input [8:0] in;
input clk;

always @(negedge clk)
begin
	out = in >> 1;
end

endmodule
