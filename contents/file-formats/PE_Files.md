### <a href="ELF_Files.md"><-</a> [.file-formats](file-formats.md)[__PE Files__] <a href="/contents/anti-analysis/Obfuscation.md">-></a>

---
#### *<p align='center'> Overview </p>*
---
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/file-formats/PE_Files/pe_header.png">
<p align='center'><sub><strong>PE file format overview</strong></sub></p>
</div>

---
#### *<p align='center'> PE File In Memory </p>*
---
<div align='center'>
<img src="https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/images/file-formats/PE_Files/loading_pe_file.png">
<p align='center'><sub><strong>PE file in memory</strong></sub></p>
</div>

---
#### *<p align='center'> Virtual Address(VA) To File Offset Translation </p>*
---
* file_offset = VA - image_base - section_base_RVA + section_file_offset
  1. VA - image_base = RVA. RVA (Relative Virtual Address) is virtual address relative to the image base (HMODULE). It is used to avoid hardcoded memory addresses since the image base might not always get loaded to its preferred load address. As a result, address obtained from disassembler might not match the address obtained from a debugger
  2. RVA - section_base_RVA = offset from base of the section
  3. offset_from_section_base + section_file_offset = file offset on disk

---
#### *<p align='center'> DOS Header </p>*
---
* Starts at offset 0. The 2 fields of interest in the DOS header are __e_magic__ and __e_lfanew__. __e_magic__ contains the magic number 0x5A4D (MZ). __e_lfanew__ contains PE header's file offset
* __e_lfanew__ field is necessary since PE Header does not directly follows DOS Header. In between is the DOS Stub, which for backward compatibility prints "This program cannot be run in DOS mode" if a 32-bit PE file is ran in a 16-bit DOS environment

---
#### *<p align='center'> PE Header (IMAGE_NT_HEADERS) </p>*
---
* __Signature__: always 0x00004550 ("PE00")
* __IMAGE_FILE_HEADER (COFF Header)__: contains basic information on the file (e.g. target CPU, number of sections). Always 20 bytes long
* __IMAGE_OPTIONAL_HEADER32 (PE Optional Header)__: contains most of the meaningful information. Can be further broken down into 3 parts:
  * __Standard Fields__: notable fields are MagicNumber and AddressOfEntryPoint
    * __MagicNumber__: determines whether the file uses 64-bit address space (PE32+) or 32-bit address space. PE32+ contained widened PE Optional Header
    * __AddressOfEntryPoint__: RVA to the entry point function
  * __Windows Specific Fields (Additional Fields)__: notable fields are ImageBase, SectionAlignment, and SizeOfImage
    * __ImageBase__: preferred address when loading into memory
    * __SectionAlignment__: alignment for section when loading into memory such that a section's VA will always be a multiple of this value
    * __SizeOfImage__: size of image starting from image base to the last section rounded to the nearest multiple of SectionAlignment
  * __Data Directory (IMAGE_DATA_DIRECTORY)__: array of IMAGE_DATA_DIRECTORY structures that contains RVAs and sizes of many important data structures (e.g. imports, exports, base relocations). Locations of those data structures reside in sections. Data structures allows loader to quickly locate an important section. Here are the notable IMAGE_DATA_DIRECTORY entries:
    * __Program Exception Data__: pointed by IMAGE_DATA_DIRECTORY's entry IMAGE_DIRECTORY_ENTRY_EXCEPTION. It is an exception table that contains an array of IMAGE_RUNTIME_FUNCTION_ENTRY structures. Each IMAGE_RUNTIME_FUNCTION_ENTRY contains the address to an exception handler
    * __Base Relocations__: pointed by IMAGE_DATA_DIRECTORY's entry IMAGE_DIRECTORY_ENTRY_BASERELOC. Refers to as the .reloc section. Contains every location that needs to be rebased if the executable doesn't load at the preferred load address

---
#### *<p align='center'> Section Header Table (IMAGE_SECTION_HEADERs) </p>*
---
* Comes right after PE Header. Each IMAGE_SECTION_HEADER contains information on a section, such as a section's virtual address or its pointer to data on disk
* 2 sections can be merged into a single one if they have similar attributes
  * .idata is often merged into .rdata in release-mode executable

---
#### *<p align='center'> Overlay </p>*
---
* data appended to end of a PE File. It is not mapped into memory

#
<strong><p align='center'><a href="ELF_Files.md">ELF Files</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="file-formats.md">.file-formats</a>] -> <a href="/contents/anti-analysis/Obfuscation.md">Obfuscation</a></p></strong>
