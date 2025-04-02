= Introduction

#text(red)[
== Background
System-level programming is the act of developing software that interacts directly with a computer's
hardware, or providing foundational services to other software.
We will define system-level programming as Wikipedia @wiki:Systems_programming defines it:
#grid(
  columns: (10pt, 1fr),
  rect(height: 100pt, fill: tiling(size: (12pt, 10pt), [
    #place(line(stroke: rgb(0,0,0,65),start: (0%, 0%), end: (100%, 100%)))
    #place(line(stroke: rgb(0,0,0,65),start: (0%, 100%), end: (100%, 0%)))
  ])),
[
- Programs can operate in resource-constrained environments
- Programs can be efficient with little runtime overhead, possibly
  having either a small runtime library or none at all
- Programs may use direct and \"raw\" control over memory access and
  control flow
- The programmer may write parts of the program directly in assembly
  language 
], inset: (left: 16pt))

For system-level programming today developers mostly choose between procedural
programming languages, for instance: C, C++, or Rust. In C memory management
is manual, and in C++ there are options for automatic memory management, but
the compile time guarantees are few and weak. Rust has mostly solved the issue of
memory management with the introduction of an ownership model and a borrow checker @matsakis2014rust.

Although Rust offers many functional aspects, many are still missing, for
instance; _purity_ and _referential transparency_. We propose
an alternative that addresses these points, the programming language: _System-level Functional
Language_ (SLFL).

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

The plan of our thesis is to compile and extend System-Level Functional Language. The 
language is created by Jean-Philippe Bernardy, which in turn is based on Girard's linear logic.
SLFL is proposed as an alternative to system-level languages, as well as being
an intermediate compilation target for functional languages.
]
