### <a href="x86-64.md"><-</a> [.instruction-sets](instruction-sets.md)[__ARM__] <a href="/contents/languages/C++_Reversing.md">-></a>

---
#### *<p align='center'> ARM Version </p>*
---
* ARMv7 uses 3 profiles (Application, Real-Time, Microcontroller) and model name (Cortex). For example, ARMv7 Cortex-M is meant for microcontroller and support Thumb-2 execution only
* Thumb-1 is used in ARMv6 and earlier. Its instructions are always 2 bytes in size
* Thumb-2 is used in ARMv7. Its instructions can be either 2 bytes or 4 bytes in size. 4 bytes Thumb instruction has a .W suffix, otherwise it generates a 2 byte Thumb instruction
* Native ARM instructions are always 4 bytes in size

---
#### *<p align='center'> Privileges Separation </p>*
---
* It is defined by 8 modes. In comparison to x86, User (USR) mode is like ring3 and Supervisor (SVC) mode is like ring0

---
#### *<p align='center'> Registers </p>*
---
* There are 16 32-bit general-purpose registers (R0 - R15), but only the first 12 registers are for general purpose usage
  * R0 holds the return value from function call
  * R13 is the stack pointer (SP)
  * R14 is the link register (LR), which holds return address for function call
  * R15 is the program counter (PC)
* Control register is the current program status register (CPSR), also known as application program status register (APSR), which is basically an extended EFLAGS register in x86

---
#### *<p align='center'> Load/Store Instructions </p>*
---
* Only load/store instructions can access memory. All other instructions operate on registers
* load/store instructions: LDR/STR, LDM/STM, and PUSH/POP
* __LDR/STR's Form__: there are 4 forms of LDR/STR instructions
  * LDR/STR Ra, [Rb]. LDR loads the data at Rb to Ra. STR stores Ra to the location pointed to by Rb
  * LDR/STR Ra, [Rb, imm]
  * LDR/STR Ra, [Rb, Rc]
  * LDR/STR Ra, [Rb, Rc, barrel-shifter]. Barrel shifter is performed on Rc. The result is added to Rb, the base address
  * extra (pseudo-form): LDR Ra, ="address". This is not valid syntax, but is used by disassembler to make disassembly easier to read. Internally, what's actually executed is LDR Ra, [PC + imm]
* __LDR/STR's Addressing Mode__: offset, pre-indexed, post-indexed
  * __Offset__: base register is never modified
      * Form: LDR Rd, [Rn, offset]
    * __Pre-indexed__: base register is updated with the memory address used in the reference operation
      * Form: LDR Rd, [Rn, offset]!
    * __Post-indexed__: base register is used as the address to reference from and then updated with the offset
      * Form: LDR Rd, [Rn], offset
* __LDM/STM's Form__: there are 2 forms of LDM/STM instructions
  * LDM Form: LDM<-mode-> Rb [!], {Registers}. LDM means load the data starting from Rb and loads it into Registers
  * STM Form: STM<-mode-> Rb [!], {Registers}. STM means store the data in Registers into location starting from Rb
    * Exclamation mark (!) means Rb should be updated to the final location after the LDM/STM operation
  * It loads/stores multiple words (32-bits), starting from a base address
* __LDM/STM's Stack Usage__:
  * Descending or ascending: descending means that the stack grows downward, from higher address to lower address. Ascending means that the stack grows upward
  * Full or empty: full means that the stack pointer points to the last item in the stack. Empty means that the stack pointer points to the next free space
  * Full descending: STMFD (STMDB), LDMFD (LDMIA)
  * Full ascending: STMFA (STMIB), LDMFA (LDMDA)
  * Empty descending: STMED (STMDA), LDMED (LDMIB)
  * Empty ascending: STMEA (STMIA), LDMEA (LDMDB)
* __PUSH/POP's Form__: PUSH/POP {register(s)}
  * PUSH/POP and STMFD/LDMFD are functionally the same, but PUSH/POP is used as prologue and epilogue in Thumb state while STMFD/LDMFD is used as prologue and epilogue in ARM state.

---
#### *<p align='center'> Instructions For Function Invocation </p>*
---
* They are B, BX, BL, and BLX
* B's syntax: B imm. imm is relative offset from R15, the program counter
* BX's syntax: BX &lt;register&gt;. X means that it can switch between ARM and THUMB state. If the LSB of the destination is 1, it will execute in Thumb state. BX LR is commonly used to return from function
* BL's syntax: BL imm. It stores return address, the next instruction, in LR before transferring control to destination. To return from function, B LR is used
* BLX's syntax: BLX imm./&lt;register&gt;. When BLX uses an offset, it always swap state (ARM to THUMB or THUMB to ARM)

---
#### *<p align='center'> Conditional Execution </p>*
---
* Instructions can be conditionally executed by adding conditional suffixes
* This is how conditional branch instruction is implemented. For example, BEQ executes Branch instruction if EQ condition is true (ZF = 1)
* Thumb instruction cannot be conditionally executed, with the exception of B instruction, without the IT instruction.
  * IT (If-then)'s syntax: ITxyz cc. cc is the conditional suffix for the 1st instruction after IT. xyz are for the 2nd, 3rd, and 4th instructions after IT. It can be either T or E. T means that the condition must match cc for it to be executed. E means that condition must be the opposite of cc for it to be executed
* For arithmetic operations, the "S" suffix will update conditional flags. Whereas, comparison instructions (CBZ, CMP, TST, CMN, and TEQ) automatically update the flags

---
#### *<p align='center'> Importance of Barrel Shifter </p>*
---
* Since instructions can only be 2 or 4 bytes in size, it's not possible to directly use a 32-bit constant as an operand. As a result, barrel shifter can be used to transform the immediate into a larger value

#
<strong><p align='center'><a href="x86-64.md">x86-64</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="instruction-sets.md">.instruction-sets</a>] -> <a href="/contents/languages/C++_Reversing.md">C++ Reversing</a></p></strong>
