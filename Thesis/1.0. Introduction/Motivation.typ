#import "../Prelude.typ": *

== Motivation
Functional programming tends to emphasize _referential transparency_, _higher-order
functions_, _algebraic type systems_, and _strong type systems_.
Although the merits of functional programming are evident @hughes1989, it is under
represented for system-level programming. The reason functional languages are
not used in system-level programming is the lack of predictable performance.
Unpredictable performance can be traced back the use of
_immutable_ data structures, as opposed to _mutable_ data structures. The
former requires copying, and subsequently a form of automatic memory
management, at least for convenience, whereas the latter can be modified in place.

#ln makes use of linear logic to introduce mutable data structures in the
context of functional programming languages.
Girard's linear logic @girard1987linear is a refinement of classical and
intuitionistic logic, where, rather than propositions being truth statements, they represent
_resources_, meaning propositions are objects that can be modified into other objects.
Linear logic models the problems of shared and mutable data, both of
which are of critical importance in system-level programming.
In linear logic, the uses of weakening and contraction are carefully controlled, which in
a programming language setting means variables must be used exactly once.

This thesis describes #ln, the compilation scheme
for #ln, and the implementation and specification of the compiler.
