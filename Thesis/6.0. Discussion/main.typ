#import "../Prelude.typ": *
= Discussion

#include "Future Work.typ"
#pagebreak()
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
#ln currently not does expose many primitives for interacting with the the memory
nor does it expose any way to write assembly. The later could probably
be skipped and it could likely suffice to implement FFI
and adding syntax for system calls.

The compiler so far adheres to the specification presented
in this thesis, at least at the time of writing. As previously mentioned
the ABI might be changed in the future, for example if the calling convention
is optimized.

We did not have time to implement everything we wanted in the compiler,
as outlined in @FutureWork, nor have they been specified in the ABI.
We have however implemented a base which can
be further extended upon to implement these missing features.

// so long bowser

#pagebreak()
