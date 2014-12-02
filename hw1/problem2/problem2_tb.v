module problem2_tb;
	reg clk
	reg [7:0] P;
	
problem2 U0(.P(P), .clk(clk));

initial 
begin
	$display("problem2_tb started");
	clk = 0;
	P = 7'b00000000;
end

always
	#5 clk = !clk;
	
initial 
begin
	$dumpfile("problem2.vcd");
	$dumpvars;
end

initial
begin
	$display("\t\ttime, \tclk, \tP");
	$monitor("%d, \t%b, \t%b", $time, clk, P);
end

initial
	#100 $finish