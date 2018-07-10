## *<p align='center'><a href="/contents/general/general.md"><-</a>  .tools  <a href="/contents/instruction-sets/instruction-sets.md">-></a></p>*

<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/tools.jpg" width="375" height="322">
<p align='center'><sub><strong>drawing by <a href="http://www.leejohnphillips.com/">Lee John Phillips</a></strong></sub></p>
</div>

__Static Analysis vs Dynamic Analysis__
* Static analysis refers to analyzing a binary without running it whereas dynamic analysis refers to analyzing a binary __BY__ running it. These two ideas can be further categorized into manual or automated analysis. Manual static/dynamic analysis involves human interaction throughout the reversing process. Examples of manual analysis to understand program behavior includes studying the assembly listings from a disassembler (e.g. [IDA](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/tools/IDA_Tips.md)) or executing the binary and inspecting its memory and registers states at different execution points with the help of a debugger (e.g. [GDB](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/tools/GDB_Tips.md)). Automated static/dynamic analysis doesn't exactly mean human interaction is not required. An automated analysis tool still require human to setup/script the tool. What's automated is the execution of the tool to discover points of interest (e.g. buffer overflow). 
* In terms of automation, static analysis technique such as symbolic execution is associated with soundness, meaning that it doesn't result in false negative (not identifying something as point of interest when it is). Although it is more sound, it is also more prone to false positive since it is hard to model with 100% accuracy a binary's interactions with its intended environment without executing it. Furthermore, often we will have to sacrifice some soundness for static analysis to be practical since modeling a whole program is often infeasible due to the amount of data that needs to be kept track of. On the other hand, dynamic analysis such as fuzzing is associated with completeness or that it doesn't result in false positive (identifying something as point of interest when it is not). For example, every single crash a fuzzer finds is a real and reproducible crash. The tradeoff here is that a fuzzer is less sound since it reasons in terms of a single path and it's very unlikely that it will hit all execution paths that will lead to a crash by providing the fuzzer with random inputs. To mitigate static and dynamic analysis' drawbacks, they are often used together (e.g. [concolic execution](https://en.wikipedia.org/wiki/Concolic_testing)).

__Static Analysis Is King__
* When reversing a target, most likely you don't need to reverse every little detail of it to reach your goal. Initial triage efforts using various static analysis, dynamic analysis, and/or automation tools will help you identify points of interest to start reversing from. Some of those tools may also be ran throughout the reversing process to ascertain particular suspicion or to assist with deobfuscation, but either way, you will be spending the majority of your time inside a disassembler. As a result, at least __know how to use a [disassembler](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/tools/IDA_Tips.md) well__.

__Be Cautious...__
* Never be too reliant on any one tool. For most popular tools, depending on their usages, there are ways to [detect their presences](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/anti-analysis/Anti-Debugging.md#-using-functions-from-dynamically-linked-libraries-to-detect-debuggers-presence-), [hide certain program properties from them](http://www.hexacorn.com/blog/2018/01/04/yet-another-way-to-hide-from-sysinternals-tools/), or [make them not function properly](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/anti-analysis/Anti-Disassembly.md#-parser-differential-attack-file-format-hacks-).

---
### *<p align='center'> section overview </p>*
---
* [IDA Tips](IDA_Tips.md)
  * [Addresses Shown In IDA](IDA_Tips.md#-addresses-shown-in-ida-)
  * [Functions Window](IDA_Tips.md#-functions-window-)
  * [Graphs](IDA_Tips.md#-graphs-)
  * [Keeping Track of Manual Analysis](IDA_Tips.md#-keeping-track-of-manual-analysis-)
  * [Useful Shortcuts](IDA_Tips.md#-useful-shortcuts-)
* [GDB Tips](GDB_Tips.md)
  * [Changing Default Settings](GDB_Tips.md#-changing-default-settings-)
  * [User Inputs](GDB_Tips.md#-user-inputs-)
  * [Automation](GDB_Tips.md#-automation-)
  * [Ways To Pause Debuggee](GDB_Tips.md#-ways-to-pause-debuggee-)
  * [Useful Commands](GDB_Tips.md#-useful-commands-)

---
### *<p align='center'> further readings </p>*
---
* [Free Reverse Engineering Tools by Wiremask](https://wiremask.eu/articles/free-reverse-engineering-tools/): list of relevant (still maintained) and free reverse engineering tools
* [IDA Alternatives](https://reverseengineering.stackexchange.com/questions/1817/is-there-any-disassembler-to-rival-ida-pro): there is no disassembler that rivals IDA, but getting a IDA license does costs a fortune. Personally, for alternatives, I would recommand [Binary Ninja](https://binary.ninja/) since it only costs 150 dollars and has an interactive GUI interface like IDA or [Radare2](https://github.com/radare/radare2) if you don't mind working in the command-line and spending a little more time learning how to use the tool. Plus, [Radare2](https://github.com/radare/radare2) is free

#
<strong><p align='center'><a href="/contents/general/general.md">.general</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a> -> <a href="/contents/instruction-sets/instruction-sets.md">.instruction-sets</a></p></strong>
