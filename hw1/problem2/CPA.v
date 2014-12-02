module CPA(Sout, Cout, A, B, Cin);

output Sout, Cout;
input A, B, Cin;

assign Sout = A ^ B ^ Cin;
assign Cout = (A && B) || (Cin && (A ^ B));

endmodule
