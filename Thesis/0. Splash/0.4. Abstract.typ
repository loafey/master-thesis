#import "../Prelude.typ": *
#heading(numbering: none, outlined: false, [Abstract])
// This thesis presents the design, compilation, ABI, and logic behind the language #ln.
// The language aims to fill the hole created by the lack of
// functional system-level, linear, and intermediate representation languages.
// #ln tries to combine all of these concepts into one coherent experience.
//
// The language is based on the theory of linear logic and lambda calculus, and
// exclusively uses continuation passing style. The implementation presented in
// this paper is compiled to x86-64.

Functional programming has a rich and studied history. In functional programming, large problems can be
described by the composition of smaller building blocks. Despite the benefits
of functional programming it has struggled to find its way into system-level programming.

Linear logic, and in turn linear type systems impose the restriction that
variables must be used exactly once. By leveraging this restriction, functional
programming languages can be used in system-level programming without sacrificing performance.

This thesis presents #ln, a system-level functional programming language that
leverages polarised linear logic, a variant of linear logic. We describe
a series of transformations to turn #ln into a language that is assembly code
compatible. Additionally, we present a compilation scheme, a mapping from types
to memory, and an application binary interface (ABI).
