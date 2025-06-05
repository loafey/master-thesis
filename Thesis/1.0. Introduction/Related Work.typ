#import "../Prelude.typ": *

== Related Work
// _Lilac: a functional programming language based
// on linear logic_ @lilac1994, gives an implementation of a type
// inference algorithm, similar in style to Milner's algorithm
// W @milner1978theory. Lilac also extends the lambda calculus with recursion and
// datatypes. However, the focus of Lilac is not how to compile efficient machine
// code.

// Secondly, in _Efficient Implementation of a Linear Logic Programming Language_
// @efficient1998 the authors give an implementation of a compiler for the linear
// logic language Lolli. Although they provide a efficient compilation for the
// language, it is a logic programming language, which SLFL is not.

// The paper _A Type System for Bounded Space and Functional In-Place Update_
// @hofmann2000 presents a way to compile a linearly typed first-order>l is to
// create efficient machine code, the virtual machine can not be a target language
// either.

A lot of research has gone into researching linear logic, and linear logic in
programming languages. Not much research has been done in actually
implementing functional system-level linear languages.

In the previous year (2024), Nordmark wrote his
master's thesis "Towards a practical execution model for functional
languages with linear types" @nordmark2024.
This work can be seen as a sort of predecessor of the work presented in this thesis,
and is similar in nature to his thesis. Nordmark compiled a language similar to #ln to
an untyped byte code, which ran in a custom virtual machine. Even though using
a virtual machine is a suitable first step, we deem that this is not low-level
enough for a system-level language.
