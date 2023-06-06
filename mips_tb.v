module tb;
  
  reg clk;
  wire [31:0] out;
  reg rst;
  
  mips dut(clk,rst,out);
  
   initial begin  
           clk = 0;  
           forever #10 clk = ~clk;  
      end  
  initial begin
    rst=1;
    #12
    rst=0;
  end
    
  
  initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #1000
  $finish;
end
  
endmodule