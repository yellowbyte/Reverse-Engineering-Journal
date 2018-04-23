### <a href="Anti-Debugging.md"><-</a> [.anti-analysis](anti-analysis.md)[__Anti-Emulation__] <a href="/contents/encodings/String_Encoding.md">-></a>

---
#### *<p align='center'> CPU Inconsistencies Detection </p>*
---
* Try executing privileged instructions in user-mode. If it succeeds, then the program is under emulation
  * WRMSR is a privileged instruction that is used to write values to a MSR register. Values in MSR registers can be critical. For example, the SYSCALL instruction invokes the system-call handler by loading RIP from the IA32_LSTAR MSR register. As a result, user-mode application should not be able to access it
* __Detection Through System Calls__: invoke various uncommon system calls and check if it contains expected value. Since if there are OS features not properly implemented, it means that the process is running under emulation

---
#### *<p align='center'> Timing Delays </p>*
---
* Execution under emulation will be slower than running under a physical CPU

---
#### *<p align='center'> Number of Cores </p>*
---
* The number of cores under emulation will be less than the number of cores on host machine

#
<strong><p align='center'><a href="Anti-Debugging.md">Anti-Debugging</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="anti-analysis.md">.anti-analysis</a>] -> <a href="/contents/encodings/String_Encoding.md">String Encoding</a></p></strong>
