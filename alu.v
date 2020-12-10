module alu(
    input [5:0] op,       // Opcode
    input [31:0] rv1,     // First operand
    input [31:0] rv2,     // Second operand
    output [31:0] rvout,  // Output value
    input [31:0] drdata,  // Value to load 
    output [31:0] dwdata, // Value to Store
    output [3:0] dwe,     // dmem write enable
    input [31:0] daddr,    // dmem address
    input [31:0] iaddr,
    input [31:0] instr
);
    reg [31:0] rvout;
    reg [31:0] dwdata;
    reg [3:0] dwe; 
    // Initializing variables to 0
    initial begin 
        dwdata = 0;
        dwe = 0;
    end
    
    always @* begin

    // rvout or dwdata is evaluated corresponding to op from dummydecoder, PC value is not evaluated here
    // Instruction corresponding to each op is listed against each line
	case(op)
        0  : begin rvout = rv1 + rv2;                   dwe=0;dwdata = 0;end					    //ADDI
        1  : begin rvout = $signed(rv1) < $signed(rv2); dwe=0;dwdata = 0; end	    //SLTI
        2  : begin rvout = rv1 < rv2;                   dwe=0;dwdata = 0;end				            //SLTIU
		3  : begin rvout = rv1 ^ rv2;                   dwe=0;dwdata = 0;end					        //XORI
		4  : begin rvout = rv1 | rv2;                   dwe=0;dwdata = 0;end					        //ORI
		5  : begin rvout = rv1 & rv2;                   dwe=0;dwdata = 0;end					        //ANDI
        6  : begin rvout = rv1 << rv2[4:0];             dwe=0;dwdata = 0;end				    //SLLI
        7  : begin rvout = $signed(rv1) >>> rv2[4:0];   dwe=0;dwdata = 0;end			//SRAI
        8  : begin rvout = rv1 >> rv2[4:0];             dwe=0;dwdata = 0;end				    //SRLI
		9  : begin rvout = rv1 - rv2;                   dwe=0;dwdata = 0;end					        //SUB
		10 : begin rvout = rv1 + rv2;                   dwe=0;dwdata = 0;end					        //ADD
        11 : begin rvout = rv1 << rv2[4:0];             dwe=0;dwdata = 0;end				    //SLL
        12 : begin rvout = $signed(rv1) < $signed(rv2); dwe=0;dwdata = 0;end	    //SLT
		13 : begin rvout = rv1 < rv2;                   dwe=0;dwdata = 0;end				            //SLTU
		14 : begin rvout = rv1 ^ rv2;                   dwe=0;dwdata = 0;end					        //XOR
        15 : begin rvout = $signed(rv1) >>> rv2[4:0];   dwe=0;dwdata = 0;end			//SRA
        16 : begin rvout = rv1 >> rv2[4:0];             dwe=0;dwdata = 0;end				    //SRL
		17 : begin rvout = rv1 | rv2;                   dwe=0;dwdata = 0;end					        //OR
        18 : begin rvout = rv1 & rv2;                   dwe=0;dwdata = 0;end					        //AND
        19 : begin dwe = 0;dwdata = 0;                                             //LB
            // The following case statements take care of aligning in case daddr is not multiple of 4
            case (daddr[1:0])
                2'b00: rvout = {{24{drdata[7]}}, drdata[7:0]};
                2'b01: rvout = {{24{drdata[15]}}, drdata[15:8]};
                2'b10: rvout = {{24{drdata[23]}}, drdata[23:16]};
                2'b11: rvout = {{24{drdata[31]}}, drdata[31:24]};
                default: rvout = {{24{drdata[7]}}, drdata[7:0]};
            endcase
                end                                                    
        20 : begin  dwe = 0;dwdata = 0;                                              //LH
            case (daddr[1:0])
                2'b00: rvout = {{16{drdata[15]}}, drdata[15:0]};
                2'b10: rvout = {{16{drdata[31]}}, drdata[31:16]};
                default:rvout = {{16{drdata[15]}}, drdata[15:0]};
            endcase
                end                                                     
        21 : begin rvout = drdata; dwe = 0;dwdata = 0; end                           //LW
        22 : begin dwe = 0;dwdata = 0;                                               //LBU
            case (daddr[1:0])
                2'b00: rvout = {{24{1'b0}}, drdata[7:0]};
                2'b01: rvout = {{24{1'b0}}, drdata[15:8]};
                2'b10: rvout = {{24{1'b0}}, drdata[23:16]};
                2'b11: rvout = {{24{1'b0}}, drdata[31:24]};
                default: rvout = {{24{1'b0}}, drdata[7:0]};
            endcase
                end                                                     
        23 : begin dwe = 0;dwdata = 0;                                                //LHU
            case (daddr[1:0])
                2'b00: rvout = {{16{1'b0}}, drdata[15:0]};
                2'b10: rvout = {{16{1'b0}}, drdata[31:16]};
                default:rvout = {{16{1'b0}}, drdata[15:0]};
            endcase
                end                                                   
        24 : begin dwdata = rv2;rvout=0;                                           //SB
            case(daddr[1:0])
                2'b00: dwe = 4'b0001;
                2'b01: dwe = 4'b0010;
                2'b10: dwe = 4'b0100;
                2'b11: dwe = 4'b1000;
                default:dwe = 4'b0001;
            endcase 
        end                                                            
        25 : begin dwdata = rv2;rvout=0;                                            //SH
            case(daddr[1:0])
                2'b00: dwe = 4'b0011;
                2'b10: dwe = 4'b1100;
                default:dwe = 4'b0011;
            endcase
        end                                                            
        26 : begin dwdata = rv2; dwe = 4'b1111;rvout=0; end                         //SW
        27 : begin dwe = 0;dwdata = 0;rvout=0; end                                             //BEQ
        28 : begin dwe = 0;dwdata = 0;rvout=0; end                                             //BNE
        29 : begin dwe = 0;dwdata = 0;rvout=0; end                                             //BLT
        30 : begin dwe = 0;dwdata = 0;rvout=0; end                                             //BGE
        31 : begin dwe = 0;dwdata = 0;rvout=0; end                                             //BLTU
        32 : begin dwe = 0;dwdata = 0;rvout=0; end                                             //BGEU
        33 : begin rvout = iaddr + 4; dwe = 0;dwdata = 0;end                           //JAL
        34 : begin rvout = iaddr + 4; dwe = 0;dwdata = 0;end                           //JALR
        35 : begin rvout = {instr[31:12],{12{1'b0}}}; dwe = 0;dwdata = 0;end           //LUI
        36 : begin rvout = iaddr + {instr[31:12],{12{1'b0}}}; dwe = 0;dwdata = 0;end   //AUIPC
            
        default : begin rvout = 0;dwdata=0;dwe=0;end
	endcase
    end
endmodule