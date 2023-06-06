//address bus:8 bit
//data bus:32 bit
module PC(input [7:0] datain_pc,input clk,input rst,output reg [7:0] dataout_pc );
  
  
  always @(posedge clk )
      begin
      if(rst==1'b0)
        begin
      dataout_pc<=datain_pc;
        end
      
      else
        dataout_pc<=8'b00000000;
    end
  
endmodule

module nextPc(input [7:0] progcount,input pcsel,input [7:0] offset, output reg [7:0] nxtcount);
  
  always @(progcount,offset,pcsel)
    if(pcsel==0)
   nxtcount<=progcount+8'b00000100;
    else
      nxtcount<=progcount+8'b00000100+offset;
  
endmodule



module InstrucMem(input [7:0] addrbus, output reg [31:0] databus);
   
   reg [31:0] mem[7:0];
   
   initial 
     begin
       
    mem[0]  = 32'b00000000001000100001100000100000;  // add $1, $2, $3 
    mem[1]  = 32'b00000000010000110010000000100000;  // add $2, $3, $4 
    mem[2]  = 32'b00000000100000100010100000100000;  // add $4, $2, $5 
    mem[3]  = 32'b10001100010001100000000000000101;  // lw $6,offset($2)
    mem[4]  = 32'b00010000001000100000000000000010;  // beq $1,$2,2
    mem[5]  = 32'b00000000000000000000000000000000;  // nop
    mem[6]  = 32'b00000000001000100001100000100000;  // add $1,$2,$3
    mem[7]  = 32'b00000000010000110010000000100000;  // add $2, $3, $4 
       
     end
   
   always @(*)
     begin
       
       if(addrbus==8'b00000000)
         databus<=mem[0];
       
       else if(addrbus==8'b00000100)
         databus<=mem[1];
       
       else if(addrbus==8'b00001000)
         databus<=mem[2];
       
       else if(addrbus==8'b00001100)
         databus<=mem[3];
       
       else if(addrbus==8'b00010000)
         databus<=mem[4];
       
       else if(addrbus==8'b00010100)
         databus<=mem[5];
       
       else if(addrbus==8'b00011000)
         databus<=mem[6];
       
       else if(addrbus==8'b00011100)
         databus<=mem[7];
       
       else
          databus<=32'b0000000000000000000000000000000;
     end
       
 endmodule
       
       
       module RF( input clk, input [4:0] r1addr,input [4:0] r2addr,input [4:0]
                 rdaddr,input [31:0] wdata,output reg [31:0] rdata1,
                 output reg [31:0] rdata2,input regwrite,input reset);
       
       reg [31:0] regfile[7:0];
         
         
         
         
         always @(posedge clk or posedge reset)
           if(reset)
           begin
             regfile[0]<=32'b0;
             regfile[1]<=32'b00000000000000000000000000000010;
             regfile[2]<=32'b00000000000000000000000000000010;
             regfile[3]<=32'b0;
             regfile[4]<=32'b0;
             regfile[5]<=32'b0;
             regfile[6]<=32'b0;
             regfile[7]<=32'b0;
           end
       
       always @(posedge clk)
         begin
           if(regwrite)
             begin
             regfile[rdaddr]<=wdata;
             end
           
          end
         
             assign rdata1=regfile[r1addr];
             assign rdata2=regfile[r2addr];
       
       endmodule
       
       
module ALU(input [31:0] A,input [31:0] B, input [3:0] cntrl,output reg [31:0]                     C,output Z);
         
         assign Z = (C==0); //Z is true if C is 0; goes anywhere
         always @(cntrl, A, B) //reevaluate if these change
           case (cntrl)
                 0: C <= A & B;
                 1: C <= A | B;
                 2: C <= A + B;
                 6: C <= A - B;
                 7: C <= A < B ? 1:0;
                12: C <= ~(A | B); 
               default: C <= 0; //default to 0, should not happen;
              endcase
         
       endmodule

module ALUcontrol(input [1:0] ALUop, input [5:0] func,output reg [3:0] ALUcntrl );
  
  wire [7:0] ALUsig;
   assign ALUsig={ALUop,func};
  always @(ALUsig)
    begin
      casex(ALUsig)
        8'b10100000: ALUcntrl=4'b0010;
        8'b10100010: ALUcntrl=4'b0110;
        8'b10100100: ALUcntrl=4'b0000;
        8'b10100101: ALUcntrl=4'b0001;
        8'b10101010: ALUcntrl=4'b0111;
        8'b00xxxxxx: ALUcntrl=4'b0010;
        8'b01xxxxxx: ALUcntrl=4'b0110;
        default: ALUcntrl=4'b0000;
      endcase
    end
endmodule


module Control(input [5:0] ins, output reg [1:0] op,output reg regwrite,output reg regdst,output reg ALUsrc,output reg memwrite,output reg memread,output reg memtoreg,output reg branch);
  
   
  always @(*)
    begin
      case(ins)
       
          6'b000000:begin  //add
                    op=2'b10;
                    regwrite =1'b1;
                   regdst=1'b1;
                   ALUsrc=1'b0;
                   memread=1'b0;
                   memwrite=1'b0;
                   memtoreg=1'b0;
                   branch=1'b0;
          end
          
       
        6'b100011:begin    //lw
                   op=2'b00;
                 regwrite=1'b1;
                 regdst =1'b0;
                 ALUsrc=1'b1;
                 memread=1'b1;
                  memwrite=1'b0;
                  memtoreg=1'b1;
                  branch=1'b0;
        end
        
        6'b101011:begin    //sw
                 op=2'b00;
                 regwrite=1'b0;
                 regdst =1'bx;
                 ALUsrc=1'b1;
                 memread=1'b0;
                memwrite=1'b1;
                memtoreg=1'bx;
                branch=1'b0;
        end
        
        
        6'b000100:begin //beq
                 op=2'b01;
                 regwrite=1'b0;
                 regdst =1'bx;
                 ALUsrc=1'b0;
                 memread=1'b0;
                memwrite=1'b0;
                memtoreg=1'bx;
                 branch=1'b1;
        end
               
        endcase    
    end
           
endmodule
  
  
module mux(sel, in0, in1, out);
  input sel;
  input [31:0] in0, in1;
  output reg [31:0] out;

	always @(sel, in0, in1)
		if (sel == 0)
			out <= in0;
		else
			out <= in1;	  
endmodule
        
      module signex(input [15:0] in, output [31:0] out);
          assign out[15:0]=in[15:0];
          assign out[31:16]={16{in[15]}};
          
        endmodule
 
  
module datamem( input clk,input [31:0] datadd, input [31:0] wridata,input memwrite,input memread,output reg [31:0] datamem);
  
  
  integer i;
  reg [31:0] memory[4095:0];
  wire [11 : 0] mem_addr = datadd[11 : 0];  
  
  initial begin  
    for(i=0;i<4096;i=i+1)  
      memory[i] <= 32'b0;  
      end 
  
  initial begin
    memory[7]<=32'b00000000000000000000000000000011;
  end
  
  always @(posedge clk) 
    begin  
           if (memwrite)  
             memory[mem_addr] <= wridata;  
      end  
  assign datamem = (memread==1'b1) ? memory[mem_addr]: 32'b0;   
 endmodule   
  
  
  
  
  
       
       
       












module mips(input clk,input rst,output [31:0] out);
       
         wire [7:0] pc;
         reg [7:0] pc_next;
         wire [31:0] instruct;
         wire [31:0] rsdata,rtdata;
         wire [1:0] op  ;        
         wire regwrite,zero,regdst,ALUsrc,mem_write,mem_read,mem_reg,brnch;
         wire [3:0] control;
         wire [4:0] destaddr;
         wire [31:0] constant,aluinp,mem_read_data;
  wire [31:0] writedata;
  wire pcsel;
         
         
  PC progcount(pc_next,clk,rst,pc);
  nextPc P(pc,pcsel,instruct[7:0]<<2,pc_next);
         InstrucMem Im(pc,instruct);
  Control cnt(instruct[31:26],op,regwrite,regdst,ALUsrc,mem_write,mem_read,mem_reg,brnch);
  
  
  mux m1(regdst,instruct[20:16],instruct[15:11],destaddr);
  
  RF reg_file(clk,instruct[25:21],instruct[20:16],destaddr,writedata,
                     rsdata,rtdata,regwrite,rst);
  
  ALUcontrol alcnt(op,instruct[5:0],control);
  
  signex s1(instruct[15:0],constant);
  
  mux m2(ALUsrc,rtdata,constant,aluinp);
         
  ALU al(rsdata,aluinp,control,out,zero);
  
assign pcsel=brnch & zero;
  
  datamem dat(clk,out,rtdata,mem_write,mem_read,mem_read_data);
  
  mux m3(mem_reg,out,mem_read_data,writedata);
         
       endmodule
                   