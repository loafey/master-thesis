#import "../Prelude.typ": *
#import "figures.typ": *
#import "@preview/curryst:0.5.1": rule, prooftree

= System-Level Functional Language<slflChapter>


// System-Level Functional Language (SLFL) is meant to be an intermediate compilation target for linearly typed functional programming languages. Popular compilation targets today are LLVM, Cranelift, C, and compiling to assembly languages directly.
// Although the aforementioned alternatives are all viable, for a functional programming language several transformations have to be made. For instance, most functional programming languages have closures.

// SLFL consists of two fragments; positive and negative. The positive fragment describes how terms are created, while the negative fragment describes how terms are consumed.
// Two kinds, known size ($n,m$) and stack size $omega$.
// Continuation-passing style.

The intended use of SLFL is as a compiler intermediate representation for
functional languages, similar to that of GHC Core #todo[CITE GHC CORE]. 
SLFL diverges from most functional language intermediate representations in
that it prioritizes finer control over resources. This is achieved by departing
from the lambda calculus and its natural deduction root, rather taking
inspiration from linear types, which is based on Girard's linear logic.

In this section we will introduce the reader to SLFL.

== Grammar

Before going into details on SLFL it can be helpful to get an overview of how
the language looks. The grammar of SLFL is depicted in @slfl_grammar.

#figure(caption: [Grammar of SLFL], align(left, complete_grammar))<slfl_grammar>

We will start by showing an example, and then explain the grammar. 
The example will assume $A$ and $B$ are concrete types which are inhabited by the values $a$ and $b$ respectively.

$
& "swap" : *((B times.circle A) times.circle ~(A times.circle B)) \
& quad = lambda((x,y), k) -> k((y,x));\
\
& "main" : *~(A times.circle B) \
& quad = lambda k -> "swap"((b,a), k); $

A module consists of a list of definitions, where a definition is a top-level
function, akin to Haskell. A definition consists of a name, a type, and
a value. The distinction between values and commands is the most interesting
piece. Commands come into play in the bodies of lambdas, and commands are only
terminated by a function call ($z(v)$), which ensures that SLFL is written in
continuation-passing style.


== Continuation-passing Style
_Continuation-passing style_ (CPS) is a style where control is passed
explicitly via continuation functions rather than returning values. The
identity function written in normal style would be:

#align(
  center,
  $
    & id : forall a. a -> a\
    & id = lambda x. space x
  $,
)

contrast it to the CPS version, where we use $bot$ to denote a function that terminates with no value.

#align(
  center,
  $
    & id : forall a. space a -> (a -> bot) -> bot \
    & id = lambda x. lambda k. space k(n)
  $,
)

A natural question that comes to mind now is why we want continuation-passing
style? An immediate benefit of CPS is that every function call is a tail call,
which enables tail call optimization for every function call. Another benefit
is that the order of evaluation is made explicit. If we consider the following
program written in normal style:

#align(
  center,
  $"foo" = lambda x. & "let" y = "bar"(x) \ & "in" "let" z = "baz"(x) \ & "in" y + z$,
)

Is $y$ evaluted first or is $z$ evaluted first? The choice would be up to the
compiler. If we look at the same function in CPS we will see that the
evaluation order is determined by the order of the function calls.

#align(
  left,
  [

    $> lambda x. lambda k. & "bar"(x, lambda y. "baz"(x, lambda z. k(y+z)))$

    Here $"bar"(x)$ has to be evaluated first

    $> lambda x. lambda k. & "baz"(x, lambda z. "bar"(x, lambda y. k(y+z)))$

    And in this one $"baz"(x)$ has to be evaluted first
  ],
)
== Types & kinds

The types in SLFL roughly correspond to those of polarised linear logic. In
particular it corresponds to the positive fragment of polarised linear logic, see @PolarisedLinearLogic.
In addition to the positive fragment of polarised linear logic, SLFL also contain some other types and type constructors.

#let pll_types = {
  $A, B : : = & top | bot | x | not A | A times.circle B | A plus.circle B | exists x. A | \ 
  & circle | square A | *A | ~A
  $
}

#align(center,pll_types)

The first row are the types that correspond to the positive fragment of
polarised linear logic. In the second row are the types that are added on top
of polarised linear logic. The circle ($circle$), called _empty stack_ is
a primitive type added to SLFL. The box type constructor ($square$) represents
a pointer to a type. The last two are versions of negation ($not$). The meaning
of each type and why they are added over polarised linear logic will make sense
when we introduce kinds.

At the core of SLFL is the kind system. Where values have types, types have
kinds. The two kinds in SLFL are _stack-like_ ($omega$) and _known length_
($n,m$), and we use $alpha$ to denote a variables for kinds. The kinding rules in SLFL are given in @KindRules.

#figure(caption: [Kind rules in SLFL], align(center, kind_judgements(true)))<KindRules>

As for the others, they are more interesting. Starting off we can see that,
unsurprisingly, empty stack ($circle$) is stack-like. Stack-like product is akin to cons on lists.

For now, the three closure types ($not, ~, *$) can be considered as pieces of a puzzle to construct valid types. 
In @Transformations we will explain how they all relate to each other and why we need all three.

There is no subkinding in the language, meaning, if a type that is stack-like
is expected then a type with known length is not allowed and vice versa.

// We can now derive types following the kind rules. For instance, let
// us derive the types
// $A times.circle B times.circle ~C$ and $A times.circle (B plus.circle C) times.circle circle$
//
// #let tree = rule(
//   ($A times.circle B times.circle ~C: omega$),
//   prooftree(rule($A:n$, "")),
//   prooftree(
//     rule(
//       $B times.circle ~C: omega$,
//       rule($B: m$),
//       prooftree(rule($~C: omega$, prooftree(rule($C: k$)))),
//     ),
//   ),
// )
// #let tree2 = rule(
//   ($A times.circle (B plus.circle C) times.circle circle: omega$),
//   prooftree(rule($A:n$, "")),
//   prooftree(
//     rule(
//       $(B plus.circle C) times.circle circle: omega$,
//       prooftree(rule($B plus.circle C: max(m, k)$, $B: m$, $C: k$)),
//       prooftree(rule($circle: omega$)),
//     ),
//   ),
// )
// #grid(
//   columns: (1fr, 1fr),
//   inset: (top: 0.3cm, bottom: 0.3cm, right: -3pt, left: -3pt),
//   prooftree(tree), prooftree(tree2),
// )

// The $omega$ case of the product type ($times.circle$) can be interpreted as
// pushing its left operand on the right operand stack. The circle ($circle$) can
// be interpreted as being the empty stack, while $~A$ is a closure type that
// represents "the rest of the stack". $*A$ and $not A$ are also closure types,
// but since they construct type with kind $n$, they have no stack-like
// representation.
// This part will become clear when we give meaning to the types in their memory
// representation. #todo[Refer to section]

== Types & values<TypesAndValues>

SLFL consists of two fragments:

- _Positive fragment_ describes how things are created. When we talk about
  values we refer to the positive fragment.

- _Negative fragment_: describes how to deconstruct environments. We will refer to
  the negative fragment as _commands_

@positive_fragment contains the typing rules for the positive fragment of SLFL.
The positive fragment of SLFL is depicted in @positive_fragment

#figure(caption: [The positive fragment], positive(true)) <positive_fragment>

#figure(caption: [The negative fragment], negative(true)) <negative_fragment>

The juxtaposition of the negative and positive fragments create an elegant
picture. For every value $v$, a corresponding command exists for how to destruct
an environment that has $v$ #todo[is this even correct]. Variables can not be destructed, rather they are consumed
on use, following the rules of linear types.


== Transformations<Transformations>

At this stage SLFL is still a logic language. How do we bridge the gap between logic and machine?
This section goes into the necessary transformations to turn SLFL into machine code.


- Linear closure conversion
- Stack selection
- Pointer closure conversion

=== Linear closure converison

$(lambda^not x. c): not A => square (lambda^~ x. c): square (~A)$

$not$ is a source language construct only

After linear closure conversion we end up with:
$
  square lambda a. & "let" f,k = a; \
  &"let" square k' = k; \
  & k'(square lambda y. "let" square f' = f; f'(y))
$

After converting the type we end up with: $square ~(square ~ int times.circle square~square~int)$

//The astute reader will now realize that $not$ is a source language construct only. There is no compilation scheme that corresponds to it.


=== Stack Selection

In the final closure conversion step we make environments explicit and make
sure that each closure contains a stack to execute on. However, because of how
the linear closure conversion step works closures will never contain a stack.
Since all closures are boxed there are no stacks, remember #judge($A:omega$, $square A: 1$).
This can be observed in the example where we see that $f$ is unboxed inside the
closure. The solution is to move the unboxing of $f$ outside the inner closure:
$
  square lambda a. & "let" f,k = a; \
  &"let" square k' = k; \
  &"let" square f' = f; \
  & k'(square lambda y. f'(y))
$

Now the inner closure contains a stack.

//We need to make sure each term consists of zero or one stack for the pointer
//closure conversion step. If it contains zero stacks, then the environment of
//the closure will create one using the _newstack_ primitive.

=== Pointer Closure Conversion

The goal of this phase is to make the structure of stacks explicit, replacing
a stack closure by an explicit pair of static function pointer and environment.



