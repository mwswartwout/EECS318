module CSA12Bit(sOut, cOut, in1, in2, cIn);

output [10:0] sOut;
output [11:0] cOut;

input[10:0] in1, in2, cIn;

fullAdder fullAdder[10:0](sOut[10:0], cOut[11:1], in1[10:0], in2[10:0], cIn[10:0]);
assign cOut[0] = 0;

endmodule
