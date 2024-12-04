#import "Prelude.typ": *

= Goals and planning
In this chapter we will go into more detail about the extensions to SLFL. We will clarify what the extensions are and explain why they are wanted.
#todo[Make sure this text is accurate]

== Compilation
#todo[Add text about compilation]

== Language extensions
Currently the language is somewhat simple, and the following sections cover extensions
to the language we want to add. As SLFL follows a formal specification,
all of these new rules have to do so as well. For each new feature new typing
rules and new reduction rules will need to be introduced to extend the specification.

=== Closures
A common feature in modern languages are lambda functions (anonymous functions).
Closures are an extension of this allowing lambdas to capture variables from their
environment. 
```hs
add x = \y -> x + y 
``` 
Here the function `add` captures the variable `x` and returns a lambda
which returns the result of `x + y`.  

=== Records
While simple data types suffice in a lot of places, records provide important 
context to data types, allowing for labeled fields.

=== Recursive and contiguous data types 
When representing more complicated data types such as different types of trees or list
in functional programming, they are almost always implemented using recursive data types.
In theory this is fine, but in practice it leads to overhead such as pointer 
indirection, bad cache locality and more. Due to this we will also investigate adding 
statically or dynamically sized contiguous types, such as arrays or vectors.

=== Laziness
#red_text[A common want for functional languages is laziness.] 
Laziness, or commonly referred to as call-by-need, means that values
and expressions are evaluated only when they are used. We will explore if
this is a feasible addition for a system-level language, and how we will integrate this
with IO, where the order of execution is important.

/*
-   what to do?
  -   Translate each construction/typing rule into code
  -   if a construction cannot be translated this way: refine it
      (design a more low-level rule which serves in an intermediate
      compilation step.)
*/
