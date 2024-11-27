#import "Prelude.typ": *

= Goal
#green_text[
  The goal of this thesis is to extend the language of SLFL, as well as
  building a compiler for it. At the time of writing we are considering adding
  the following features to the language:
  - exponentials
  - records
  - recursive data types
  - laziness
]

For the compilation part we preliminary want to compile the language to LLVM @lattner2004llvm.
Time will be spent on investigating if LLVM is a good compilation target, and if not, other
low level targets such as x86-64 assembly will be considered.

#block(width: 100%, stroke: red, inset: 10pt)[
-   how it differs from previous work (Nordmark)
  -   Nordmark has a special purpose VM.
  -   using Nordmark\'s VM as an intermediate language goes against
      Principle 1.
-   what to do?
  -   Translate each construction/typing rule into code
  -   if a construction cannot be translated this way: refine it
      (design a more low-level rule which serves in an intermediate
      compilation step.)
]