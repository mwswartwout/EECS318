module DFlipFlop(Q, D, clk);

output reg Q;
input D, clk;

always @(posedge clk)
	Q = D;

endmodule
