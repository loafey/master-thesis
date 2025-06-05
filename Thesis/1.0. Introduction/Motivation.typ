#import "../Prelude.typ": *

== Motivation
Functional programming tends to emphasize _referential transparency_, _higher-order
functions_, _algebraic type systems_, and _strong type systems_.
Although the merits of functional programming are evident @hughes1989, it is under
represented for system-level programming. 
Functional languages are rarely used in system-level programming due to their
lack of predictable performance
The lack of predictable performance can be traced back the use of
_immutable_ data structures, as opposed to _mutable_ data structures. The
former requires copying, and subsequently a form of automatic memory
management, at least for convenience, whereas the latter can be modified in place.

A popular and effective optimization for functional languages is _fusion_
@gill1993short. Fusion aims to remove intermediate data structures, improving
performance and reducing memory usage. However, it can be difficult to predict
whether fusion is effective for arbitrary compositions. Linear types provide
a framework for fusion where, rather than letting a compiler decide
heuristically whether fusion ends up duplicating or sharing work, it is
specified by the types of the composed functions @bernardy2016composable.

Girard's linear logic @girard1987linear
is a refinement of classical and intuitionistic logic, where, rather than
propositions being truth statements, they represent _resources_, meaning
propositions are objects that can be modified into other objects. Linear logic
models the problems of shared and mutable data, both of which are of critical
importance in system-level programming. In linear logic, the uses of weakening
and contraction are carefully controlled, which in a programming language
setting means variables must be used exactly once.
Because the use of resources is carefully controlled, mutable data structures can be used in a safe way.

The goal for #ln is not only to be used as a system-level level language, but
also as an intermediate compilation target for (linear) functional programming
languages.
