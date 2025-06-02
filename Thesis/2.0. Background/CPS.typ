#import "../Prelude.typ": *
== Continuation-passing Style <cps>
_Continuation-passing style_ (CPS) is a style where control is passed
explicitly via continuation functions rather than returning values.
Intuitively, we can think of continuations as functions that capture "the rest
of the program".

Continuations have seen successful use in many compilers for strict languages,
for example by:
Appel @appel2007compiling, Fradet and Métayer @fradet1991compilation,
and Kelsey and Hudak @kelsey1989realistic.
Additionally, in the Spineless Tagless G-Machine, the abstract
machine of the Glasgow Haskell Compiler (GHC), continuations are used to manage thunks, function
application, and case analysis.

Continuation-passing style is easiest explained by example.
The identity function written in normal style would be:

#align(
  center,
  $
    & id : forall a. a -> a\
    & id = lambda x. space x
  $,
)

Contrast it to the CPS version, where we use $a -> bot$ to denote a function that takes $a$ as argument and terminates with no value.

#align(
  center,
  $
    & id : forall a. space a -> (a -> bot) -> bot \
    & id = lambda x. lambda k. space k(n)
  $,
)


A natural question that comes to mind is why we want continuation-passing
style? An immediate benefit of CPS is that every function call is a tail call,
which ensures that tail call optimization (see @CompilingCompilationTarget) is
always possible. Another benefit of CPS is that the order of evaluation is made
explicit by the syntax. If we consider the following program written in normal
style:

#align(
  center,
  $& "let" y = "bar"(x) "in" \ & "let" z = "baz"(x) "in" \ & y + z$,
)

Is $y$ evaluated first or is $z$ evaluated first? The choice would be up to the
specification. If we take at the same function in CPS we will see that the
evaluation order is determined by the order of the function calls.

#align(
  left,
  [

    + $"bar"(x, lambda y. "foo"(x, lambda z. k(y+z)))$
    + $"foo"(x, lambda z. "bar"(x, lambda y. k(y+z)))$

    In the first one, because the second argument of bar is in normal-form
    #footnote[A term is in normal-form if it cannot be evaluated any further],
    the only possible execution order is to evaluate $"bar"(x,...)$.
    Conversely, in the second one $"foo"(x,...)$ has to be evaluated first, for the same reason.
  ],
)
