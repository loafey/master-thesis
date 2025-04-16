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

There are a lot of different fitting choices for this task #lorem(10) 

=== Higher-Level Assembly Languages

=== x86-64