### <a href="C++_Reversing.md"><-</a> [.languages](languages.md)[__Python Reversing__] <a href="/contents/file-formats/ELF_Files.md">-></a>

---
#### *<p align='center'> PVM (Python Virtual Machine) </p>*
---
* PVM is a stack-based virtual machine that stores operands in an upwardly-growing stack
* In stack-based execution, an operation is performed by popping operands from the stack, operates on them, and then storing the result back to the stack
* __Advantages of Stack-Based Virtual Machine__
  * Instructions are shorter than instructions in register-based virtual machine since operands don’t need to be explicitly stated because they are on the stack, thus resulting in shorter overall bytecode
  * Easier to implement since it doesn’t have to worry about register allocation

---
#### *<p align='center'> The 3 Tuples Associated With Function Object </p>*
---
* Local variables and parameters are stored in &lt;object name&gt;.`__code__`.co_varnames
* Global variables that it uses are stored in &lt;object name&gt;.`__code__`.co_names
* Constants it uses are stored in &lt;object name&gt;.`__code__`.co_consts

---
#### *<p align='center'> Python Bytecode Instructions </p>*
---
* For full instruction set, check out the [Official Python Documentation](https://docs.python.org/2/library/dis.html)
* An instruction consists of an opcode and possibly an oparg. Opcode is the instruction and oparg is the index that resolves to the actual operands
  * Some instructions, such as BINARY_ADD, doesn't require an oparg since the operands it needs are on the stack
  * Other instructions, such as those for LOAD/STORE, require an oparg to index a tuple for the operand. The specific tuple is referenced in the latter half of the opcode
    * __LOAD/STORE_CONST__: uses oparg to index the &lt;object name&gt;.`__code__`.co_consts tuple
    * __LOAD/STORE_FAST__: uses oparg to index the &lt;object name&gt;.`__code__`.co_varnames tuple
    * __LOAD/STORE_GLOBAL__: uses oparg to index the &lt;object name&gt;.`__code__`.co_names tuple
    * Load will push the value it indexed onto the stack and store will store the value at the top of the stack into the indexed object

#
<strong><p align='center'><a href="C++_Reversing.md">C++ Reversing</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="languages.md">.languages</a>] -> <a href="/contents/file-formats/ELF_Files.md">ELF Files</a></p></strong>
