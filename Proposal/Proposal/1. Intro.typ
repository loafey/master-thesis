#import "@preview/dashy-todo:0.0.1": todo

= Background
== System-level programming
One of the most important sectors in programming is system-level programming.
If you are developing for a constrained environment, such as one with a slower CPU
or lower memory, or just need to squeeze out every inch of performance you can, 
system-level programming is a good fit. #todo[kinda shit sentence bruv]

As per Wikipedia#todo[kinda cringe] a system level language fulfills the following: 
#block(width: 100%, stroke: red, inset: 10pt)[
-   Programs can operate in resource-constrained environments
-   Programs can be efficient with little runtime overhead, possibly
    having either a small runtime library or none at all
-   Programs may use direct and \"raw\" control over memory access and
    control flow
-   The programmer may write parts of the program directly in assembly
    language
];

When doing system-level and flexibility is key, but many pre-existing ones lacking
one of the following: #todo[shite]
- referential transparency
- higher-order functions
- algebraic datatypes
- strong type systems
The reader might recognize that these are important tenets of functional programming,
a rare paradigm when it comes to system-level programming. #todo[source: my ass] 

== Motivation (why is SLFL interesting)
#block(width: 100%, stroke: red, inset: 10pt)[
-   Principle 1: most of the compiliation steps are done within a typed
    (logic-inspired) language

Compared to usual functional languages, a key advantage of such a
language is that the programmer will be able to precisely control the
low-level behaviour of programs.

-   Parts of the program (perhaps just type annotations) can be written
    in SLFL for control, while most of the program can be written in the
    higher level language
]

== Pre-existing work in the literature
#block(width: 100%, stroke: red, inset: 10pt)[
TODO \[citations\]
]

== Pre-existing work in the group
#block(width: 100%, stroke: red, inset: 10pt)[
-   previous work by nordmark
-   stub design/compiler by supervisor
]

== Transition paragraph
#block(width: 100%, stroke: red, inset: 10pt)[
-   What is in the scope for this thesis, more precisely
]