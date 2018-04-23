###  <a href="IDA_Tips.md"><-</a> [.tools](tools.md)[__GDB Tips__] <a href="/contents/instruction-sets/x86.md">-></a>

---
#### *<p align='center'> Changing Default Settings </p>*
---
* To make changes permanent, write it in the .gdbinit file
* ASLR is turned off by default in GDB. To turn it on: __set disable-randomization off__
* Default displays assembly in AT&T notation. To display assembly in Intel notation: __set disassembly-flavor intel__

---
#### *<p align='center'> User Inputs </p>*
---
* How to pass user inputs to debugged program as arguments or/and as stdin:
  * After starting GDB...
      ```gdb
      (gdb) run argument1 argument2 < file
      ```
  * content of file will be passed to debugged program's stdin

---
#### *<p align='center'> Automation </p>*
---
* __-x Option__: puts the list of commands you want GDB to run when GDB starts in a file and run GDB with the -x option
    ```bash
    gdb -x command_file program_to_debug
    ```
* __Hooks__: user-defined command. When command ? is ran, user-defined command 'hook-?' will be executed (if it exists)
  * When reversing, it could be useful to hook on breakpoints by using hook-stop
  * How to define a hook:
     ```gdb
     (gdb) define hook-?
     > ...commands...
     > end
     (gdb)
     ```
* __display &lt;arg&gt;__: display content of &lt;arg&gt; everytime GDB stops (either due to single-stepping or breakpoints). &lt;arg&gt; can be either a convenience variable, memory location, or register

---
#### *<p align='center'> Ways To Pause Debuggee </p>*
---
* __Software Breakpoint__:
  ```bash
  (gdb) break *0x8048479
  ```
  * __shortcut__: if the instruction pointer is at the address that you wanted to break at, simply type b or break and a breakpoint will be set there
* __Hardware Breakpoint__:
  ```bash
  (gdb) hbreak *0x8048479
  ```
* __Watchpoint__:
  ```bash
  (gdb) watch *0x8048560  #break on write
  (gdb) rwatch *0x8048560 #break on read
  (gdb) awatch *0x8048560 #break on read/write
  ```
* __Catchpoint__:
  ```bash
  (gdb) catch syscall #break at every call/return from a system call
  ```

---
#### *<p align='center'> Useful Commands </p>*
---
* __apropos &lt;arg&gt;__ command searches through all GDB commands/documentations for &lt;arg&gt; and displays matched command/documentation pairs
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/GDB_Tips/apropos_ex.png" width="600">
<p align='center'><sub><strong>GDB output from 'apropos mapping'</strong></sub></p>
</div>

* __i (info)__ command displays information on the item specified to the right of it
  * __i proc mappings__: shows mapped address spaces
  * __i b__: shows all breakpoints
  * __i r__: shows the values in general purpose, flag, and segment registers at that point of execution
  * __i all r__: shows the values in all registers at that point of execution, such as FPU and XMM registers
* __x (examine)__ command displays memory contents at a given address in the specified format
  * Since disas command won't work on stripped binary, x command can come in handy to display instructions from current program counter: __x/14i $pc__
* __set__ command can be used to set convenience variable, change value in memory, or change value in register : __set $&lt;name&gt; = &lt;value&gt;__
  * From user code, one can't directly access the instruction pointer; instruction pointer can only be edited through JMP, CALL, or RET. It's a different story when the program is under GDB though. Instruction pointer can be easily changed using the set command: __set $eip = &lt;address&gt;__
  * It is useful to be able to change a flag in FLAGS/EFLAGS/RFLAGS (status register) to see how taking the unintended branch for a [JCC](https://c9x.me/x86/html/file_module_x86_id_146.html) instruction will affect later program behavior. To update a flag, you just need to know the bit position of the flag you wanted to change
    * To set the zero flag:
      ```bash
      (gdb) set $ZF = 6                #bit position 6 in EFLAGS is zero flag
      (gdb) set $eflags |= (1 << $ZF)  #use that variable to set the zero flag bit
      ```
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/GDB_Tips/eflags.png" width="600" height="120">
<p align='center'><sub><strong>each available flag and its corresponding bit position in the EFLAGS register</strong></sub></p>
</div>

* __call__ command allows one to call any function (local or library functions) in the debuggee's address space and see the return value of that function. The argument to call command can be symbol for a function or in the case of a stripped local function, an address

#
<strong><p align='center'><a href="IDA_Tips.md">IDA_Tips</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="tools.md">.tools</a>] -> <a href="/contents/instruction-sets/x86.md">x86</a></p></strong>
