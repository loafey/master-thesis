#import "../Prelude.typ": indent, todo
#import "../Prelude.typ": ln

= Introduction
Static anaysis tools and systems have seen use in several compilers and
programming languages. By relying on such tools and systems, programmers can
ensure safety, performance, and also express intent. 
In this thesis we leverage the system of linear types for all three purposes.

The concept of linearity in programming languages is not a newly discovered one.
A language with linearity allows a developer to write software without the
worries of mismanaging things such as memory and files.
While there are benefits to linearity, not many languages have opted to implement it.
This concept is most commonly found in functional programming, but one thing
functional languages commonly do not support is system-level programming.

This thesis introduces a new system-level functional programming language, #ln,
which tries to fill this void.


#include "Background.typ"

#include "Motivation.typ"

#include "Related Work.typ"
