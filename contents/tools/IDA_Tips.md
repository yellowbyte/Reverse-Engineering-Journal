###  <a href="/contents/general/Miscellaneous.md"><-</a> [.tools](tools.md)[__IDA Tips__] <a href="GDB_Tips.md">-></a>

---
#### *<p align='center'> Addresses Shown In IDA </p>*
---
* When IDA loads an executable binary, it simulates a mapping of the executable in memory. The addresses shown in IDA are the virtual memory addresses and not offsets of the binary file on disk
* The addresses shown in a debugger will not match the addresses shown in IDA if ASLR is enabled
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/ida_va_instr.PNG">
<p align='center'><sub><strong>IDA displaying 4 instructions along with their respective virtual addresses</strong></sub></p>
</div>
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/ida_va_hex.PNG">
<p align='center'><sub><strong>IDA displaying those 4 instructions in hex. Note that the virtual addresses are the same</strong></sub></p>
</div>
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/hex_on_disk.PNG">
<p align='center'><sub><strong>Actual locations of those 4 instructions on disk</strong></sub></p>
</div>

---
#### *<p align='center'> Functions Window </p>*
---
* Functions Window displays all the functions the binary uses: local functions, statically-linked functions (e.g. [crt0](https://en.wikipedia.org/wiki/Crt0)), and dynamically-linked functions
* dynamically-linked functions increase the disassembly's glance value and provide the reverser with more context to figure out what the surrounding code is doing since their original names can't be stripped away
  * __Glance value__: being able to quickly look over the code and have a general idea of what it is doing
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/default_functions_window.png">
<p align='center'><sub><strong>Functions Window example</strong></sub></p>
</div>

* By default, Functions Windows will only show the "Function name" column but you can expand it to reveal the other columns
  * __Segment__: segment that contains the function
  * __Start__: offset of the function within the segment
  * __Length__: function length in bytes
  * __Locals__: size (in bytes) of local variables + saved registers
  * __Arguments__: size (in bytes) of arguments passed to the function
  * __R__: function returns to the caller
  * __F__: far function
  * __L__: library function
  * __S__: static function
  * __B__: BP based frame. IDA will automatically convert all frame pointer [BP+xxx] operands to stack variables
  * __T__: function has type information
  * __=__: Frame pointer is equal to the initial stack pointer. In this case the frame pointer points to the bottom of the frame
    * Source: [idadoc](https://www.hex-rays.com/products/ida/support/idadoc/586.shtml)
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/expanded_functions_window.png">
<p align='center'><sub><strong>expanded Functions Window</strong></sub></p>
</div>

* To hide API (dynamically-linked functions) calls from displaying in the Functions Window, a programmer can dynamically resolve API functions
  * __How To Find Dynamically Resolved APIs__: get the binary's function trace (e.g. hybrid-analysis, ltrace). If any of the APIs in the function trace is not in the Functions Window, then that API is dynamically resolved
  * __How To Find Where A Dynamically Resolved API Is Called__: in IDA's debugger view, the Module Windows allows you to place a breakpoint on any function in a loaded dynamically linked library. Use it to place a breakpoint on a dynamically resolved API and once execution breaks there, step back through the call stack to find where it's called from in user code
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/source.png" width="500" height="430">
<p align='center'><sub><strong><a href="https://gist.github.com/yellowbyte/ec470d75ba7c14ebefed271c6fe58e9e">source code</a> showing how `puts` is dynamically resolved. String reference to `puts` is also encoded</strong></sub></p>
</div>
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/iat.png" width="470" height="370">
<p align='center'><sub><strong>even though `puts` is a function from a dynamically linked library it does not show up in IDA's Functions Window</strong></sub></p>
</div>
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/strings.png" width="500">
<p align='center'><sub><strong>GNU strings can't identify string reference to `puts` either</strong></sub></p>
</div>
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/ltrace.png" width="500">
<p align='center'><sub><strong>function tracer like ltrace is able to detect reference to `puts`</strong></sub></p>
</div>

---
#### *<p align='center'> Graphs </p>*
---
* All the available graphs (beside __Proximity Browser__ and __Graph Overview__) can be found under _View_ -> _Graphs_
  * __Proximity Browser__ can be found under _View_ -> _Open Subviews_
  * __Graph Overview__ can be found under _View_ -> _Graph Overview_
  * __NOTE__: __Flow Chart__, __Function Calls__, __Xrefs To__, and __Xrefs From__ graphs are only available in the licensed version of IDA
* When we hear IDA Graphs, most of us will think of IDA's __Graph View__, which shows how basic blocks of the function mouse cursor is on relate to each other, but IDA also provides many other useful graphs to aid with analysis. We will take a look at those other graphs below:
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/proximity_browser.png" width="80%" height="80%">
<p align='center'><sub><strong>Proximity Browser: interactive function call graph of whole binary</strong></sub></p>
</div>
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/graph_overview.png">
<p align='center'><sub><strong>Graph Overview: zoomed out 'Graph View.' It allows one to quickly see the whole structure of a function's CFG</strong></sub></p>
</div>
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/flowchart.gif">
<p align='center'><sub><strong>Flow Chart: printable 'Graph View.' Photo courtesy of <a href="https://www.hex-rays.com/products/ida/support/tutorials/unpack_pe/5.gif">Hex-Rays</a></strong></sub></p>
</div>
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/function_calls.png" width="70%" height="70%">
<p align='center'><sub><strong>Function Calls: printable non-interactive 'Proximity View.' Photo courtesy of <a href="http://scratchpad.wikia.com/wiki/Reverse_Engineering_Mentoring_Lesson_005">Scratchpad</a></strong></sub></p>
</div>
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/xrefs_to.png" width="40%" height="40%">
<p align='center'><sub><strong>Xrefs To: function call graph to current function. Photo courtesy of <a href="http://resources.infosecinstitute.com/ida-cross-references-xrefs/">Infosec Institute</a></strong></sub></p>
</div>
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/tools/IDA_Tips/xrefs_from.png" width="70%" height="70%">
<p align='center'><sub><strong>Xrefs From: function call graph from current function. Photo courtesy of <a href="http://resources.infosecinstitute.com/ida-cross-references-xrefs/">Infosec Institute</a></strong></sub></p>
</div>

---
#### *<p align='center'> Keeping Track of Manual Analysis </p>*
---
* __Marker__: centralized comments page for the binary under analysis
  * __Alt+M__: mark current cursor location with comments
  * __Ctrl+M__: brings up a window showing all marked positions with their corresponding comments
* __Notepad__: a blank window for jogging down any notes
  * To open Notepad: __View->Open subviews->Notepad__
* __Regular Comment__: makes a comment at current cursor location
* __Repeatable Comment__: same as regular comment except every cross-reference to commented location will also have the same comment
* __Additional Comment__: regular and repeatable comments will appear to the right of the instruction. You can also insert comments before (__Ins__) or after (__Shift+Ins__) the instruction

---
#### *<p align='center'> Useful Shortcuts </p>*
---
* __Ctrl+L__: jump to location by name
* __Ctrl+P__: jump to location by function name
* __Ctrl+X__: jump to cross reference
* __ESC__: jump to last location
* __u__ to undefine region of bytes starting at cursor
* __d__ to transform region of bytes starting at cursor to data
* __c__ to transform region of bytes starting at cursor to code
* __g__ to bring up 'Jump to address' menu
* __n__ to rename variables, functions, and labels
* __x__ to show cross-references to an address
* __y__ to redefine function prototype

#
<strong><p align='center'><a href="/contents/general/Miscellaneous.md">Miscellaneous</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="tools.md">.tools</a>] -> <a href="GDB_Tips.md">GDB_Tips</a></p></strong>
