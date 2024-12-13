#import "Prelude.typ": *

= Goals and planning
In this chapter we will go into more detail about the extensions to SLFL. We will clarify what the extensions are and explain why they are wanted.

== Compilation

The first goal of the project is to compile SLFL to native machine code.
We plan on doing this by compiling to LLVM @lattner2004llvm, which in turn can be compiled to native machine code.
LLVM provides a simple and efficient abstraction layer, compared to the native machine code alternatives. 
The Rust compiler and Clang, one of the C++ compilers, both compile to LLVM, demonstrating that LLVM is a reliable option.

== Language extensions
SLFL is currently incomplete, and this chapter will cover some of the
extensions that we consider extending the language with. SLFL will consist of
several intermedate compilation steps, each linearly typed. As such, for every
extension we make to the language, we must also create the corresponding typing
rules.

=== Exponentials
As briefly mentioned in @Motivation, variables in a linearly typed programming
language must be used exactly once. There is an exception to this rule, called exponentials.
Exponentials can be used to duplicate or drop values.
We currently consider two implementations:

- Implement exponentials using reference counting. This would then require recursive deallocation
  of any other exponentials used in the value.

- Limit exponentials to non-linear closures, where every value allocated in the closure is
  allocated using reference counting.

If neither of these solutions work out, time will be spent on creating an alternative, as 
exponentials are important for flexibility when writing code.

=== Recursive and contiguous data types 
When representing more complicated data types such as different types of trees or list
in functional programming, they are almost always implemented using recursive data types.
In theory this is fine, but in practice it leads to overhead, such as pointer 
indirection and poor cache locality. As such, we will investigate adding statically or dynamically sized contiguous data structures, such as arrays or vectors.

=== Laziness
Laziness, or commonly referred to as call-by-name, means that values and
expressions are evaluated only when they are used. 
Lazy evaluation is an effective tool for achieving modularisation @hughes1989. 

We will explore if lazy evaluation is a feasible addition for a linearly typed system-level language, as
well as investigate how this will interact with \
I/O, where the order of execution is important.
