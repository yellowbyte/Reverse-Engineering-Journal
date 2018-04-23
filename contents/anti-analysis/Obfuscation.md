### <a href="/contents/file-formats/PE_Files.md"><-</a> [.anti-analysis](anti-analysis.md)[__Obfuscation__] <a href="Anti-Disassembly.md">-></a>

---
#### *<p align='center'> Original Entry Point (OEP) Hiding </p>*
---
* OEP can be hidden through packing. A packer can compress or encrypt an executable and inject an unpacking stub that unpacks (decompresses or decrypts) it during runtime. This will hide the OEP and also a large portion of the original executable (such as the text, data, rsrc sections) from static analysis
* __Tail Jump__: an instruction that jumps from the unpacking stub to OEP after the unpacking stub finishes
* __Signs Of Packer Usage__:
  * Unusually high file entropy
  * Program behavior that mimics the way system loader loads a executable file into memory
* __How To Hide From Detection__:
  * Instead of packing the whole binary, only pack a small portion of it (e.g. portion of .text section) to avoid high file entropy
  * __Polymorphism__: avoid fingerprinting by creating a different but semantically the same unpacking stub every time the packer is used

---
#### *<p align='center'> Functions In/Out-Lining </p>*
---
* Performs operations that create inline and outline functions randomly to obfuscate the call graph
* __Inline Functions__: a function that is merged into the body of its caller
* __Outline Functions__: inverse of inline function where a subportion of a function is extracted to create another function. The subportion of this function is then replaced with a CALL instruction that calls the newly created function

---
#### *<p align='center'> Opcode Obfuscation </p>*
---
* A technique to prevent correct disassembly by displaying opcodes that need to be re-interpreted/altered during runtime before being executed by the CPU
* __Self-Modifying Code__: disassembly shows the encoded/encrypted opcodes. During runtime, the encoded/encrypted opcodes are decoded/decrypted, revealing the opcodes that will actually be executed. Encoding/encrypting portions of a program can hinder static analysis because disassembly is not possible (if it is, it will display the wrong disassembly) and hinder debugging because placing breakpoints is difficult. For example, even if the start of an instructions is known, breakpoint cannot be placed until the instruction have been decoded/decrypted
* __Virtual Obfuscation (Runtime Code Generation)__: parts of the program are compiled to the bytecode that corresponds to the instruction set of an undocumented interpreter (usually one that the obfuscator wrote him or herself). The interpreter will be a part of the protected program such that during runtime, the interpreter will translate those bytecode into machine code that corresponds to the original architecture (e.g. x86). This method can also prevent the dumping of the complete deobfuscated opcodes from memory during runtime, which Self-Modifying Code is susceptible to.

---
#### *<p align='center'> Code Insertion </p>*
---
* Inserts extraneous code to complicate analysis
* __Dead Code Insertion__: inserts useless code that doesn't affect a program's functionalities. To do this, an obfuscator needs to figure out which registers are dead (e.g. does not contain important values) so it knows which instructions it can insert
  * Can be resolved by applying dead code elimination
* __Junk Code Insertion__: inserts code that never get executed

---
#### *<p align='center'> Pattern-Based Obfuscation </p>*
---
* Transforms a sequence of instructions into another sequence that is more complicated but semantically the same
  * This task could be difficult since the obfuscated sequence can look semantically the same but actually does not preserve CPU state, which can cause later program behavior to be semantically non-equivalent. This can happen if the new sequence's side effects (e.g. modify/didn't modify the flags or modify/didn't modify the stack) doesn't match 1-to-1 to the original sequence's side effects in its entirety
  * Can be resolved by applying peephole optimization
* __Irreducible Programs__: transforms a loop into more complicated construct on the source code level. Duplicate the loop and insert a conditional construct that could reach either loop. Obsfucate each loop accordingly. When compiled, compiler cannot optimize away the conditional construct away since it does not know that both path are functionally equivalent.
* __Source-Level Opaque Predicate__: transforms a trivial opaque predicate into a non-trivial opaque predicate. A source-level's trivial opaque predicate in a conditional construct will be optimized away if compiler knows that it will always be evaluated to either True or False. For a non-trivial opaque predicate, even though the predicate will always evaluate to either True or False, the underlying code construct makes it hard to figure that out statically. As a result, compiler doesn't optimize away the conditional construct
  * [Environment-Based Opaque Predicates](https://reverseengineering.stackexchange.com/questions/2340/how-to-design-opaque-predicates)
  * Uses global variables instead of constants in the predicates. Compiler won't be able to optimize the conditional construct since it can't assume the value of global variables
  * Introduces entropy into the predicate (e.g. using rand() function)
* __Constant Unfolding__: replaces constant with unnecessary computations that will output the same constant
  * This can be accomplished on the source-level if the variable is assigned as volatile in C. The volatile keyword tells the compiler to not optimize this variable so you can perform unnecessary computations with it without worrying that the compiler will remove or shorten them
* __Arithmetic Substitution via Identities__: replaces a mathematical statement with one that is more complicated but semantically the same

---
#### *<p align='center'> Destruction of Sequential and Temporal Locality </p>*
---
* __Spaghetti Code__: code within a basic block will be right next to each other __(sequential locality)__ and basic blocks relating to each other will be placed in close proximity to maximize instruction cache locality __(temporal locality)__. To obstruct this property and make disassembly harder to understand, a basic block can be further divided and randomized using unconditional jumps
* __Control-Flow Graph Flattening__: obfuscates control flow by replacing a group of control structures with a dispatcher. Each basic block updates the dispatcher's context so it knows which basic block to execute next

---
#### *<p align='center'> Imported Function Obfuscation </p>*
---
* Makes it difficult to determine which shared libraries or library functions are used
* Have the program’s import table be initialized by the program itself. The program will load any additional libraries it depends on, and once the libraries are loaded, the program locates any required functions within those libraries
* (Windows) uses LoadLibrary to load required libraries by name and then performs function address lookups within each library using GetProcAddress
* (Linux) uses dlopen to load the dynamic shared object and uses dlsym to find the address of a specific function within the shared object

#
<strong><p align='center'><a href="/contents/file-formats/PE_Files.md">PE Files</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="anti-analysis.md">.anti-analysis</a>] -> <a href="Anti-Disassembly.md">Anti-Disassembly</a></p></strong>
