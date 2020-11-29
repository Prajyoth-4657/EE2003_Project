module cpu (
    input clk, 
    input reset,
    output [31:0] iaddr,
    input [31:0] idata,
    output [31:0] daddr,
    input [31:0] drdata,
    output [31:0] dwdata,
    output [3:0] dwe
);
    reg [31:0] iaddr, daddr, dwdata;
    reg [3:0]  dwe;
    wire [31:0] daddr1, dwdata1, rv1, rv2, rvout, r_rv2, wdata;
    wire [3:0] dwe1;
    wire [5:0] op;
    wire [4:0] rs1, rs2, rd;
    wire we;
    // This code implements arithmetic, load/store and branch instructions of RISC-V ISA
   
    // The ALU generates rvout or dwdata according to op from decoder and send to regfile or dmem respectively 
    alu u1(
        .op(op),             // Opcode
        .rv1(rv1),           // From regfile
        .rv2(rv2),
        .rvout(rvout),       // To regfile
        .drdata(drdata),     // From dmem
        .dwdata(dwdata1),    // To dmem
        .dwe(dwe1),
        .daddr(daddr1),
        .iaddr(iaddr),       // Program counter
        .instr(idata)        // Instruction
    );
    
    // The regfile contains all register values of cpu
    regfile u2(
        .rs1(rs1),           // Address from dummydecoder
        .rs2(rs2),
        .rd(rd),
        .we(we),             // Write enable
        .wdata(rvout),
        .rv1(rv1),
        .rv2(r_rv2),
        .clk(clk),
        .op(op),             // For daddr
        .instr(idata),
        .daddr(daddr1)       // To ALU
    );
    
    // Dummydecoder creates opcode op and chooses second operand from regfile or instruction for ALU
    dummydecoder u3(
        .instr(idata),
        .op(op),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .r_rv2(r_rv2),
        .rv2(rv2),
        .we(we)
    );
    
    // The values from alu module is updated to send to dmem
    always @* begin
        if (reset) begin
            daddr = 0;
            dwdata = 0;
            dwe = 0;
        end
            else begin
        daddr = daddr1;
        dwdata = dwdata1;
        dwe = dwe1;
            end
    end

    always @(posedge clk) begin
        if (reset) begin
            iaddr <= 0;
        end else begin 
            // All program counter updates on posedge clock
            case (op)
                27 : begin if (rv1 == rv2) iaddr <= iaddr + {{20{idata[31]}},idata[7],idata[30:25],idata[11:8],1'b0};
                else iaddr <= iaddr + 4;end                                                                 //BEQ
                28 : begin if (rv1 != rv2) iaddr <= iaddr + {{20{idata[31]}},idata[7],idata[30:25],idata[11:8],1'b0};
                else iaddr <= iaddr + 4;end                                                                 //BNE
                29 : begin if ($signed(rv1) < $signed(rv2)) iaddr <= iaddr + {{20{idata[31]}},idata[7],idata[30:25],idata[11:8],1'b0};
                else iaddr <= iaddr + 4;end                                                                 //BLT
                30 : begin if ($signed(rv1) >= $signed(rv2)) iaddr <= iaddr + {{20{idata[31]}},idata[7],idata[30:25],idata[11:8],1'b0};
                else iaddr <= iaddr + 4;end                                                                 //BGE
                31 : begin if (rv1 < rv2) iaddr <= iaddr + {{20{idata[31]}},idata[7],idata[30:25],idata[11:8],1'b0};
                else iaddr <= iaddr + 4;end                                                                 //BLTU
                32 : begin if (rv1 >= rv2) iaddr <= iaddr + {{20{idata[31]}},idata[7],idata[30:25],idata[11:8],1'b0};
                else iaddr <= iaddr + 4;end                                                                 //BGEU
                33 : begin iaddr = iaddr + {{12{idata[31]}},idata[19:12],idata[20],idata[30:21],1'b0}; end  //JAL
                34 : begin iaddr = rv1 + {{20{idata[31]}},idata[31:20]}; iaddr[0] = 0;end                   //JALR
           default: iaddr <= iaddr + 4;// evaluate PC when no branching
            endcase
        end
    end

endmodule