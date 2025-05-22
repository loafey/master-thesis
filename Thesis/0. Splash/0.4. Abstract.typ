#import "../Prelude.typ": *
#heading(numbering: none, outlined: false, [Abstract])
This thesis presents the design, compilation, ABI, and logic behind the language #ln.
The language aims to fill the hole created by the lack of
functional system-level, linear, and intermediate representation languages.
#ln tries to combine all of these concepts into one coherent experience.

The language is based on the theory of Polarized Linear Logic and lambda calculus,
and exclusively uses continuation passing style. In it's current state the language
is fairly limited, but enough work has been done so that future work on it
can expand upon it. The implementation presented in this paper is compiled to x86-64.
