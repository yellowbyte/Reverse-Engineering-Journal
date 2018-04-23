## *<p align='center'><a href="/contents/general/general.md"><-</a>  .tools  <a href="/contents/instruction-sets/instruction-sets.md">-></a></p>*

<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/tools.jpg" width="375" height="322">
<p align='center'><sub><strong>drawing by <a href="http://www.leejohnphillips.com/">Lee John Phillips</a></strong></sub></p>
</div>

__Static Analysis Is King__
* When reversing a target, most likely you don't need to reverse every little detail of it to reach your goal. Initial triage efforts using various static analysis, dynamic analysis, and/or automation tools will help you identify points of interest to start reversing from. Some of those tools may also be ran throughout the reversing process to ascertain particular suspicion or to assist with deobfuscation, but either way, you will be spending the majority of your time inside a disassembler. As a result, at least __know how to use a [disassembler](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/tools/IDA_Tips.md) well__.

__Be Cautious...__
* Never be too reliant on any one tool. For most popular tools, depending on their usages, there are ways to [detect their presences](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/anti-analysis/Anti-Debugging.md#-using-functions-from-dynamically-linked-libraries-to-detect-debuggers-presence-), [hide certain program properties from them](http://www.hexacorn.com/blog/2018/01/04/yet-another-way-to-hide-from-sysinternals-tools/), or [make them not function properly](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/anti-analysis/Anti-Disassembly.md#-parser-differential-attack-file-format-hacks-).

---
### *<p align='center'> section overview </p>*
---
* [IDA Tips](IDA_Tips.md)
  * [Addresses Shown In IDA](IDA_Tips.md#-addresses-shown-in-ida-)
  * [Import Address Table (IAT)](IDA_Tips.md#-import-address-table-iat-)
  * [Graphs](IDA_Tips.md#-graphs-)
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
* [IDA Alternatives](https://reverseengineering.stackexchange.com/questions/1817/is-there-any-disassembler-to-rival-ida-pro): there is no disassembler that rivals IDA, but getting a IDA license does costs a fortune. Personally, for alternatives, I would recommand [Binary Ninja](https://binary.ninja/) since it only costs 150 dollars and has a clean and interactive GUI interface like IDA or [Radare2](https://github.com/radare/radare2) if you don't mind working in the command-line and spending a little more time learning how to use the tool. Plus, [Radare2](https://github.com/radare/radare2) is free

#
<strong><p align='center'><a href="/contents/general/general.md">.general</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a> -> <a href="/contents/instruction-sets/instruction-sets.md">.instruction-sets</a></p></strong>
