## *<p align='center'><a href="/contents/file-formats/file-formats.md"><-</a>  .anti-analysis  <a href="/contents/encodings/encodings.md">-></a></p>*

__Reversing Is Easy?__
* Aside from that a [compiler will bloat up the size of the compiled code](https://twitter.com/MalwareTechBlog/status/959925068196294656), reverse engineering for the purpose of understanding how a program works is really not a hard task. Even though [x86](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/instruction-sets/x86.md) [instruction set](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/instruction-sets/instruction-sets.md) is enormous and source to assembly is a one-to-many relationship, a compiler will usually prefer only a subset of the [x86](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/instruction-sets/x86.md) [instruction set](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/instruction-sets/instruction-sets.md) to translate the source code to. It might take longer to understand the disassembly, but after reversing for a while, you will start to notice the same assembly patterns and [idioms](https://reverseengineering.stackexchange.com/questions/17540/tutorial-or-resource-for-understanding-obscure-assembly-idioms) over and over again. Getting used to those idioms and common assembly constructs for high-level languages (e.g. for loop, if statement, function call) help you decipher the purpose of a group of instructions quicker. Eventually, you will be able to understand on a high level what portion of the disassembly is doing what. Once you reach this state, the program is yours.

__Not So Fast...__
* Obviously there are people that don't want their programs to be analyzed. When that is the case, they will use various techniques to hinder reversing of their software. The well-known anti-analysis techniques can be seen below but there are also many more undocumented or less-known ones. The good news is: no matter how hard one tried to obfuscate a program, there is no guarantee that it cannot be de-obfuscated. It is only a matter of time before a protected program is taken apart. Furthermore, unless the program is a crackme or a reversing challenge, one can't simply try to make the program as hard to reverse as possible since program performance also needs to be taken into consideration. Depending on the anti-analysis techniques and on what portion of the code is hardened, the performance difference could be fairly noticeably.

---
### *<p align='center'> section overview </p>*
---
* [Obfuscation](Obfuscation.md)
  * [Original Entry Point (OEP) Hiding](Obfuscation.md#-original-entry-point-oep-hiding-)
  * [Functions In/Out-Lining](Obfuscation.md-functions-inout-lining-)
  * [Opcode Obfuscation](Obfuscation.md#-opcode-obfuscation-)
  * [Code Insertion](Obfuscation.md#-code-insertion-)
  * [Pattern-Based Obfuscation](Obfuscation.md#-pattern-based-obfuscation-)
  * [Destruction of Sequential and Temporal Locality](Obfuscation.md#-destruction-of-sequential-and-temporal-locality-)
  * [Imported Function Obfuscation](Obfuscation.md#-imported-function-obfuscation-)
* [Anti-Disassembly](Anti-Disassembly.md)
  * [Disassembly Techniques](Anti-Disassembly.md#-disassembly-technique-)
  * [Disassembly Desynchronization](Anti-Disassembly.md#-disassembly-desynchronization-)
  * [Processer-Based Control Indirection](Anti-Disassembly.md#-processer-based-control-indirection-)
  * [Parser Differential Attack (File Format Hacks)](Anti-Disassembly.md#-parser-differential-attack-file-format-hacks-)
* [Anti-Debugging](Anti-Debugging.md)
  * [Leveraging OS to Detect Debugger's Presence](Anti-Debugging.md#-leveraging-os-to-detect-debuggers-presence-)
  * [Using Flags within the PEB structure to Detect Debugger's Presence (Windows)](Anti-Debugging.md#-using-flags-within-the-peb-structure-to-detect-debuggers-presence-windows-)
  * [Breakpoint Detection](Anti-Debugging.md#-breakpoint-detection-)
  * [Interrupts](Anti-Debugging.md#-interrupts-)
  * [Timing Checks](Anti-Debugging.md#-timing-checks-)
  * [Detection Before Main](Anti-Debugging.md#-detection-before-main-)
* [Anti-Emulation](Anti-Emulation.md)
  * [Detection through Syscall](Anti-Emulation.md#-detection-through-syscall-)
  * [CPU Inconsistencies Detection](Anti-Emulation.md#-cpu-inconsistencies-detection-)
  * [Timing Delays](Anti-Emulation.md#-timing-delays-)
  * [Number of Cores](Anti-Emulation.md#-number-of-cores-)

---
### *<p align='center'> further readings </p>*
---
* [The "Ultimate" Anti-Debugging Reference](http://anti-reversing.com/Downloads/Anti-Reversing/The_Ultimate_Anti-Reversing_Reference.pdf): a comprehensive Windows anti-debugging guide by Peter Ferrie
* [Al-Khaser](https://github.com/LordNoteworthy/al-khaser): a sample application that performs different types of common anti-analysis tricks
* [Analysis of Anti-Analysis](https://github.com/yellowbyte/analysis-of-anti-analysis): my blog on anything related to anti-reverse engineering

#
<strong><p align='center'><a href="/contents/file-formats/file-formats.md">.file-formats</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a> -> <a href="/contents/encodings/encodings.md">.encodings</a></p></strong>
