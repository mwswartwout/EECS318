module processor(clock);

/*	Instruction Register Detail
	31:28 - Opcode
	27:24 - CC
	27	- Source Type (0 = reg || mem, 1 = imm)
	26	- Destination Type (0 = reg, 1 = imm)
	23:12 - Source address
	23:12 - Shift/Rotate Count
	11:0 - Destination Address
*/
input clock;

reg [31:0] memory [4095:0]; //12-bit address allows 4096 possible memory addresses
reg [11:0] register [4:0]; //16 registers (i.e. 5-bit address) that are each 12-bits wide (maximum width of immediate value)

reg [31:0] instruction;
reg [23:0] doubleWidth;
reg [11:0] sourceValue, result;
reg signed [11:0] count;
reg [4:0] psr;
reg carry;

integer i, j, programCounter;

initial begin
	//Instantiate Memory
	memory[4] = {4'd2, 1'b1, 12'd6, 12'd0};
	memory[5] = {4'd1, 1'b0, 12'd0, 12'd0};
	memory[6] = {4'd9, 1'b0, 1'b0, 12'd0, 12'd0};
	memory[7] = {4'd5, 1'b1, 1'b0, 12'd1, 12'd0};
	memory[8] = {4'd2, 1'b0, 12'd0, 12'd1};
	memory[9] = {4'd10, 28'd0};
	memory[10] = {4'd11, 28'd0};
	
	//Clear registers
	for (i = 0; i < 5; i = i + 1) begin
		register[i] = 12'd0;
	end
	
	programCounter = 4; //Sets program counter to 4, which we will be using for beginning all programs
	doubleWidth = 24'd0;
	sourceValue = 12'd0;
	result = 12'd0;
	carry = 1'b0;
end

always @(posedge clock) begin
	instruction = memory[programCounter];
	getSourceValue;
	
	//Clear carry, result, count, and doubleWidth
	carry = 1'b0;
	result = 12'd0;
	count = 12'd0;
	doubleWidth = 24'd0;
	
	case (instruction[31:28])
		4'd0: begin //NOP
			programCounter = programCounter + 1;
		end
		4'd1: begin //LOAD
			result = sourceValue;
			register[instruction[11:0]] = result; //LOAD loads value from source into a register
			setPSR;
			programCounter = programCounter + 1;
		end
		4'd2: begin //STORE
			memory[instruction[11:0]] = sourceValue; //STORE stores value from source into memory
			clearPSR;
			programCounter = programCounter + 1;
		end
		4'd3: begin //BRANCH
			case (instruction[27:24]) //Condition code
				4'd0: begin //Always
					programCounter = programCounter + 1;
				end
				4'd1: begin //Parity
					if (psr[1] == 1'b1) programCounter = instruction[11:0];
					else programCounter = programCounter + 1;
				end
				4'd2: begin //Even
					if (psr[2] == 1'b1) programCounter = instruction[11:0];
					else programCounter = programCounter + 1;
				end
				4'd3: begin //Carry
					if (psr[0] == 1'b1) programCounter = instruction[11:0];
					else programCounter = programCounter + 1;
				end
				4'd4: begin //Negative
					if (psr[3] == 1'b1) programCounter = instruction[11:0];
					else programCounter = programCounter + 1;
				end
				4'd5: begin //Zero
					if (psr[4] == 1'b1) programCounter = instruction[11:0];
					else programCounter = programCounter + 1;
				end
				4'd6: begin //No Carry
					if (psr[0] == 1'b0) programCounter = instruction[11:0];
					else programCounter = programCounter + 1;
				end
				4'd7: begin //Positive
					if (psr[3] == 1'b0) programCounter = instruction[11:0];
					else programCounter = programCounter + 1;
				end
			endcase
		end
		4'd4: begin //XOR
			register[instruction[11:0]] = register[instruction[11:0]] ^ sourceValue;
			setPSR;
			programCounter = programCounter + 1;
		end
		4'd5: begin //ADD
			{carry, register[instruction[11:0]]} = register[instruction[11:0]] + sourceValue;
			setPSR;
			programCounter = programCounter + 1;
		end
		4'd6: begin //ROTATE
			doubleWidth = {register[instruction[11:0]], register[instruction[11:0]]};
			if (count > 0) //Rotate right
				register[instruction[11:0]] = doubleWidth[24 - sourceValue -: 12];
			else //Rotate left
				register[instruction[11:0]] = doubleWidth[12 + sourceValue -: 12];
			setPSR;
			programCounter = programCounter + 1;
		end
		4'd7: begin //SHIFT
			if (count > 0) //Shift right
				register[instruction[11:0]] = count >> sourceValue;
			else //Shift left
				register[instruction[11:0]] = count << sourceValue;
			setPSR;
			programCounter = programCounter + 1;
		end
		4'd8: begin
			$finish; //HALT
		end
		4'd9: begin //Complement
			register[instruction[11:0]] = ~sourceValue;
			programCounter = programCounter + 1;
		end
		4'd10: begin //1s count (problem 4)
			j = 0;
			for (i = 0; i < 12; i = i + 1)
				if (memory[0][i] == 1'b1) j = j + 1;
			memory[1] = j;
			programCounter = programCounter + 1;
		end
		4'd11: begin //Multiply (problem 5)
			memory[2] = memory[0] * memory[1];
			programCounter = programCounter + 1;
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