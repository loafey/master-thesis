#import "Prelude.typ": *

= Background
== System-level programming
System-level programming is the act of developing software that interacts directly with a computer's
hardware, or providing foundational services to other software.
The following are some properties of system-level programming as defined on Wikipedia:

- Programs can operate in resource-constrained environments
- Programs can be efficient with little runtime overhead, possibly
  having either a small runtime library or none at all
- Programs may use direct and \"raw\" control over memory access and
  control flow
- The programmer may write parts of the program directly in assembly
  language

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


== Pre-existing work in the literature
#todo[Introduce the pre-existing work]
- Lilac: a functional programming language based on linear logic @lilac1994

- Linear Haskell: practical linearity in a higher-order polymorphic language @linearhaskell2017

- Efficient Implementation of a Linear Logic Programming Language @efficient1998

- A type system for bounded space and functional in-place update @hofmann2000

- Efficient Functional Program ming using Linear Types: The Array Fragment @juan2015efficient

== Pre-existing work in the group
System-Level Functional Language (SLFL) is a
language based on Girard's linear logic #todo[Should PLL be referenced here too?] created by Jean-Philippe Bernardy #todo[correct?].
SLFL is proposed as an alternative to system-level languages, as well as being
an intermediate compilation target for functional languages.

In the master's thesis "Towards a practical execution model for functional
languages with linear types" @nordmark2024 Nordmark implements a virtual
machine for a linearly typed language. Unfortunately the virtual machine
language is untyped, and because SLFL is linearly typed, it can not be
utilized as an intermediate language for compiling to SLFL. As the goal is to
create efficient machine code, the virtual machine can not be a target language
either.

The goal of the thesis will be to complete the design of SLFL and create a compiler for the
language. The language will be extended as well, and the extensions will be
compiled.

/*
== Transition paragraph
The scope of the thesis includes creating a compiler for SLFL that utilizes
the linearity of the language, possibly extend SLFL with recursive data
types, records, and laziness. Unless typing rules for the aforementioned
extensions already exist, those will have to be formulated as well.
*/
