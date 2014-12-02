module CSA10Bit(sOut, cOut, in1, in2, cIn);

output [8:0] sOut;
output [9:0] cOut;

input[8:0] in1, in2, cIn;

fullAdder fullAdder[8:0](sOut[8:0], cOut[9:1], in1[8:0], in2[8:0], cIn[8:0]);
assign cOut[0] = 0;

endmodule
