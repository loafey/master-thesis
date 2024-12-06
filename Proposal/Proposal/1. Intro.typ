#import "Prelude.typ": *

= Background

System-level programming is the act of developing software that interacts directly with a computer's
hardware, or providing foundational services to other software.
We define the system-level programming as follows:

- Programs can operate in resource-constrained environments
- Programs can be efficient with little runtime overhead, possibly
  having either a small runtime library or none at all
- Programs may use direct and \"raw\" control over memory access and
  control flow
- The programmer may write parts of the program directly in assembly
  language

For system-level programming today developers mostly choose between procedural
programming languages, for instance: C, C++, or Rust. In C memory is management
is manual, and in C++ there is are options for automatic memory management, but
the compile time guarantees are few and weak. Rust has mostly solved this issue
with the introduction of an ownership model and the borrow checker @matsakis2014rust.

Although Rust offers many functional aspects, many are still missing, for
instance; _purity_ and _referential transparency_. In this proposal we propose an alternative, a functional programming language: _System-level Functional Language_ (SLFL).


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
intuistionistic logic, where, rather than proposition being truth statements, they represent
_resources_, meaning propositions are objects that can be modified into other objects.
Linear logic models the problems of shared and mutable data, both of
which are of critical importance in system-level programming.

The plan of this thesis is to compile and extend the functional system-level language System-Level Functional Language (SLFL). The 
language is created by Jean-Philippe Bernardy, which in turn is based on Girard's linear logic.
SLFL is proposed as an alternative to system-level languages, as well as being
an intermediate compilation target for functional languages.
== Related work

The first paper to introduce is _Lilac: a functional programming language based on linear logic_ @lilac1994.
The paper gives an implementation of a type inference algorithm, similar in style to Milner's algorithm W @milner1978theory. 
Lilac also extends the lambda calculus with recursion and datatypes. 
However, the focus of Lilac is not how to compile efficient machine code.

Secondly, in _Efficient Implementation of a Linear Logic Programming Language_
@efficient1998 the authors give an implementation of a compiler for the linear
logic language Lolli. Although they provide a efficient compilation for the
language, it is inherently logic based, which SLFL is not.

The paper _A Type System for Bounded Space and Functional In-Place Update_
@hofmann2000 presents a way to compile a linearly typed first-order
functional language into `malloc()`-free `C` code into `malloc()`-free `C`
code. Again, however, does this not meet the criteria of SLFL as it is
a higher-order functional language.

In the master's thesis "Towards a practical execution model for functional
languages with linear types" @nordmark2024 Nordmark implements a virtual
machine for a linearly typed language. Unfortunately the virtual machine
language is untyped, and because SLFL is linearly typed, it can not be
utilized as an intermediate language for compiling to SLFL. As the goal is to
create efficient machine code, the virtual machine can not be a target language
either.

The goal of the thesis will be to complete the design of SLFL and create a compiler for the
language. The language specification will be extended as well, and those extensions will be
compiled.

/*
== Transition paragraph
The scope of the thesis includes creating a compiler for SLFL that utilizes
the linearity of the language, possibly extend SLFL with recursive data
types, records, and laziness. Unless typing rules for the aforementioned
extensions already exist, those will have to be formulated as well.
*/
