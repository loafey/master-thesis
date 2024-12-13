#import "Prelude.typ": *

= Background

System-level programming is the act of developing software that interacts directly with a computer's
hardware, or providing foundational services to other software.
We will define system-level programming as Wikipedia @wiki:Systems_programming defines it:
#grid(
  columns: (10pt, 1fr),
  rect(height: 100pt, fill: pattern(size: (12pt, 10pt), [
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


== Motivation <Motivation>

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
intuistionistic logic, where, rather than propositions being truth statements, they represent
_resources_, meaning propositions are objects that can be modified into other objects.
Linear logic models the problems of shared and mutable data, both of
which are of critical importance in system-level programming. 
In linear logic uses of weakening and contraction are carefully controlled, which in
a programming language setting means variables must be used exactly once.

The plan of our thesis is to compile and extend System-Level Functional Language. The 
language is created by Jean-Philippe Bernardy, which in turn is based on Girard's linear logic.
SLFL is proposed as an alternative to system-level languages, as well as being
an intermediate compilation target for functional languages.

== Related work

_Lilac: a functional programming language based
on linear logic_ @lilac1994, gives an implementation of a type
inference algorithm, similar in style to Milner's algorithm
W @milner1978theory. Lilac also extends the lambda calculus with recursion and
datatypes. However, the focus of Lilac is not how to compile efficient machine
code.

Secondly, in _Efficient Implementation of a Linear Logic Programming Language_
@efficient1998 the authors give an implementation of a compiler for the linear
logic language Lolli. Although they provide a efficient compilation for the
language, it is a logic programming language, which SLFL is not.

The paper _A Type System for Bounded Space and Functional In-Place Update_
@hofmann2000 presents a way to compile a linearly typed first-order
functional language into `malloc()`-free `C` code into `malloc()`-free `C`
code. Again, however, this is not satisfactory as we want SLFL to be a higher-order language.

In the master's thesis "Towards a practical execution model for functional
languages with linear types" @nordmark2024 Nordmark implements a virtual
machine for a linearly typed language. Unfortunately the virtual machine
language is untyped, and because SLFL is linearly typed, it can not be
utilized as an intermediate language for compiling to SLFL. As the goal is to
create efficient machine code, the virtual machine can not be a target language
either.

The goal of our thesis will be to complete the design of SLFL and create a compiler for the
language. The language specification will be extended as well, and those extensions will be
compiled.

/*
== Transition paragraph
The scope of the thesis includes creating a compiler for SLFL that utilizes
the linearity of the language, possibly extend SLFL with recursive data
types, records, and laziness. Unless typing rules for the aforementioned
extensions already exist, those will have to be formulated as well.
*/
