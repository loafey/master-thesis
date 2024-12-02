== System-level Functional Language (SLFL)
The point of our thesis will be to create a compiler for a SLFL

While the language is a system-level language, we want to add 
several higher level concepts such as:
- Closures
- Records
- Recursive Data Types
- Linear Data Types

== How will the language be evaluated?
Objectively evaluating languages is hard, but some things can be done!

- Performance: \
  Simple programs will be written in another system-level language (C etc)
  and SLFL\
  Programs will be compared based on execution time and memory usage

- Binary size: \
  A system-level language should ideally produce small binaries for portability\
  Our thesis will not focus a lot on this, but it is an interesting metric nonetheless 