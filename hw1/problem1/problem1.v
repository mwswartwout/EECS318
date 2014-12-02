module problem1(out, x, y);

output [7:0] out;
input [3:0] x, y;

wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, c20;
wire s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20;

CSA CSA1(s1, c1, 1'b0, y[0], x[0], 1'b0);
CSA CSA2(s2, c2, 1'b0, y[1], x[0], 1'b0);
CSA CSA3(s3, c3, 1'b0, y[2], x[0], 1'b0);
CSA CSA4(s4, c4, 1'b0, y[3], x[0], 1'b0);
CSA CSA5(s5, c5, s2, y[0], x[1], c1);
CSA CSA6(s6, c6, s3, y[1], x[1], c2);
CSA CSA7(s7, c7, s4, y[2], x[1], c3);
CSA CSA8(s8, c8, 1'b0, y[3], x[1], c4);
CSA CSA9(s9, c9, s6, y[0], x[2], c5);
CSA CSA10(s10, c10, s7, y[1], x[2], c6);
CSA CSA11(s11, c11, s8, y[2], x[2], c7);
CSA CSA12(s12, c12, 1'b0, y[3], x[2], c8);
CSA CSA13(s13, c13, s10, y[0], x[3], c9);
CSA CSA14(s14, c14, s11, y[1], x[3], c10);
CSA CSA15(s15, c15, s12, y[2], x[3], c11);
CSA CSA16(s16, c16, 1'b0, y[3], x[3], c12);
CPA CPA17(s17, c17, s14, c13, 1'b0);
CPA CPA18(s18, c18, s15, c14, c17);
CPA CPA19(s19, c19, s16, c15, c18);
CPA CPA20(s20, c20, 1'b0, c16, c19);

assign out[0] = s1;
assign out[1] = s5;
assign out[2] = s9;
assign out[3] = s13;
assign out[4] = s17;
assign out[5] = s18;
assign out[6] = s19;
assign out[7] = s20;

endmodule
