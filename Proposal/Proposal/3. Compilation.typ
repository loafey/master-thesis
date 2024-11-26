= Compilation
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