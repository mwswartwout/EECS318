module problem4(out, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10);

output [11:0] out;
input [7:0] in1, in2, in3, in4, in5, in6, in7, in8, in9, in10;

wire [7:0] sOut1;
wire [8:0] cOut1;

wire [8:0] sOut2;
wire [9:0] cOut2;

wire [9:0] sOut3, sOut4, sOut5, sOut6;
wire [10:0] cOut3, cOut4, cOut5, cOut6;

wire [10:0] sOut7;
wire [11:0] cOut7;

CSA9Bit CSA1(sOut1, cOut1, in1, in2, in3);

CSA10Bit CSA2(sOut2, cOut2, sOut1, in4, cOut1);

CSA11Bit CSA3(sOut3, cOut3, sOut2, in5, cOut2);
CSA11Bit CSA4(sOut4, cOut4, sOut3, in6, cOut3);
CSA11Bit CSA5(sOut5, cOut5, sOut4, in7, cOut4);
CSA11Bit CSA6(sOut6, cOut6, sOut5, in8, cOut5);

CSA12Bit CSA7(sOut7, cOut7, sOut6, in9, cOut6);

assign out = sOut7 + cOut7 + in10;

endmodule
