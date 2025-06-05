#import "../Prelude.typ": *
= Conclusion
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


#pagebreak()
