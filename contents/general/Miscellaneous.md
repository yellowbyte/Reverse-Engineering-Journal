### <a href="/contents/encodings/Data_Encoding.md"><-</a> [.general](general.md)[__Miscellaneous__] <a href="/contents/tools/IDA_Tips.md">-></a>

---
#### *<p align='center'> Threads </p>*
---
* A process is a container for execution. A thread is what the OS schedules to execute on a single core
* A process consists of one or more threads
* Multiple threads can run on a single core. And although only one thread is executing on a core at a time, since threads are multiplexed so quickly (exact mechanism is based on the particular OS scheduling algorithm), it seems to us as if multiple threads are running at the same time 
* For a multi-core CPU, a multi-threaded process can have all its threads running on the same core or splitted between different cores. The decision for which core a thread will run on is made by the OS
* Each thread will have its own registers set and stack
<div align='center'> 
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/general/Miscellaneous/4_01_ThreadDiagram.png" width="469" height="270">
<p align='center'><sub><strong>single threaded vs multi-threaded process</strong></sub></p>
</div>

---
#### *<p align='center'> Start IS NOT Main </p>*
---
* Entry point of a binary (start function) is not main. A program's startup code (how main is set up and called) depends on the compiler and the platform that the binary is compiled for
* For C binary compiled by gcc, [crt0](https://en.wikipedia.org/wiki/Crt0) is usually linked into the program to perform initialization before main
<div align='center'> 
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/general/Miscellaneous/start_v_main.PNG"> 
<p align='center'><sub><strong>32-bit ELF binary compiled by gcc</strong></sub></p>
</div>

---
#### *<p align='center'> Random Number Generator </p>*
---
* Randomness requires a source of entropy (seed), which is an unpredictable sequence of bits that can come from the OS observing its internal operations or ambient factors. Algorithms using a seemingly unpredictable sequence of bits as seed are known as pseudorandom number generators, because while their output are not random, they still pass the statistical tests of randomness
* [basic pseudorandom number generator using srand, rand, and time](https://gist.github.com/yellowbyte/4c36b9fffa73d79fa739f75a5ea951c9)

---
#### *<p align='center'> Endianness </p>*
---
* Intel x86 and x86-64 use little-endian format. It is a format where multi-bytes datatype (e.g. integer) has its least significant byte stored in the lower address of main memory 
* Value stored in RAM is in little-endian but when moved into a register will be in big-endian. This is why even though bytes representing an integer is flipped in memory, it will be in its original form when moved into a register
<div align='center'> 
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/general/Miscellaneous/endianness.png" width="50%" height="50%"> 
<p align='center'><sub><strong>integer 599 (0x257) in memory vs in register</strong></sub></p>
</div>

---
#### *<p align='center'> Software Breakpoint </p>*
---
* Debugger reads and stores an instruction's first byte and then overwrites that first byte with 0xCC (INT3) to set a breakpoint at that instruction. When CPU hits the breakpoint (0xCC), OS kernel sends SIGTRAP signal to process, process execution is paused by the debugger, and debugger's internal lookup occurs to flip the original byte back
<div align='center'> 
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/general/Miscellaneous/soft_bp.png"> 
<p align='center'><sub><strong>software breakpoint</strong></sub></p>
</div>

---
#### *<p align='center'> Hardware Breakpoint </p>*
---
* Set at CPU level in special registers called debug registers
* Debug registers (DR0 through DR7)
  * DR0-DR3: stores addresses of hardware breakpoints
  * DR4-DR5: reserved
  * DR6: status register that contains information on which debugging event has occurred
  * DR7: stores breakpoint conditions and the lengths of breakpoints for DR0-DR3
* Before CPU attempts to execute an instruction, it first checks whether the address is currently enabled for a hardware breakpoint. If the address is stored in debug registers DR0–DR3 and the read, write, or execute conditions are met, an INT1 is fired and the process halts
<div align='center'> 
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/general/Miscellaneous/hardware_bp.png" width="469" height="270"> 
<p align='center'><sub><strong>hardware breakpoint</strong></sub></p>
</div>

---
#### *<p align='center'> Memory Breakpoint </p>*
---
* Changes the permissions on a region, or page, of memory
* Guard page: Any access to a guard page results in a one-time exception, and then the page returns to its original status. Memory breakpoint changes permission of the page to guard
<div align='center'> 
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/general/Miscellaneous/memory_bp.png"> 
<p align='center'><sub><strong>memory breakpoint</strong></sub></p>
</div>

#
<strong><p align='center'><a href="/contents/encodings/Data_Encoding.md">Data Encoding</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="general.md">.general</a>] -> <a href="/contents/tools/IDA_Tips.md">IDA Tips</a></p></strong>
