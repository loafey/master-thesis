#import "Prelude.typ": *

= Background

This chapter introduces the background needed to understand SLFL.

== Logic
This section will introduce the reader to logic and its connection to computation in the form of functional programming through the Curry-Howard correspondence.

Logic is a formal system that uses reason to deduce truths. There are several proof systems where logic can be expressed. To prove $A$ and $B$, one has to prove $A$ and independently prove $B$. In natural deduction, this can be expressed with the following proof tree. 
$ (A quad B)/(A and B) $

This reads as: given a proof of $A$ and a proof of $B$, we can prove $A$ and $B$.
The deductions above the line lead to the conclusion below the line.
The relation with computation comes from the Curry-Howard correspondence where Curry observed that the types of combinators could be seen as axiom-schemes in intuitionistic logic @curry1934functionality. Many years later Howard made the observation that intuitionistic logic in natural deduction could be interpreted as a typed variant of the lambda calculus. The Curry-Howard correspondence is also aptly known as the proofs-as-programs and propositions-as-types interpretation.

=== Natural deduction

=== Sequent calculus

=== Linear logic

== Continuations
A design pattern in functional programming is Continuation Passing Style.
In this design pattern, instead of functions returning, they take an extra argument which
is a function which will operate on the resulting value. 
SLFL makes heavy use of this pattern, in fact, it requires it for all functions.
This might sound like a problem, but in fact functional programs can be easily converted
into this design pattern #todo("source here"), and in addition, this comes with benefits, such
as allowing for easy tail call optimization as we never need to return to a previous 
stack frame #todo("source here").

== Memory

== Compilation Targets
Unless you are directly targeting binary machine code, most of the time
you want a more higher level compilation target to compile your language to.

There are a lot of different fitting choices for this task and some of the more 
commons ones are for example LLVM IR#todo("source"), Cranelift #todo("source") and GNU's 
GENERIC and GIMPLE #todo[source]. These languages are what is known as 
intermediate representations (IR), and are all targeted by different compilers.
They remove the need for the compilers to directly target
specific machine code or CPU assembly themselves.
Most of the time these IRs are also cross platform, automatically giving compilers
portability if need be. 
As these languages are higher level compared to an assembly language,
it of course comes with the cost of removing some control. 
A lot of these are however modelled for imperative language, and expect
the source language to follow the traditional stack frame approach which
might not be convenient for a continuation based language.
For these case, it might be nicer to target an assembly language directly instead.

When you #todo[you] directly target an assembly language portability suffers as is to 
be expected. You not only have to target different assembly languages
for different CPU architectures, you will also have to cater to the operating system
you are targeting. For instance, on a \*nix operating system, you can almost
always rely upon some implemention of LIBC, be it GLIBC or musl, 
or system calls if more power is needed, while on Windows you have to instead
depend on the provided libraries to interact with the rest of the system.
A simple act such as printing might look wildly different 
depending on the operating system because even though they might use the same
assembly language, they can involve extremely different calls to the operating system.
#todo[detta gäller även många IR språk. LLVM IR har tex samma problem]

=== Higher-Level Assembly Languages

=== x86-64