module regfile(
    input [4:0] rs1,      // address of first operand to read - 5 bits
    input [4:0] rs2,      // address of second operand
    input [4:0] rd,       // address of value to write
    input we,             // should write update occur
    input [31:0] wdata,   // value to be written
    output [31:0] rv1,    // First read value
    output [31:0] rv2,    // Second read value
    input clk,            // Clock signal
    input [5:0] op,       // Opcode from dummydecoder
    input [31:0] instr,   // To find daddr
    output reg [31:0] daddr 
);
   // This regfile contains all 32 register values in 2d array Reg
        integer i;
    reg [31:0] Reg [0:31];
	reg [31:0] rv1, rv2;

    //Initialize registers with 0
	initial begin
		for (i=0;i<32;i=i+1) begin
			Reg[i] = 0;
		end
        daddr = 0; 
	end

   
    always @* begin
		rv1 = Reg[rs1];
		rv2 = Reg[rs2]; 
        // The case statement assigns daddr so corresponding drdata can be used in ALU
        case (op)
            19,20,21,22,
            23: daddr = rv1 + {{20{instr[31]}},instr[31:20]}; // Load instructions
            24,25,
            26: daddr = rv1 + {{20{instr[31]}},instr[31:25], instr[11:7]}; // Store instructions
            default: daddr =0;
        endcase 
        end
    
    always @(posedge clk)begin
		if (we == 1)begin
            if (rd != 0)begin            //Force Reg[0] = 0
                Reg[rd] <= wdata;
            end
		end
    end   
endmodule