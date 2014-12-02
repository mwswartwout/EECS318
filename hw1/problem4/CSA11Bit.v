module CSA11Bit(sOut, cOut, in1, in2, cIn);

output [9:0] sOut;
output [10:0] cOut;

input[9:0] in1, in2, cIn;

fullAdder fullAdder[9:0](sOut[9:0], cOut[10:1], in1[9:0], in2[9:0], cIn[9:0]);
assign cOut[0] = 0;

endmodule
