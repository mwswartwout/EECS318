module structural(out, e, w, clk);

output out;
input e, w;
input clk;

wire qA, qB;
wire gate1, gate2, gate3, gate4, gate5, gate6;

and Gate1(gate1, qA, ~qB);
and Gate2(gate2, qA, w);
or Gate3(gate3, e, gate1, gate2);
DFlipFlop DFFA(qA, gate3, clk);

and Gate4(gate4, qB, ~qA);
and Gate5(gate5, qB, e);
or Gate6(gate6, w, gate4, gate5);
DFlipFlop DFFB(qB, gate6, clk);

and Gate7(out, ~qA, ~qB);

endmodule
