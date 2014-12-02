module CSA9Bit(sOut, cOut, in1, in2, cIn);

output [7:0] sOut;
output [8:0] cOut;

input[7:0] in1, in2, cIn;

fullAdder fullAdder[7:0](sOut[7:0], cOut[8:1], in1[7:0], in2[7:0], cIn[7:0]);
assign cOut[0] = 0;

endmodule
