# 32-bit-single-cycle-MIPS-processor


In this project we are building a single cycle MIPS processor capable of executing instructions like add,sub,and,or ,slt , lw, sw and beq.

**The datapath**


![image](https://github.com/Gaurav138-Nan/32-bit-single-cycle-MIPS-processor/assets/75901646/4b876b78-7264-4fe2-9c44-8eb7a7eb8610)


















The above datapath consists of roughly the below mentioned components:
•	Program Counter <br/>
•	Instruction Memory<br/>
•	Register File<br/>
•	ALU<br/>
•	Data Memory<br/>
•	Other side components like MUX, adder, sign extender etc.<br/>




**Working Principle**

The normal procedure involves the starting the program counter from 0 and it is incremented by 4 on every clock cycle. The value of program counter is used as a input to the instruction memory to access the instruction stored at that location. Now depending on format of instruction(R or I)  implemented, the various fields of the instruction will be used to decide the control signals and register access location in the register file. The data value obtained from the register file will be acted upon by the ALU whose action depends on the ALU control signals dictated by the opcode field of the instruction being implemented. Finally, depending on the instruction the value obtained at the output will either be stored in the register file or will be used in data memory. 


**Observation(Waveform):**

First of the set of instructions that we are implementing are:
1.	add $1, $2, $3  //initially value of 2 was stored in both register 1 and 2.
2.	add $2, $3, $4 
3.	add $4, $2, $5 
4.	lw $6,offset($2) // offset value was set at 5
5.	beq $1,$2,2
6.	nop
7.	add $1,$2,$3
8.	add $2, $3, $4 

Here $1 represents register number 1.
       

![image](https://github.com/Gaurav138-Nan/32-bit-single-cycle-MIPS-processor/assets/75901646/6cf5cde6-ebee-46c9-8107-da61b6c71ce4)










As we can observe from the out port in the above graph that the processor is working correctly.
