#import "../Prelude.typ": *
= Discussion

#include "Future Work.typ"

== Conclusion
The goal of this thesis was to present a system-level functional language
with linear types. The language, #ln, currently does not implement
all the requirements we set out in @Background, specifically:
#indent(
  6,
  [
    - Programs may use direct and "raw" control over memory access and control flow
    - The programmer may write parts of the program directly in assembly language
  ],
)
#ln currently does expose many primitives for interacting with the the memory
