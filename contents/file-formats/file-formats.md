## *<p align='center'><a href="/contents/languages/languages.md"><-</a>  .file-formats  <a href="/contents/anti-analysis/anti-analysis.md">-></a></p>*

__Everything Is Structured. You Just Don't Know It Yet__
* There are perhaps thousands of different file formats in the wild &mdash; file formats for images (e.g. JPEG, PNG, GIF), file formats for sounds (e.g. WAV, MP3, OPUS), or proprietary file formats for specific software products. As a reverse engineer, you are mostly only interested in executable file formats such as [ELF](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/file-formats/ELF_Files.md) and [PE](https://github.com/yellowbyte/reverse-engineering-reference-manual/blob/master/contents/file-formats/PE_Files.md), but at times you might also want to understand [what information is stored in a proprietary file format](https://hackernoon.com/reverse-engineering-visual-novels-101-d0bc3bf7ab8). Despite the sheer numbers of different file formats, all of them have one thing in common: they tell us where specific information is stored so a corresponding software will know where to parse for the relevant data. For example, image viewing software like Windows Photo Viewer will need to understand PNG file format so it knows where to retrieve the encoded image.

---
### *<p align='center'> section overview </p>*
---
* [ELF Files](ELF_Files.md)
  * [Overview](ELF_Files.md#-overview-)
  * [Linking VS Execution](ELF_Files.md#-linking-vs-execution-)
  * [ELF File Header](ELF_Files.md#-elf-file-header-)
  * [Program Header Table](ELF_Files.md#-program-header-table-)
  * [Section Header Table](ELF_Files.md#-section-header-table-)
  * [Useful Compilation Options To Know For GCC](ELF_Files.md#-useful-compilation-options-to-know-for-gcc-)
  * [Stripped Binary](ELF_Files.md#-stripped-binary-)
  * [Useful Tools To Analyze ELF Executable](ELF_Files.md#-useful-tools-to-analyze-elf-executable-)
* [PE Files](PE_Files.md)
  * [Overview](PE_Files.md#-overview-)
  * [PE File In Memory](PE_Files.md#-pe-file-in-memory-)
  * [Virtual Address(VA) To File Offset Translation](PE_Files.md#-virtual-addressva-to-file-offset-translation-)
  * [DOS Header](PE_Files.md#-dos-header-)
  * [PE Header (IMAGE_NT_HEADERS)](PE_Files.md#-pe-header-image_nt_headers-)
  * [Section Header Table (IMAGE_SECTION_HEADERs)](PE_Files.md#-section-header-table-image_section_headers-)
  * [Overlay](PE_Files.md#-overlay-)

---
### *<p align='center'> further readings </p>*
---
* [Corkami](https://github.com/corkami/pics/tree/master/binary): visualization of how various binary file formats are laid out
* [Kaitai Struct](http://kaitai.io/): a declarative language for visualizing binary file formats. Once you describes a file format in Kaitai Struct you can compile it into one of the supported languages. The compiled module will expose a straightforward API to access fields in that file format
* [Visual Reverse Engineering](https://www.youtube.com/watch?v=4bM3Gut1hIk): with binary visualization, it doesn't need to know how to parse the file format to provide useful information about the file that it's analyzing. Binary visualization not only can tells apart different file formats, it can also uncovers peculiarities within the same file format (e.g. packed vs not packed PE executable). [VELES](https://codisec.com/veles/) and [binvis](http://binvis.io/#/) are examples of popular free-to-use binary visualization tools

#
<strong><p align='center'><a href="/contents/languages/languages.md">.languages</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a> -> <a href="/contents/anti-analysis/anti-analysis.md">.anti-analysis</a></p></strong>
