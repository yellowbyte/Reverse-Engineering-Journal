## *<p align='center'><a href="/contents/tools/tools.md"><-</a>  .instruction-sets  <a href="/contents/languages/languages.md">-></a></p>*

__Interface Between Software And Hardware__
* The idea of a general purpose computer was conceived in 1837 by [Charles Babbage](https://en.wikipedia.org/wiki/Analytical_Engine), but a working general purpose computer ([ENIAC](http://www.computerhistory.org/revolution/birth-of-the-computer/4/78)) was not built until 1945. Earlier computers such as [Atanasoff–Berry](http://www4.ncsu.edu/~belail/The_Introduction_of_Electronic_Computing/Atanasoff-Berry_Computer.html) (used to solve linear equations) and [Bombe](http://www.cryptomuseum.com/crypto/bombe/) (used for deciphering Enigma encrypted messages) are special-purpose computers that are hard-wired to perform a specific task, which means that you are unable to utilize their underlying hardware to do anything else. What differentiates a general purpose computer from a special purpose computer is the concept of an instruction set. An instruction set is the gateway to utilizing a general purpose computer's flexibility, allowing one to instruct a re-programmable (general-purpose) computer on how to interact with its underlying hardware to perform tasks ranging from weather prediction to space shuttle guidance while abstracting away the implementation details of those hardware components. It presents that gateway in human-readable mnemonics (English words), where each mnemonic has an unique set of zeros and ones that corresponds to an operation a CPU with the same instruction set implementation would know how to perform. An instruction set is said to be [Turing Complete](https://www.youtube.com/watch?v=RPQD7-AOjMI) if it can perform any computational task. The followings instruction sets I will talk about are all Turing Complete. On a funny note, it turns out that [one instruction from x86 is enough to be Turing Complete](https://drwho.virtadpt.net/files/mov.pdf).

__CISC vs RISC__
* Early computer was moving toward a CISC (Complex Instruction Set Computer) architecture. CISC was characterized by large (e.g. numbers of instructions) and complex (e.g. multiple operations performed by one instruction) instruction sets. The upsides of this design are flexibility and smaller overall codebase in the expense of a more complex processor implementation. Sometimes in the 70s, Professor David Patterson from University of California, Berkeley observed that compilers for high-level languages such as C only use a subset of CISC instruction set. His team realized that a simpler instruction set is sufficient enough to perform most tasks. Simpler instruction set also means simpler processor implementation, allowing more chip space to be used for memory. The work by Patterson led to two popular RISC processor designs: MIPS and [ARM](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/instruction-sets/ARM.md). As it stands today, CISC architectures, [x86](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/instruction-sets/x86.md) and [x86-64](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/instruction-sets/x86-64.md), still dominate the desktops, laptops, and servers industry while RISC architectures, MIPS and [ARM](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/instruction-sets/ARM.md), dominate the embedded space &mdash; although ARM is way more popular than MIPS. To be honest, you really don't see MIPS outside of routers and academic textbooks.

---
### *<p align='center'> section overview </p>*
---
* [x86](x86.md)
  * [Registers](x86.md#-registers-)
  * [Assembly to Machine Code Is Not One-To-One](x86.md#-assembly-to-machine-code-is-not-one-to-one-)
  * [Lost Of Type Information](x86.md#-lost-of-type-information-)
  * [Floating Point Arithmetic](x86.md#-floating-point-arithmetic-)
  * [Variable-Length Instruction](x86.md#-variable-length-instruction-)
  * [Commonly Used But Hard To Remember x86 Instructions With Side Effects](x86.md#-commonly-used-but-hard-to-remember-x86-instructions-with-side-effects-)
* [x86-64](x86-64.md)
  * [Canonical Form](x86-64.md#-canonical-form-)
  * [Registers](x86-64.md#-registers-)
  * [Calling Conventions](x86-64.md#-calling-conventions-)
  * [Exception Handling](x86-64.md#-exception-handling-)
  * [Other Notable Differences From x86](x86-64.md#-other-notable-differences-from-x86-)
* [ARM](ARM.md)
  * [ARM Version](ARM.md#-arm-version-)
  * [Privileges Separation](ARM.md#-privileges-separation-)
  * [Registers](ARM.md#-registers-)
  * [Load/Store Instructions](ARM.md#-loadstore-instructions-)
  * [Instructions For Function Invocation](ARM.md#-instructions-for-function-invocation-)
  * [Conditional Execution](ARM.md#-conditional-execution-)
  * [Importance of Barrel Shifter](ARM.md#-importance-of-barrel-shifter-)

---
### *<p align='center'> further readings </p>*
---
* [Azeria Labs](https://azeria-labs.com/): from ARM assembly to ARM exploitation. If you want to learn about ARM, this is it
* [xchg rax, rax](https://www.xorpd.net/pages/xchg_rax/snip_00.html): x86-64 assembly riddles

#
<strong><p align='center'><a href="/contents/tools/tools.md">.tools</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a> -> <a href="/contents/languages/languages.md">.languages</a></p></strong>
