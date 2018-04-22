### <a href="/contents/anti-analysis/Anti-Emulation.md"><-</a> [.encodings](encodings.md)[__String Encoding__] <a href="Data_Encoding.md">-></a>

---
#### *<p align='center'> ASCII </p>*
---
* String encoding that maps a byte to an English character, a special character, or a number
  * [ASCII Table](http://www.asciitable.com/)
  * Out of the 128 characters defined in ASCII, only 95 of them are human-readable
  * ASCII used 7 bits only, but the extra bit is still not enough to encode all the other languages
* __Line Terminator__: encoded character sequence that represents end of line
  * On DOS/Windows it's "\r\n" whereas on Linux it's "\n"
  * "\r" is carriage return (0x0D) 
  * "\n" is line feed or new line (0x0A)

---
#### *<p align='center'> Unicode </p>*
---
* Various encoding schemes were invented but none covered every languages until Unicode came along
  * [Unicode Character Table](https://unicode-table.com/en/#control-character)
  * Unicode is a large table mapping every character to a unique numbers (code point) 
  * First 256 code points maps 1:1 to ASCII  
  * Different UTF encodings (e.g. UTF-8, UTF-16) use different amount of bytes to encode those code points

---
#### *<p align='center'> Cause Of Garbled Text </p>*
---
* Reading a byte sequence using the wrong encoding scheme

#
<strong><p align='center'><a href="/contents/anti-analysis/Anti-Emulation.md">Anti-Emulation</a> <- <a href="/README.md#-reverse-engineering-reference-manual-beta-">RERM</a>[<a href="encodings.md">.encodings</a>] -> <a href="Data_Encoding.md">Data Encoding</a></p></strong>
