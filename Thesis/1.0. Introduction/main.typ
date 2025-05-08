#import "../Prelude.typ": indent, todo
#import "../Prelude.typ": ln

= Introduction
The concept of linearity in programming languages is not a newly discoverd one.
A language with linearity allows a developer to write software without the
worries of mismanaging things such as memory and files.
While there are benefits to linearity not many languages have opted to implement it.
This concept is most commonly found in functional programming, but one thing
functional languages commonly do not contain is system-level programming.

This thesis introduces a new language, #ln, which tries to fill this void,
by introducing a system-level functional programming language.


== Background
System-level programming is the act of developing software that interacts directly with a computer's
hardware, or providing foundational services to other software.
We will define system-level programming as Wikipedia @wiki:Systems_programming defines it:
#indent(10)[
  - Programs can operate in resource-constrained environments
  - Programs can be efficient with little runtime overhead, possibly
    having either a small runtime library or none at all
  - Programs may use direct and \"raw\" control over memory access and
    control flow
  - The programmer may write parts of the program directly in assembly
    language
]

For system-level programming today developers mostly choose between procedural
programming languages, for instance: C, C++, or Rust. In C memory management
is manual, and in C++ there are options for automatic memory management, but
the compile time guarantees are few and weak. Rust has mostly solved the issue of
memory management with the introduction of an ownership model and a borrow checker @matsakis2014rust.

Although Rust offers many functional aspects, many are still missing, for
instance; _purity_ and _referential transparency_. We propose
an alternative that addresses these points, the programming language: #ln.

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

Girard's linear logic @girard1987linear is a refinement of classical and
intuitionistic logic, where, rather than propositions being truth statements, they represent
_resources_, meaning propositions are objects that can be modified into other objects.
Linear logic models the problems of shared and mutable data, both of
which are of critical importance in system-level programming.
In linear logic, the uses of weakening and contraction are carefully controlled, which in
a programming language setting means variables must be used exactly once.

This thesis describes System-level functional language, the compilation scheme
for #ln, and the implementation of the compiler.
