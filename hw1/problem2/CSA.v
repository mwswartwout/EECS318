module CSA(Sout, Cout, Sin, A, B, Cin);

output Sout, Cout;
input A, B, Sin, Cin;

wire combine;

assign combine = A && B;
assign Sout = combine ^ Sin ^ Cin;
assign Cout = (combine && Sin) || (Cin && (combine ^ Sin));

endmodule
