### <a href="/contents/instruction-sets/ARM.md"><-</a> [.languages](languages.md)[__C++ Reversing__] <a href="Python_Reversing.md">-></a>

---
#### *<p align='center'> Thiscall </p>*
---
* __Thiscall__: C++'s calling convention
* On Microsoft Visual C++ compiled binary, "this" pointer is stored in ecx. Sometimes esi
* On g++ compiled binary, "this" pointer is passed in as the first parameter to a member function
* "this" pointer points to a class object

---
#### *<p align='center'> How An Object Is Represented </p>*
---
* __How An Object Is Represented__: class object in assembly only contains the vfptr (pointer to virtual functions table) and variables. Non-virtual member functions are not part of it
* Child class automatically has all virtual functions and variables from parent class
* If the class contains virtual functions, a call to the constructor will be made to fill in the vfptr to point to vtable during object creation. If the class inherit from another class, within the constructor there will have a call to the constructor of the parent class
* vtable of a class is determined during compile-time (resides in .rdata)
* Compiler places a pointer immediately prior to a class' vtable. That pointer points to a structure that contains information on the name of class that owns the vtable

---
#### *<p align='center'> Name Mangling </p>*
---
* __Name Mangling__: a technique where parameters information are embedded into function name. It is to support Method Overloading (multiple functions with same name but accept different parameters), since a function in a PE or ELF file is only labeled by its name
#
<strong><p align='center'><a href="/contents/instruction-sets/ARM.md">ARM</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="languages.md">.languages</a>] -> <a href="Python_Reversing.md">Python Reversing</a></p></strong>
