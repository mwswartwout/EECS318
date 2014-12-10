module processor(instruction, clock, psr);

/*	Instruction Register Detail
	31:28 - Opcode
	27:24 - CC
	27	- Source Type (0 = reg || mem, 1 = imm)
	26	- Destination Type (0 = reg, 1 = imm)
	23:12 - Source address
	23:12 - Shift/Rotate Count
	11:0 - Destination Address
*/
input [31:0] instruction;
input clock;
output reg [4:0] psr;

reg [11:0] memory [4095:0]; //12-bit address allows 4096 possible memory addresses
reg [11:0] register [4:0]; //16 registers (i.e. 5-bit address) that are each 12-bits wide (maximum width of immediate value)

reg [23:0] doubleWidth;
reg [11:0] sourceValue, result;
reg signed [11:0] count;
reg carry;

integer i, j;

initial begin
	//Clear memory
	for (i = 0; i < 4096; i = i + 1) begin
		memory[i] = 1'b0;
	end
	
	//Clear registers
	for (i = 0; i < 5; i = i + 1) begin
		register[i] = 12'd0;
	end
	
	doubleWidth = 24'd0;
	sourceValue = 12'd0;
	result = 12'd0;
	carry = 1'b0;
end

always @(posedge clock) begin
	getSourceValue;
	
	//Clear carry, result, count, and doubleWidth
	carry = 1'b0;
	result = 12'd0;
	count = 12'd0;
	doubleWidth = 24'd0;
	case (instruction[31:28])
		4'd0:; //NOP
		4'd1: begin //LOAD
			result = sourceValue;
			register[instruction[11:0]] = result; //LOAD loads value from source into a register
			setPSR;
		end
		4'd2: begin //STORE
			memory[instruction[11:0]] = sourceValue; //STORE stores value from source into memory
			clearPSR;
		end
		4'd3: begin //BRANCH
		end //I have no idea what to do with this right now
		4'd4: begin //XOR
			register[instruction[11:0]] = register[instruction[11:0]] ^ sourceValue;
			setPSR;
		end
		4'd5: begin //ADD
			{carry, register[instruction[11:0]]} = register[instruction[11:0]] + sourceValue;
			setPSR;
		end
		4'd6: begin //ROTATE
			doubleWidth = {register[instruction[11:0]], register[instruction[11:0]]};
			if (count > 0) //Rotate right
				register[instruction[11:0]] = doubleWidth[24 - sourceValue -: 12];
			else //Rotate left
				register[instruction[11:0]] = doubleWidth[12 + sourceValue -: 12];
			setPSR;
		end
		4'd7: begin //SHIFT
			if (count > 0) //Shift right
				register[instruction[11:0]] = count >> sourceValue;
			else //Shift left
				register[instruction[11:0]] = count << sourceValue;
			setPSR;
		end
		4'd8:; //HALT does nothing, processor waits until next clock cycle to see if it has a new instruction
		4'd9: begin //Complement
			register[instruction[11:0]] = ~sourceValue;
		end
	endcase
end

task clearPSR; begin
	psr = 5'd0;
end
endtask

task setPSR; begin
	//Carry bit
	if (carry == 1'b1) psr[0] = 1'b1;
	else psr[0] = 1'b0;
	
	//Parity bit
	j = 0;
	for (i = 0; i < 12; i = i + 1) begin
		if (result[i] == 1) j = j + 1;
	end 
	if (count % 2 == 0) psr[1] = 1'b1;
	else psr[1] = 1'b0;
		
	//Even and Odd bit
	if (result % 2 == 0) begin
		psr[2] = 1'b1;
		psr[4] = 1'b0;
	end
	else begin
		psr[2] = 1'b0;
		psr[4] = 1'b1;
	end
	
	//Negative bit
	if (result[11] == 1'b1) psr[3] = 1'b1;
	else psr[3] = 1'b0;
end	
endtask

task getSourceValue; begin
	case (instruction[31:28])
		4'd1: begin //LOAD source can be memory or immediate
			if (instruction[27] == 1'b0)
				sourceValue = memory[instruction[23:12]];
			else
				sourceValue = instruction[23:12];
		end
		4'd2, //STORE
		4'd4, //XOR
		4'd5, //ADD
		4'd9: //COMPLEMENT
		begin //Source can be register or immediate
			if (instruction[27] == 1'b0)
				sourceValue = register[instruction[23:12]];
			else
				sourceValue = instruction[23:12];
		end
		4'd6, //ROTATE
		4'd7: //SHIFT
		begin
			count = instruction[23:12];
			if (count[11] == 1'b0) sourceValue = count;
			else sourceValue = {1'b0, count[10:0]} - 12'd2048;
		end
		default:
			sourceValue = 12'd0;
	endcase
end
endtask
endmodule