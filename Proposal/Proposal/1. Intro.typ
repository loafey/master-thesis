= Background
== System-level programming
#block(width: 100%, stroke: red, inset: 10pt)[
  Wikipedia:

-   Programs can operate in resource-constrained environments
-   Programs can be efficient with little runtime overhead, possibly
    having either a small runtime library or none at all
-   Programs may use direct and \"raw\" control over memory access and
    control flow
-   The programmer may write parts of the program directly in assembly
    language
];

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