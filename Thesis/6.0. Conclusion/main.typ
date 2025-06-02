#import "../Prelude.typ": *
= Conclusion

#bigTodo[rewrite]

#text(fill: green)[
  This thesis presented the system-level functional programming language #ln. #ln
  takes advantage of linear types to provide a safe and reliable intermediate language. 
  By applying a series of transformations to #ln, the language is made assembly
  compatible. The transformations turn higher-order closure and procedures into
  labels and jump, with environments being translated into stacks, and pointers
  to stacks are made explicit.

  The thesis continued by providing a compilation scheme that turns the lowered language into a set
  of pseudo assembly instructions, which in turn were easily translated into assembly language.
  Additionally, the thesis presented the application binary interface (ABI) for interoperability.
  The chapter detailed the pre-conditions for function calls and how memory is structured.

  Finally, the thesis ended by presenting an example of a program written
  in #ln, a simple benchmark for context, and several future extensions
  and optimizations to refine and improve the language.
]

Throughout the thesis the language #ln has been presented,
and how #ln is transformed from a higher level linearly typed functional language
into assembly code.

#ln so long wow

The transforms turn higher-order closures and procedures into labels and jumps, with their environments
being translated into stack pointers, and explicit environments.
The last translation into assembly code is specified using a compilation scheme,
which matches the specified language ABI and so does the values it allocates and works upon.

We have also demonstrated that it is possible to utilize the language to write programs in
its current state.
While we did not have time to implement everything, several ideas have been presented which
would improve the language. A good base for the language
has been produced, and we hope to see further exploration with #ln.
We also wish to see it be used as a compilation target for another linear functional
programming language.

// Lithium\
// 3.1. Grammar\
// 3.2. Kinds & types\
// 3.3. Types & values\
// Compiling Lithium\
// 4.1. Transformations\
// 4.1.1. Linear closure conversion\
// 4.1.2. Stack Selection\
// 4.1.3. Pointer Closure Conversion\
// 4.2. Compilation Scheme\
// 4.3. Compilation Target\
// 4.4. Language ABI\
// 4.4.1. Function calls\
// 4.4.2. Mapping types to memory\
// 4.4.3. Memory alignment\
// Discussion\
// 5.1. Usage\
// 5.1.1. Benchmarks\
// 5.2. Future Work\
// 5.2.1. Compiler interface for creating stacks\
// 5.2.2. Register allocation\
// 5.2.3. System Calls\
// 5.2.4. Foreign Function Interface\
// 5.2.5. Exponentials\
// 5.2.6. Data Types\
// 5.2.7. Using Lithium as a compilation target


// so long gey bowser

#pagebreak()
