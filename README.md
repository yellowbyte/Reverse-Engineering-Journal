# Reverse_Engineering_Journal
I put anything I find interesting regarding reverse engineering in this journal. The date beside each heading denotes the start date that I added the topic, but most of the time I will still be adding bullets to that heading days later. 

### Table of Contents 
* [General Knowledge](#121816-general-knowledge)
* [12/24/16 ([HARD TO REMEMBER] x86 Instructions With Side Effects)](#12/24/16 ([HARD TO REMEMBER] x86 Instructions With Side Effects))
* [11/17/16 (Anti-Disassembly)](#11/17/16 (Anti-Disassembly))
* [11/17/16 (Anti-Debugging)](#11/17/16 (Anti-Debugging))
* [12/5/16 (Breakpoints)](#12/5/16 (Breakpoints))
* [12/12/16 (String Encoding)](#12/12/16 (String Encoding))
* [12/13/16 (C++ Reversing)](#12/13/16 (C++ Reversing))
* [12/14/16 (64-Bit)](#12/14/16 (64-Bit))
* [12/15/16 (Data Encoding)](#12/15/16 (Data Encoding))
* [12/15/16 (Base64)](#12/15/16 (Base64))

#### *12/18/16 General Knowledge*
* A hash function is a mathematical process that takes in an arbitrary-sized input and produces a fixed-size result
* First argument to __libc_start_main() is a pointer to main for ELF files
* nm: displays symbols in binary 
* ldd: print shared library dependencies
* To look at instructions starting from pc for stripped binary in gdb: x/14i $pc
* Set hardware breakpoint in GDB: hbreak 
* Set watchpoint in GDB: watch only break on write, rwatch break on read, awatch break on read/write
* Thunk function: simple function that jumps to another function
* ASLR is turned off by default in GDB. To turn it on: set disable-randomization off
* (32 bits Windows exe) FS register points to the beginning of current thread's environment block (TEB). Offset zero in TEB is the head of a linked list of pointers to exception handler functions
* Any function that calls another function is called a non-leaf function, and all other functions are leaf functions

#### *12/24/16 ([HARD TO REMEMBER] x86 Instructions With Side Effects)*
* IMUL reg/mem: register is multiplied with AL, AX, or EAX and the result is stored in AX, DX:AX, or EDX:EAX
* IDIV reg/mem: takes one parameter (divisor). Depending on the divisor’s size, div will use either AX, DX:AX, or EDX:EAX as the dividend, and the resulting quotient/remainder pair are stored in AL/AH, AX/DX, or EAX/EDX
* STOS: writes the value AL/AX/EAX to EDI. Commonly used to initialize a buffer to a constant value
* SCAS: compares AL/AX/EAX with data starting at the memory address EDI
* CLD: clear direction flag
* STD: set direction flag
* REP prefix: repeats an instruction up to ECX times
* MOVSB/MOVSW/MOVSD instructions move data with 1, 2, or 4 byte granularity between two addresses. They implicitly use EDI/ESI as the destination/source address, respectively. In addition, they also automatically update the source/destination address depending on the direction flag

#### *11/17/16 (Anti-Disassembly)*
* __Linear disassembly__: disassembling one instruction at a time linearly. Problem: code section of nearly all binaries will also contain data that isn’t instructions 
* __Flow-oriented disassembly__: process false branch first and note to disassemble true branch in future. When it reaches a unconditional jump, it will add the dest to list of places to disassemble in future. It will then step back and disassemble from the list of places it noted previously. For call instruction, most will disassemble the bytes after the call first and then the called location. If there is conflict between the true and false branch when disassembling, disassembler will trust the one it disassembles first
* Use inline functions to obscure function declaration
* __Disassembly Desynchronization__: to cause disassembly analysis tools to produce an incorrect program listing. Works by taking advantage of the assumptions and limitations of disassemblers. Desynchronization had the greatest impact on the disassembly, but it was easily defeated by reformatting the disassembly to reflect the correct instruction flow
  + __Jump instructions with the same target__: jz follows by jnz. Essentially an unconditional jump. The bytes following jnz instruction could be data but will be disassembled as code
  + __Jump instructions with a constant condition__: xor follows by jz. It will always jump so bytes following false branch could be data
  + __Impossible disassembly__: A byte is part of multiple instructions. No disassembler will represent a byte as part of two instructions, but the processor has no such limitation
* __Opcode Obfuscation__: a more effective technique for preventing correct disassembly by encoding or encrypting the actual instructions
  + Encoding portions of a program has the dual effect of hindering static analysis because disassembly is not possible and of hindering debugging because placing breakpoints is difficult. Even if the start of each instructions is known, breakpoints cannot be placed until instructions have been decoded
  + Virtual obfuscation
* __Function pointer problem__: if a function call func using the same ptr multiple times, ida pro xref only record the first usage
* __Return pointer abuse__: ret instruction is used to jump to function instead of returning from function. Disassembler doesn’t show any code cross-reference to the target being jumped to. Also, disassembler will prematurely terminate the function
* __Thwarting stack-frame analysis__: technique to mess ida pro when deducing numbers of param and local variables. Make a conditional jump that always false but in true branch add absurd amount to esp
* __Dynamically Computed Target Addresses__: an address to which execution will flow is computed at runtime. The intent is to hide control flow from static analysis
* More complex control flow hiding: program uses multiple threads or child processes to compute control flow information and receive that information via interprocess communication (for child processes) or synchronization primitives (for multiple threads)
* __Imported Function Obfuscation (makes it difficult to determine which shared lib or lib func are used)__: have the program’s import table to have been properly initialized by the program itself. The program itself loads any additional lib it depends on, and once the lib are loaded, the program locates any required functions within those lib
  + (Windows) use LoadLibrary function to load required lib by name and then perform function address lookups within each lib using the GetProcAddress func
* Tip-offs that a binary is obfuscated:
  + Very little code is highlighted in the navigation band
  + Very few functions are listed in Functions window. Often only the start function
  + Very few imported functions in the Imports window
  + Very few legible strings appear in Strings window
  + One or more program sections will be both writable and executable (Segments Window)
  + Nonstandard section names such as UPXo or .shrink are used

#### *11/17/16 (Anti-Debugging)*
* For Linux Only: This is an elegant technique to detect if a debugger or program tracer such as strace or ltrace is being used on the target program. The premise of this technique is that a ptrace[PTRACE_TRACEME] cannot be called in succession more than once for a process. All debuggers and program tracers use this call to setup debugging for a process
* Self-Debugging (Window’s version of ptrace): main process spawns a child process that debugs the process that created the child process. This can be bypassed be setting the EPROCESS->DebugPort (the EPROCESS structure is a struct returned by the kernel mode function PsGetProcessId) field to 0
* Windows API provides several functions that can be used by a program to determine if it is being debugged (e.g. isDebuggerPresent)
* Several flags within the PEB structure provide information about the presence of a debugger
* Location of PEB can be referenced by the location fs:[30h]. The second item on the PEB struct is BYTE BeingDebugged
* __ProcessHeap Flag__: within Reserved4 array in PEB, is ProcessHeap, which is set to location of process’s first heap allocated by loader. This first heap contains a header with fields that tell kernel whether the heap was created within a debugger, known as ForceFlags fields
* __NTGlobalFlag__: Since processes run slightly differently when started with a debugger, they create memory heaps differently. The information that the system uses to determine how to create heap structures is stored at an undocumented location in the PEB at offset 0x68. If value at this location is 0x70, we know that we are running in debugger
* __INT Scanning__: INT 3 (0xCC) is software interrupt used by debuggers to temporarily replace an instruction in a running program and to call the debug exception handler if the process is being traced (e.g. ptrace)- how debugger make software breakpoint. Have a process scan its own code for an INT 3 modification by searching the code for the oxCC opcode
* __Setting up false breakpoints__: a breakpoint is created by overwriting the address with an int3 opcode (0xcc). To setup a false breakpoint then we simply insert an int3 into the code. This also raises a SIGTRAP, and thus if our code has a signal handler we can continue processing after the breakpoint
* __Code Checksums__:  Instead of scanning for 0xCC, this check simply performs a cyclic redundancy check (CRC) or a MD5 checksum of the opcodes in the malware
* __Timing Checks__:  record a timestamp, perform some operations, take another timestamp, and then compare the two timestamps. If there is a lag, you can assume the presence of a debugger
* __rdtsc Instruction (0x0F31)__: this instruction returns the count of the number of ticks since the last system reboot as a 64-bit value placed into EDX:EAX. Simply execute this instruction twice and compare the difference between the two readings
* __TLS Callbacks__: Most debuggers start at the program’s entry point as defined by the PE header. A TLS callback can be used to execute code before the entry point and therefore execute secretly in a debugger. TLS is a Windows storage class in which a data object is not an automatic stack variable, yet is local to each thread that runs the code. Basically, TLS allows each thread to maintain a different value for a variable declared using TLS. TLS callback functions were designed to initialize and clear TLS data objects
* Clearing hardware breakpoints

#### *12/5/16 (Breakpoints)*
* Software breakpoint: debugger read and store the first byte and then overwrite the first byte with 0xcc (int 3). When CPU hits the breakpoint, SIGTRAP signal is raised, process is stopped, and internal lookup occurs and the byte is flipped back
* Hardware breakpoints are set at CPU level, in special registers called debug registers (DR0 through DR7)
* Only DR0 - DR3 registers are reserved for breakpoint addresses
* Before the CPU attempts to execute an instruction, it first checks to see whether the address is currently enabled for a hardware breakpoint. If the address is stored in debug registers DR0–DR3 and the read, write, or execute conditions are met, an INT1 is fired and the CPU halts
* Can check if someone sets a hardware breakpoint by using GetThreadContext() and checks if DR0-DR3 is set
* When a debugger is setting a memory breakpoint, it is changing the permissions on a region, or page, of memory
* Guard page: Any access to a guard page results in a one-time exception, and then the page returns to its original status. Memory breakpoint changes permission of the page to guard

#### *12/12/16 (String Encoding)*
* There are only 128 characters defined in ASCII and 95 of them are human-readable
* ASCII only used 7 bits, but the extra bit is still not enough to encode all the other languages
* Various encoding schemes were invented but none covered every languages until Unicode came along
* Unicode is a large table mapping characters to numbers (or a table of code points for characters) and the different UTF encodings specify how these numbers are encoded as bits
* Characters are referred to by their “Unicode code point”
* The primary cause of garbled text is: Somebody is trying to read a byte sequence using the wrong encoding
* All characters available in the ASCII encoding only take up a single byte in UTF-8 and they're the exact same bytes as are used in ASCII. In other words, ASCII maps 1:1 unto UTF-8. Any character not in ASCII takes up two or more bytes in UTF-8

#### *12/13/16 (C++ Reversing)*
* Ecx is used to stored the this pointer. Sometimes esi
* Class member functions are called with the usual function parameters in the stack and with ecx pointing to the class’s object 
* Class’s object in assembly only contains the vfptr (pointer to virtual functions table) and variables. Member functions are not part of it
* Memory spaces for global objects are allocated at compile-time and placed in data segment of binary 
* Use Name Mangling to support Method Overloading (multiple functions with same name but accept different parameters) since in PE format function is only labeled with its name 
* Child class automatically has all functions and data from parent class
* Execution for virtual function is determined at runtime. Function call is indirect (through a register)

#### *12/14/16 (64-Bit)*
* All addresses and pointers are 64 bits
* All general-purpose registers have increased in size, tho 32-bit versions can still be accessed
* Some general-purpose registers (RDI, RSI, RBP, and RSP) supports byte accesses
* There are twice as many general-purpose registers. The new one are labeled R8 - R15
* DWORD (32-bit) version can be accessed as R8D. WORD (16-bit) version are accessed with a W suffix like R8W. Byte version are accessed with an L suffix like R8L
* Supports instruction pointer-relative addressing. Unlike x86, referencing data will not use absolute address but rather an offset from RIP
* Calling conventions: first 4 parameters are placed in RCX, RDX, R8, and R9. Additional one are stored on stack
* In 32-bit code, stack space can be allocated and unallocated in middle of the function using push or pop. However, in 64-bit code, functions cannot allocate any space in the middle of the function
* Nonleaf functions are sometimes called frame functions because they require a stack frame. All nonleaf functions are required to allocate 0x20 bytes of stack space when they call a function. This allows the function being called to save the register parameters (RCX, RDX, R8, and R9) in that space. If a function has any local stack variables, it will allocate space for them in addition to the 0x20 bytes
* Structured exception handling in x64 does not use the stack. In 32-bit code, the fs:[0] is used as a pointer to the current exception handler frame, which is stored on the stack so that each function can define its own exception handler
* Easier in 64-bit code to differentiate between pointers and data values. The most common size for storing integers is 32 bits and pointers are always 64 bits

#### *12/15/16 (Data Encoding)*
* All forms of content modification for the purpose of hiding intent
* Caesar cipher: formed by shifting the letters of alphabet #’s characters to the left or right
* Single-byte XOR encoding: modifies each byte of plaintext by performing a logical XOR operation with a static byte value
* Problem with Single-byte XOR is that if there are many null bytes then key will be easy to figure out since XOR-ing nulls with the key reveals the key. Solutions: 
  + Null-preserving single-byte XOR encoding: if plaintext is NULL or key itself, then it will not be encoded via XOR
  + Blum Blum Shub pseudo-random number generator: Produces a key stream which will be xor-ed with the data. Generic form: Value = (Value * Value) % M. M is a constant and an initial V needs to be given. Actual key being xor-ed with the data is the lowest byte of current PRNG value
* Identifying XOR loop: looks for a small loop that contains the XOR function (where it is xor-ing a register and a constant or a register with another register)
* Other Simple Encoding Scheme:
  + ADD, SUB
  + ROL, ROR: Instructions rotate the bits within a byte right or left
  + Multibyte: XOR key is multibyte
  + Chained or loopback: Use content itself as part of the key. EX: the original key is applied at one side of the plaintext, and the encoded output character is used as the key for the next characte
* If outputs are suspected of containing encoded data, then the encoding function will occur prior to the output. Conversely, decoding will occur after an input

#### *12/15/16 (Base64)*
* Used to represent binary data in ASCII string format
* It converts binary data into a limited character set of 64 characters
* Most common character set is MIME’s Base64, which uses A-Z, a-z, and 0-9 for the first 62 values and + / for the last two
* Bits are read in blocks of six. The number represented by the 6 bits is used as an index into a 64-byte long string
* One padding character may be presented at the end of the encoded string (typically =). If padded, length of encoded string will be divisible by 4
* One beautiful thing about Base64 is how easy it is to develop a custom substitution cipher since the only item that needs to be changed is the indexing string

#### *12/16/16 (Stripped Binaries)*
* nm command to list all symbols in the binary
* With non-stripped, gdb can identify local function names and knows the bounds of all functions so we can do: disas "function name"
* With stripped binary, gdb can’t even identify main. Can identify entry point using the command: info file. Also, can’t do disas since gdb does not know the bounds of the functions so it does not know which address range should be disassembled. Solution: use examine(x) command on address pointed by pc register like: x/14i $pc

#### *12/16/16 (LD_PRELOAD)*
* When you start a dynamically linked program, it doesn’t have all the code for the functions it needs. So this is what happened: 
  + The program gets loaded into memory
  + The dynamic linker figures out which other libraries that program needs to run (.so files)
  + It loads them into memory 
  + It connects everything up 
* LD_PRELOAD is an environment variable that says “whenever you look for a function name, look in me first”

#### *12/17/16 (Random Number Generator)*
* Randomness requires a source of entropy, which is a sequence of bits that is unpredictable. This source of entropy can be from OS observing this internal operations or ambient factors
* Suppose the first input to our algorithm came from a legitimate source of entropy, such as the ones described in the previous section; we'll call this value the seed. Now suppose that our algorithm was designed in such a way that it generated a sequence that had the following properties:
  + At each step, our seed value is used as input to a calculation. The result of that calculation is returned from our algorithm and it becomes our new seed value, so that it becomes the input to our next calculation
  + If the algorithm is used to generate a long sequence of values, that sequence will satisfy statistical tests of randomness (i.e., it will demonstrably "appear" to be random) and will have a long periodicity (i.e., it will be a long time before the sequence begins to repeat)
* Such algorithms are known as pseudorandom generators, because while their output isn't random, it nonetheless passes statistical tests of randomness. As long as you seed them with a legitimate source of entropy, they can generate fairly long sequences of random values without the sequence repeating

#### *12/28/16 (Useful Python for RCE)*
* chr: hex/int to ASCII
* ord: ASCII to hex
* Struct module: pack python objects as contiguous chunk of bytes or disassemble a chunk of bytes to python structures
* int.from_bytes(bytes, byteorder): return integer represented by the array of bytes
* int.to_bytes(bytes, byteorder): return array of bytes representing an integer
* hex() returns a string
* bytes is an immutable sequence of bytes. bytearray is mutable
