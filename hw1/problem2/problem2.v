module problem2(P, clk);

output wire [7:0] P;
input clk;

wire [3:0] A, B;

wire [7:0] postAdd;
wire adderCarry, cOut;

DFlipFlop DFF(cOut, adderCarry, clk);
Adder Adder(postAdd, P[7:4], {B[3] && A[0], B[2] && A[0], B[1] && A[0], B[0] && A[0]}, adderCarry, clk);
shiftRegister shiftRegister(P, {cOut, postAdd}, clk);

assign A = P[3:0];

endmodule

