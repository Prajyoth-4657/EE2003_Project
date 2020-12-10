module dummydecoder(
    input [31:0] instr,      // Full 32-b instruction
    output reg [5:0] op,     // Opcode
    output reg [4:0] rs1,    // First operand
    output reg [4:0] rs2,    // Second operand
    output reg [4:0] rd,     // Output reg
    input  [31:0] r_rv2,     // From RegFile
    output reg [31:0] rv2,   // To ALU
    output reg we            // Write enable
);

    always @* begin
	//Case is conditional on funct3 and opcode bits
    // This dummydecoder assigns op, rs1, rs2, rd and we, and chooses rv2 from regfile or immediate 
        case({instr[14:12], instr[6:0]})
            10'b0000010011 : begin op = 0; rv2 = {{20{instr[31]}},instr[31:20]}; we = 1;end			//ADDI
            10'b0100010011 : begin op = 1; rv2 = {{20{instr[31]}},instr[31:20]}; we = 1;end			//SLTI
            10'b0110010011 : begin op = 2; rv2 = {{20{instr[31]}},instr[31:20]}; we = 1;end			//SLTIU
            10'b1000010011 : begin op = 3; rv2 = {{20{instr[31]}},instr[31:20]}; we = 1;end			//XORI
            10'b1100010011 : begin op = 4; rv2 = {{20{instr[31]}},instr[31:20]}; we = 1;end			//ORI
            10'b1110010011 : begin op = 5; rv2 = {{20{instr[31]}},instr[31:20]}; we = 1;end			//ANDI
            10'b0010010011 : begin op = 6; rv2 = {{20{instr[31]}},instr[31:20]}; we = 1;end			//SLLI
            10'b1010010011 : begin op = instr[30] ? 7 : 8;  rv2 = instr[24:20]; we = 1;end	//SRAI,SRLI
            10'b0000110011 : begin op = instr[30] ? 9 : 10; rv2 = r_rv2; we = 1;end	//SUB,ADD
		    10'b0010110011 : begin op = 11; rv2 = r_rv2; we = 1;end			   //SLL
		    10'b0100110011 : begin op = 12; rv2 = r_rv2; we = 1;end			   //SLT
		    10'b0110110011 : begin op = 13; rv2 = r_rv2; we = 1;end			   //SLTU
		    10'b1000110011 : begin op = 14; rv2 = r_rv2; we = 1;end			   //XOR
            10'b1010110011 : begin op = instr[30] ? 15 : 16; rv2 = r_rv2; we = 1;end	//SRA,SRL
		    10'b1100110011 : begin op = 17; rv2 = r_rv2; we = 1;end			   //OR
		    10'b1110110011 : begin op = 18; rv2 = r_rv2; we = 1;end			   //AND
            10'b0000000011 : begin op = 19; rv2 = r_rv2; we = 1;end            //LB
            10'b0010000011 : begin op = 20; rv2 = r_rv2; we = 1;end            //LH
            10'b0100000011 : begin op = 21; rv2 = r_rv2; we = 1;end            //LW
            10'b1000000011 : begin op = 22; rv2 = r_rv2; we = 1;end            //LBU
            10'b1010000011 : begin op = 23; rv2 = r_rv2; we = 1;end            //LHU
            10'b0000100011 : begin op = 24; rv2 = r_rv2; we = 0;end            //SB
            10'b0010100011 : begin op = 25; rv2 = r_rv2; we = 0;end            //SH
            10'b0100100011 : begin op = 26; rv2 = r_rv2; we = 0;end            //SW
            10'b0001100011 : begin op = 27; rv2 = r_rv2; we = 0;end            //BEQ
            10'b0011100011 : begin op = 28; rv2 = r_rv2; we = 0;end            //BNE
            10'b1001100011 : begin op = 29; rv2 = r_rv2; we = 0;end            //BLT
            10'b1011100011 : begin op = 30; rv2 = r_rv2; we = 0;end            //BGE
            10'b1101100011 : begin op = 31; rv2 = r_rv2; we = 0;end            //BLTU
            10'b1111100011 : begin op = 32; rv2 = r_rv2; we = 0;end            //BGEU
            10'b0001100111 : begin op = 34; rv2 = r_rv2; we = 1;end            //JALR
            default:begin
                // Separate case statement since these don't have unique instr[14:12]
                 case (instr[6:0])
            7'b1101111 : begin op = 33; rv2 = r_rv2; we = 1;end            //JAL
            7'b0110111 : begin op = 35; rv2 = r_rv2; we = 1;end            //LUI
            7'b0010111 : begin op = 36; rv2 = r_rv2; we = 1;end            //AUIPC
                     // To assign write enable to zero for no instruction
                     default:begin op = 0; we = 0;rv2=r_rv2; end
        endcase
            end
	endcase
     rs1 = instr [19:15];
     rs2 = instr [24:20];
     rd  = instr [11:7];
    end
endmodule