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

== Motivation #red_text[(why is SLFL interesting)]
There are advantages to functional programming @hughes1989. Functional
programming tends to emphasize _referential transparency_, _higher-order
functions_, _algebraic type systems_, and _strong type systems_.
Although the merits of functional programming are evident, it is under
represented in system-level programming. The reason functional languages are
not used in system-level programming is the lack of predictable performance.
This lack of predictable performance is frequently traced back to the use of
_immutable_ data structures, as opposed to _mutable_ data structures. The
former requires copying, and subsequently a form of automatic memory
management, at least for convenience, whereas the latter can be modified in place.

Girard's linear logic @girard1987linear is a refinement of classical and
intuistionistic logic, where, rather than proposition being truth statements, they represent
_resources_, meaning propositions are objects that can be modified into other objects.
Linear logic models the problems of shared and mutable data, both of
which are of critical importance in system-level programming, as well as 
alleviating the need of a garbage collector.

#green_text[
  System-Level Functional Language (SLFL) is a language based on Girard's linear #todo[Should PLL be referenced here too?]
  logic. SLFL is proposed as an alternative to system-level languages, as
  well as being an intermediate compilation target for higher-level functional
  languages.
  The main purpose of this thesis would be to create a compiler for SLFL, as well as extending 
  the language to fit the requirements of system-level language.
]

/*
    #red_text[
    One of the reason why functional languages are not frequently used in system-level
    programming is memory control. Most functional languages lack direct control and instead
    feature garbage collection#todo[source: my ass]. While garbage collectors make
    development easier by removing the need to reason about memory management,
    runtime time suffers depending on the type of garbage collector. #todo[expand]
    Manual management ala C, is not preferred either, due to it being easy to introduce
    bugs such as use after free, dangling pointers etc. A middle ground here
    would be using linear types. Linear types lets us constrain values to only being used
    once and _have_ to be used. Informally speaking, forcing all values to be used removes
    the need for garbage collection as we simply free a values memory when we use that value.



    #block(width: 100%, stroke: red, inset: 10pt)[
      - Principle 1: most of the compiliation steps are done within a typed
        (logic-inspired) language

      Compared to usual functional languages, a key advantage of such a
      language is that the programmer will be able to precisely control the
      low-level behaviour of programs.

      - Parts of the program (perhaps just type annotations) can be written
        in SLFL for control, while most of the program can be written in the
        higher level language
    ]
    ]

*/

== Pre-existing work in the literature
#block(width: 100%, stroke: red, inset: 10pt)[
  TODO \[citations\]
]

== Pre-existing work in the group
#block(width: 100%, stroke: red, inset: 10pt)[
  - previous work by nordmark
  - stub design/compiler by supervisor
]

== Transition paragraph
#block(width: 100%, stroke: red, inset: 10pt)[
  - What is in the scope for this thesis, more precisely
]
