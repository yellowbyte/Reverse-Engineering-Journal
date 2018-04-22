### <a href="/contents/languages/Python_Reversing.md"><-</a> [.file-formats](file-formats.md)[__ELF Files__] <a href="PE_Files.md">-></a>

---
#### *<p align='center'> Overview </p>*
---
<div align='center'> 
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/file-formats/ELF_Files/elf_file_format.png" height="400"> 
<p align='center'><sub><strong>ELF file format overview</strong></sub></p>
</div>

---
#### *<p align='center'> Linking VS Execution </p>*
---
<div align='center'> 
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/file-formats/ELF_Files/loading_elf_file.png" height="400"> 
<p align='center'><sub><strong>linking vs execution view</strong></sub></p>
</div>

---
#### *<p align='center'> ELF File Header </p>*
---
* Starts at offset 0 and is the roadmap that describes the rest of the file. It marks the ELF type, architecture, execution entry point, and offsets to program headers and section headers

---
#### *<p align='center'> Program Header Table </p>*
---
* Let the system knows how to create the process image. It contains an array of structures, each describing a segment. A segment contains one or more sections

---
#### *<p align='center'> Section Header Table </p>*
---
* Is not necessary for program execution. It is mainly for linking and debugging purposes. It is an array of __ELF_32Shdr__ or __ELF_64Shdr__ structures (Section Header)
* __Notable Sections:__
  * __.got (Global Offset Table)__: a table of addresses located in the data section. It allows PIC (Position Independent) code to reference data that were not available during compilation (ex: extern "var"). That data will have a section in .got, which will then be filled in later by the dynamic linker
  * __.plt (Procedure Linkage Table)__: contains within the text segment, consisting of external function entries. Each plt entry has a correcponding entry in .got.plt which contains the actual offset to the function
    * plt entry consists of: 
      * A jump to an address specified in GOT
      * argument to tell the resolver which function to resolve (only reach there during function's first invocation)
      * call the resolver (resides at PLT entry 0)
  * __.got.plt__: contains dynamically-linked function entries that can be resolved lazily through lazy binding. This means that it doesn't resolve the address until the function is called

---
#### *<p align='center'> Useful Compilation Options To Know For GCC </p>*
---
* __-g__: the compiled binary will contain extra sections with names that start with ".debug\_". The most important one of the .debug\_* sections is .debug_info. It tells you the path of the source file, path of the compilation directory, version of C used, and the line numbers where variables are declared in source code. It will also contain the parameter names for local functions
* __-s__: the compiled binary will not contain symbol table and relocation information. This means that the .symtab will be stripped away, which contains references to variable and local function names
* __-O3__: the second highest optimization level. The optimizations that it applied will actually result in bigger overall file size than the compiled version of the unoptimized binary
* __-funroll-loops__: unroll the looping structure of any loops, making it harder for reverse engineer to analyze the compiled binary

---
#### *<p align='center'> Stripped Binary </p>*
---
* There are 2 sections that contain symbols: .dynsym and .symtab. .dynsym contains dynamic/global symbols; those symbols are resolved at runtime. .symtab contains all the symbols
* __nm command__ to list all symbols in the binary from .symtab
* Stripped binary == no .symtab symbol table
* .dynsym symbol table cannot be stripped since it is needed for runtime, so imported library functions' symbols remain in a stripped binary. But if a binary is compiled only with statically-linked libraries, it will contain no symbol table at all if stripped
* The address and size of all local functions can be identified in .symtab

<div align='center'> 
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/file-formats/ELF_Files/func_and_size.png" width="70%" height="70%"> 
<p align='center'><sub><strong>running `readelf -s &lt;binary&gt; | grep -e "main" -e "Num:"` shows that function main starts at 0x400526 with the size of 42 bytes</strong></sub></p>
</div>

* With non-stripped binary, gdb can identify local function names and knows their bounds because of .symtab so we can do this: __disas &lt;function name&gt;__
* With stripped binary, gdb can’t even identify main. We can still try to identify main from the entry point using the command: __info file__. Also, can’t use disas since gdb does not know the bounds of a functions so it does not know which address range should be disassembled. Solution: use examine(x) command on address pointed by program counter: __x/14i $pc__

---
#### *<p align='center'> Useful Tools To Analyze ELF Executable </p>*
---
* display section headers: __readelf -S &lt;file&gt;__
* display program headers and section to segment mapping: __readelf -l &lt;file&gt;__
* display symbols: __readelf --syms &lt;file&gt;__ or __objdump -t &lt;file&gt;__ or __nm &lt;file&gt;__
* display a section's content: __objdump -s -j &lt;section name&gt; &lt;file&gt;__
* display shared objects dependency: __ldd &lt;file&gt;__
* trace library call: __ltrace -f &lt;file&gt;__
* trace system call: __strace -f &lt;file&gt;__
* decompile: check out __[RetDec](https://retdec.com/)__
* view a running program's process address space: __/proc/$pid/maps__

#
<strong><p align='center'><a href="/contents/languages/Python_Reversing.md">Python Reversing</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="languages.md">.file-formats</a>] -> <a href="PE_Files.md">PE Files</a></p></strong>
