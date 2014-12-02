//4 x 4 bit multiplier
module problem2test(final, clk, number1, number2);

input [3:0] number1, number2;
reg [3:0] P, A, B, temp;
reg [4:0] tempSum;
input clk;
reg carryOut;
output reg [7:0] final;
reg [2:0] count;
integer i;

initial
begin
	A = number1;
	B = number2;
	P = 4'b0000;
	carryOut = 1'b0;
	count = 3'b000;
	final = 8'b00000000;
	temp = 4'b0000;
	tempSum = 5'b00000;
end

always @(posedge clk)
begin
	count = count + 1'b1;
	
	if (count == 3'b100)
	begin
		final[7:4] = P;
		final[3:0] = A;
		
		A = number1;
	  B = number2;
	  P = 4'b0000;
	  carryOut = 1'b0;
	  count = 3'b000;
	  temp = 4'b0000;
	  tempSum = 5'b00000;
	end
	
	else
	begin
		A = A >> 1;
		A[3] = P[0];
		P = P >> 1;
		for (i = 0; i < 4; i = i + 1)
			temp[i] = B[i] && A[0];
		tempSum = temp + P;
		P[3:0] = tempSum[3:0];
		carryOut = tempSum[4];
	end
end

endmodule
