module problem3(out, in1, in2);

output [9:0] out;
input [4:0] in1, in2;

wire [4:0] pp1, pp2, pp3, pp4, pp5;
wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26;
wire s2, s4, s5, s7, s8, s9, s11, s12, s13, s15, s16, s17, s19, s20, s21, s23, s24, s25;

assign pp1 = {in1[4] && in2[0], in1[3] && in2[0], in1[2] && in2[0], in1[1] && in2[0], in1[0] && in2[0]};
assign pp2 = {in1[4] && in2[1], in1[3] && in2[1], in1[2] && in2[1], in1[1] && in2[1], in1[0] && in2[1]};
assign pp3 = {in1[4] && in2[2], in1[3] && in2[2], in1[2] && in2[2], in1[1] && in2[2], in1[0] && in2[2]};
assign pp4 = {in1[4] && in2[3], in1[3] && in2[3], in1[2] && in2[3], in1[1] && in2[3], in1[0] && in2[3]};
assign pp5 = {in1[4] && in2[4], in1[3] && in2[4], in1[2] && in2[4], in1[1] && in2[4], in1[0] && in2[4]};

assign out[0] = pp1[0];

CPA CPA1(out[1], c1, pp1[1], pp2[0], 1'b0);

CPA CPA2(s2, c2, pp1[2], pp2[1], c1);
CPA CPA3(out[2], c3, s2, pp3[0], c2);

CPA CPA4(s4, c4, pp1[3], pp2[2], c3);
CPA CPA5(s5, c5, s4, pp3[1], c4);
CPA CPA6(out[3], c6, s5, pp4[0], c5);

CPA CPA7(s7, c7, pp1[4], pp2[3], c6);
CPA CPA8(s8, c8, s7, pp3[2], c7);
CPA CPA9(s9, c9, s8, pp4[1], c8);
CPA CPA10(out[4], c10, s9, pp5[0], c9);

CPA CPA11(s11, c11, pp1[4], pp2[4], c10);
CPA CPA12(s12, c12, s11, pp3[3], c11);
CPA CPA13(s13, c13, s12, pp4[2], c12);
CPA CPA14(out[5], c14, s13, pp5[1], c13);

CPA CPA15(s15, c15, pp1[4], pp2[4], c14);
CPA CPA16(s16, c16, s15, pp3[4], c15);
CPA CPA17(s17, c17, s16, pp4[3], c16);
CPA CPA18(out[6], c18, s17, pp5[2], c17);

CPA CPA19(s19, c19, pp1[4], pp2[4], c18);
CPA CPA20(s20, c20, s19, pp3[4], c19);
CPA CPA21(s21, c21, s20, pp4[4], c20);
CPA CPA22(out[7], c22, s21, pp5[3], c21);

CPA CPA23(s23, c23, pp1[4], pp2[4], c22);
CPA CPA24(s24, c24, s23, pp3[4], c23);
CPA CPA25(s25, c25, s24, pp4[4], c24);
CPA CPA26(out[8], c26, s25, pp5[4], c25);

assign out[9] = c26;

endmodule
