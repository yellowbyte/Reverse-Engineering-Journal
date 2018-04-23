### <a href="Obfuscation.md"><-</a> [.anti-analysis](anti-analysis.md)[__Anti-Disassembly__] <a href="Anti-Debugging.md">-></a>

---
#### *<p align='center'> Disassembly Techniques </p>*
---
* __Linear Sweep__: disassembles one instruction at a time linearly
  * __Problem__: code section of nearly all binaries will also contain data that isn’t instructions
* __Recursive Descent__: disassembles program based on control flow
  * __Example Implementation__: for conditional branch, it will process false branch first and note to disassemble true branch later. For unconditional branch, it will add destination to the end of list of places to disassemble in future and then disassemble from that list. For call instruction, it will disassemble the bytes after the call first and then the called location. If there is conflict between the true and false branch when disassembling, it will trust the one it disassembles first
* [Binary Ninja disassembler uses both linear sweep and recursive descent to identify functions](https://binary.ninja/2017/11/06/architecture-agnostic-function-detection-in-binaries.html)

---
#### *<p align='center'> Disassembly Desynchronization </p>*
---
* __Definition__: techniques used to make disassemblers produce incorrect program listing (disassembly)
  * One popular approach to mess with disassemblers that utilize recursive descent is to take advantage of the choices that those disassemblers will make when they come across a branch instruction ([JCC](https://c9x.me/x86/html/file_module_x86_id_146.html) or [CALL](https://c9x.me/x86/html/file_module_x86_id_26.html)) to make them disassemble the wrong bytes as instructions
    * __Examples__: Opaque Predicate, Branch Functions
* __Opaque Predicate__: conditional construct that looks like conditional code but actually always evaluates to either true or false. For example, if the false branch is always processed first then the following sub-bullets will hold to cause incorrect disassembly:
  * __Jump Instructions With The Same Target__: JZ follows by JNZ. Essentially an unconditional jump. The bytes following JNZ instruction could be data but will be disassembled as code
  * __Jump Instructions With A Constant Condition__: XOR follows by JZ. It will always jump so bytes following false branch could be data but will be disassembled as code
* __Branch Functions__: CALL target modifies its own return address so that execution won't return to the instruction right after CALL. Like Opaque Predicate, the bytes following CALL could be data but will be disassembled as code
* __Impossible Disassembly__: a byte is part of multiple instructions. Disassembler cannot represent a byte as part of two instructions. Either can the processor, but it doesn't have to because it just needs to execute the instructions

---
#### *<p align='center'> Processer-Based Control Indirection </p>*
---
* __CALL Instruction Abuse__: using CALL instruction to jump to a location that is not necessary the entry point of another function. Furthermore, the return address pushed onto the stack by CALL can be discarded with the instruction "ADD ESP, 4". This will cause false disassembly since the disassembler will try label CALL destination as a function's entry point when it's not
* __Return Pointer Abuse__: RET is used to jump to function or other location instead of returning from function using the PUSH, RET sequence. Disassembler won’t show any code cross-reference to the target being jumped to. But most importantly, disassembler will prematurely terminate the function since RET is supposed to be used for returning from function, resulting in false disassembly

---
#### *<p align='center'> Parser Differential Attack (File Format Hacks) </p>*
---
* Makes modifications to an ELF executable such that it will execute fine but will cause the disassembler/debugger to not work properly. Similar techniques can be done on other executable file format like Portable Executable (PE) as well
* __ELF Header Modification__: inserting false information into ELF Header to discourage analysis
  * Simply zero-ing out information regarding section header table from the ELF Header (e_shoff, e_shentsize, e_shnum, e_shstrndx) can make tools such as readelf and Radare2 unable to display sections even though section header table still exists within the binary
  * The 6th byte of the ELF Header is EI_DATA, residing within e_ident array, which makes up the first 16 bytes of the ELF Header. EI_DATA specifies the data encoding of the processor-specific data in the file (unknown, little-endian, big-endian). Modifying EI_DATA after compilation will not affect program execution, but will make tools such as readelf, gdb, and radare2 to not work properly since those tools use this value to interpret the binary
* __ELF Section Header Table Modification__: makes tools such as gdb and objdump useless since they rely on the section header table to retrieve more detailed information regarding the executable, namely sections information, even though section header table is not needed for program execution. Segments are necessary for program execution, not sections. Section header table is only for linking and debugging
  * Modifying a section's flag field will make disassembler like IDA Pro displays incorrect disassembly listings. For example, changing .text section's flag from AX (alloc and execute) to WA (write and alloc), even though it still maps to the LOAD segment with flags RE (read and execute), will trick IDA into not disassembling main along with other local functions
  * If we include fake .init section we can trick IDA into not disassembling any of the code starting from the entry point. This can happen since IDA will try to disassemble the .init section before the entry point. But if the .init section overlaps with the entry point, then entry point will not get disassembled at all, especially when the entry point is not marked as executable in the section header (by messing with the section flag)
  * __Mixing Symbols__: appends a fake dynamic string table to the end of the binary and overwrite offset of .dynstr entry in section header table with offset of the fake dynamic string table. This will make imported functions display the fake symbol names
  * If you remove the section header table, disassembler/debugger will have to rely on program headers even though program headers give us less information. For example, .text, .rodata, and .dynsym all belong to the same segment. And without section header table, we won't be able to differentiate between the sections within a segment. But fully relying on program headers can also lead to failure. For example, another technique to make IDA fail to load an ELF file is to find a program header that is not required for loading and change the offset field to point to a location that is outside the binary

#
<strong><p align='center'><a href="Obfuscation.md">Obfuscation</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="anti-analysis.md">.anti-analysis</a>] -> <a href="Anti-Debugging.md">Anti-Debugging</a></p></strong>
