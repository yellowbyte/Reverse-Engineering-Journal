### <a href="Anti-Disassembly.md"><-</a> [.anti-analysis](anti-analysis.md)[__Anti-Debugging__] <a href="Anti-Emulation.md">-></a>

---
#### *<p align='center'> Leveraging OS to Detect Debugger's Presence </p>*
---
* __ptrace (Linux)__: ptrace system call allows a process (tracer) to observe and control execution of a second process (tracee), but only one tracer can control a tracee at a time. All debuggers and program tracers use ptrace call to setup debugging for a process. If the debugee's code itself contains a ptrace call with the request type PTRACE_TRACEME, PTRACE_TRACEME will set the parent process (most likely bash) as the tracer. This means that if a debugger is already attached to the debugee, the ptrace call within the debugee's code will fail
  * This method can be bypassed by using LD_PRELOAD, which is an environment variable that is set to the path of a shared object. That shared object will be loaded before other libraries. As a result, if that shared object contains your own implementation of ptrace, then your own implementation of ptrace will be called instead
  * [Hiding Call To Ptrace](https://github.com/yellowbyte/analysis-of-anti-analysis/blob/develop/research/hiding_call_to_ptrace/hiding_call_to_ptrace.md)
* Windows provides several APIs that can be used by a program to determine if it is being debugged
  * __DebugActiveProcess (Self-Debugging)__: Windows' version of ptrace. Self-debugging can be achieved by spawning a new process and use kernel32!DebugActiveProcess to debug the parent process. Call to DebugActiveProcess will fail if a debugger is already attached to the parent process
  * __IsDebuggerPresent__: checks the PEB structure for the IsDebugged field. If the process is running under the context of a debugger, the IsDebugged field will be 1, otherwise 0
  * __CheckRemoteDebuggerPresent__: can use this to check if a remote or current process is being debugged. Also checks the IsDebugged field in the PEB structure to make the decision
  * __NtQueryInformationProcess__: Native Windows API in Ntdll.dll. CheckRemoteDebuggerPresent will eventually call this native function. Passing ProcessDebugPort (0x7) as its second argument will tell this function to query whether the process is being debugged or not
  * __OutputDebugString__: sends debugger strings to display. If debugger is present, this function will return a valid address in the process address space into eax. Otherwise, it will return an invalid address
  * For a more comprehensive list, check out [section 7 of the Ultimate Anti-Debugging Reference by Peter Ferrie](http://anti-reversing.com/Downloads/Anti-Reversing/The_Ultimate_Anti-Reversing_Reference.pdf)
* __readlink (Linux)__: calling readlink on "/proc/&lt;ppid&gt;/exe" will return a string containing the location of the debugger if one is attached. You can find ppid by checking the dynamic file /proc/&lt;pid&gt;/status. And to find the pid of the process, use the ps command
  * __/proc/&lt;pid&gt;/status__: this dynamic file also contains other information on a running process, such as whether or not the process is being traced. If the field tracerPid is 0, the process is not being traced
  * Under GDB, argv[0] (name of the current invoked program) contains binary's absolute path even if you invoke the binary from a relative path. Under normal execution, argv[0] will contain the relative path. You can take advantage of this with any string-related functions, such as strcmp() and strstr(), to detect presence of GDB
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/anti-analysis/Anti-Debugging/proc_status.png">
<p align='center'><sub><strong>a tracee is identified using /proc/&lt;pid&gt;/status and its corresponding tracer is identified using readlink</strong></sub></p>
</div>

---
#### *<p align='center'> Using Flags within the PEB structure to Detect Debugger's Presence (Windows) </p>*
---
* Location of PEB can be referenced by the location fs:[30h] on Win32. The second item on the PEB struct is BYTE BeingDebugged. The API function, isDebuggerPresent, checks this field to determine if a debugger is present or not
* __Flags and ForceFlags__: within Reserved4 array in PEB, is ProcessHeap, which is set to location of process’s first heap allocated by loader. This first heap contains a header with fields that tell kernel whether the heap was created within a debugger. The fields are Flags and ForceFlags. If the Flags field does not have the HEAP_GROWABLE(0x2) flag set, then the process is being debugged. Also, if ForceFlags != 0, then the process is being debugged. The location of both Flags and ForceFlags in the heap depends on whether the machine is 32-bit or 64-bit and also the version of Window Operating System (e.g. Windows XP, Windows Vista)
* __NTGlobalFlag__: Since processes run slightly differently when started by a debugger, they create memory heaps differently. The information that the system uses to determine how to create heap structures is stored in the NTGlobalFlag field in the PEB at offset 0x68 in x86 and 0xbc in x64. If value at this location is 0x70 (FLG_HEAP_ENABLE_TAIL_CHECK(0x10) | FLG_HEAP_ENABLE_FREE_CHECK(0x20) | FLG_HEAP_VALIDATE_PARAMETERS(0x40)), we know that we are running in debugger

---
#### *<p align='center'> Breakpoint Detection </p>*
---
* If we detected breakpoints in a process, then we know that process is running under a debugger
* __INT Scanning__: Search the executable code for the 0xCC byte. If it exists, that means that a software breakpoint has been set and the process is under a debugger
* __Code Checksums__:  Instead of scanning for 0xCC, this check simply performs a cyclic redundancy check (CRC) or a MD5 checksum of the opcodes. This not only catches software breakpoints, but also code patches
* __Anti-Step-Over__: the rep or movs(b|w|d) instruction can be used to overwrite/remove software breakpoints that are set after it
* __Hardware Breakpoints (Windows)__: Get a handle to current thread using GetCurrentThread(). Get registers of current thread using GetThreadContext(). Check if registers DR0-DR3 is set, if it is then there are hardware breakpoints set. On Linux, user code can't access hardware breakpoints so it's not possible to check for it

---
#### *<p align='center'> Interrupts </p>*
---
* Manually adding/setting interrupts to the code to help detect present of a debugger
* __False Software Breakpoints__: a breakpoint is created by overwriting the first byte of instruction with an int3 opcode (0xcc). To setup a false breakpoint then we simply insert int3 into the code. This raises a SIGTRAP signal when int3 is executed. If our code has a signal handler for SIGTRAP, the handler will be executed before resuming to the instruction after int3. But if the code is under the debugger, the debugger will catch the SIGTRAP signal instead and might not pass the signal back to the program, resulting in the signal handler not being executed
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/anti-analysis/Anti-Debugging/sigtrap.png">
<p align='center'><sub><strong>bypassing False Software Breakpoints with gdb</strong></sub></p>
</div>

* __False Memory Breakpoints__: Create a dynamic buffer and write the opcode for ret instruction in it. Manually change the permission of the page the buffer is in to guard. Pushes a return address to the stack before jumping to that dynamic buffer. If execution transfer control to that return address, then the program knows that it's under the context of a debugger since STATUS_GUARD_PAGE_VIOLATION exception was absorbed by the debugger
* __Two Byte Interrupt 3__: instead of 0xCC, it's 0xCD 0x03. Can also be used as false breakpoint
* __Interrupt 0x2C__: raises a debug assertion exception. This exception is consumed by WinDbg
* __Interrupt 0x2D__: issues an EXCEPTION_BREAKPOINT (0x80000003) exception if no debugger is attached. Also it might also led to a single-byte instruction being skipped depending on whether the debugger chooses the EIP register value or the exception address as the address from which to resume
* __Interrupt 0x41__: this interrupt cannot be executed successfully in ring 3 because it has a DPL of zero. Executing this interrupt will result in an EXCEPTION_ACCESS_VIOLATION (0Xc0000005) exception. Some debugger will adjust its DPL to 3 so that the interrupt can be executed successfully in ring 3. This results in the exception handler to not be executed
* __ICEBP (0xF1)__: generates a single step exception
* __Trap Flag Check__: Trap Flag is part of the EFLAGS register. IF TF is 1, CPU will generate Single Step exception(int 0x01h) after executing an instruction. Trap Flag can be manually set to cause next instruction to raise an exception. If the process is running under the context of a debugger, the debugger will not pass the exception to the program so the exception handler will never be ran
* __Stack Segment__: when you operate on SS (e.g. mov ss, pop ss), CPU will lock all interrupts until the end of the next instruction. Therefore, if you are single-stepping through it with a debugger, the debugger will not stop on the next instruction but the instruction after the next one. One way to detect debugger is for the next instruction after a write to SS to be pushfd. Since the debugger did not stop there, it will not clear the trap flag and pushfd will push the value of trap flag (plus rest of EFLAGS) onto the stack

---
#### *<p align='center'> Timing Checks </p>*
---
* Record a timestamp, perform some operations, take another timestamp, and then compare the two timestamps. If there is a significant difference, you can assume the presence of a debugger
* __rdtsc Instruction (0x0F31)__: this instruction returns the count of the number of ticks since the last system reboot as a 64-bit value placed into EDX:EAX. Simply execute this instruction twice and compare the difference between the two readings

---
#### *<p align='center'> Detection Before Main </p>*
---
* __TLS Callbacks (Windows)__: most debuggers start at the program’s entry point as defined by the PE header. TlsCallback is traditionally used to initialze thread-specific data before a thread runs, so TlsCallback is called before the entry point and therefore can execute secretly in a debugger
* In C, function using the "constructor" attribute will execute before main()
* Make it harder to find anti-debugging checks by executing them before main()

#
<strong><p align='center'><a href="Anti-Disassembly.md">Anti-Disassembly</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="anti-analysis.md">.anti-analysis</a>] -> <a href="Anti-Emulation.md">Anti-Emulation</a></p></strong>
