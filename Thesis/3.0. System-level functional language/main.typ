#import "../Prelude.typ": *
#import "figures.typ": *
#import "@preview/curryst:0.5.1": rule, prooftree

= #ln <SlflChapter>

The intended use of #ln is as a compiler intermediate representation for
functional languages, similar to that of GHC Core. #todo[CITE GHC CORE]
#ln diverges from most functional language intermediate representations in
that it prioritizes finer control over resources. This is achieved by departing
from the lambda calculus and its natural deduction root, rather taking
inspiration from linear types, which is based on Girard's linear logic.

An important aspect of a system-level language is the representation of types
and values. We want the language to be efficient, and thus, the representation
must match the computer's representation of memory. For instance, in many
functional programming languages values are boxed, i.e, placed behind pointers.
In a system-level language this would be counter-productive because the control
over memory should be in the hands of the developer.

== Grammar

Before going into details on #ln it can be helpful to get an overview of how
the language looks. The grammar of #ln is depicted in @slfl_grammar.

#figure(caption: [Grammar of #ln], align(left, complete_grammar))<slfl_grammar>

We will start by showing an example, and then explain the grammar.
The example will assume $A$ and $B$ are concrete types which are inhabited by the values $a$ and $b$ respectively.

$
  & "swap" : *((B times.circle A) times.circle ~(A times.circle B)) \
  & quad = lambda((x,y), k) -> k((y,x));\
  \
  & "main" : *~(A times.circle B) \
  & quad = lambda k -> "swap"((b,a), k);
$

A module consists of a list of definitions, where a definition is a top-level
function. A definition consists of a name, a type, and
a value. The distinction between values and commands is the most interesting
piece. Commands come into play in the bodies of lambdas. Commands consist of
let-bindings, case-expressons, or function calls. Notably, the only way to
terminate a chain of commands is by a function call ($z(v)$), which ensures
that #ln is written in continuation-passing style.


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

Contrast it to the CPS version, where we use $bot$ to denote a function that terminates with no value.

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
is that the order of evaluation is made explicit by the syntax.
If we consider the following program written in normal style:

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

== Kinds & types

The types in #ln roughly correspond to those of polarised linear logic.

#let pll_types = {
  $A, B : : = & top | bot | x | not A | A times.circle B | A plus.circle B | exists x. A | \
  & circle | square A | *A | ~A$
}

#align(center, pll_types)

The first row are the types that correspond to polarised linear logic. In the second row are the types that are added on top
of polarised linear logic. The circle ($circle$), called _empty stack_ is
a primitive type added to #ln. The box type constructor ($square$) represents
a pointer to a type. The last two are versions of negation ($not$) #todo[förklara lite mer här]. The meaning
of each type and why they are added over polarised linear logic will make sense
when we introduce kinds.

At the core of #ln is the kind system. Where values have types, types have
kinds. The two kinds in #ln are _stack-like_ ($omega$) and _known length_
($known$). The kinding rules in #ln are given in @KindRules.

#figure(caption: [Kinding rules in #ln], align(center, kind_judgements(true)))<KindRules>

As for the others, they are more interesting. Starting off we can see that,
unsurprisingly, empty stack ($circle$) is stack-like. Stack-like product is akin to cons on lists.

For now, the three closure types ($not, ~, *$) can be considered as pieces of a puzzle to construct valid types.
In @Transformations we will explain how they all relate to each other and why we need all three.

There is no subkinding in the language; if a type that is stack-like
is expected, then a type with known length is not allowed, and vice versa.

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

#ln consists of two fragments:

- _Positive fragment_ describes how things are created. When we talk about
  values we refer to the positive fragment.

- _Negative fragment_: describes how to deconstruct environments of values. We will refer to
  the negative fragment as _commands_.

The typing rules for the positive fragment of #ln is depicted in @positive_fragment

#figure(caption: [Typing rules for values in #ln], positive(true)) <positive_fragment>

Most of the typing judgements are uncontroversial in a linearly typed setting. The interesting additions in #ln are _newstack_, _static function_, and the two closures.
The first addition is _newstack_. As the name suggests, _newstack_ is an atomic value for an empty stack.
Next up is _linear pointer_, which, if we remember the kind judgement for the linear pointer ($(A : omega) / (square A : known)$) is a pointer to a stack.
Finally we have the three lambdas: _static function_, _stack closure_, and _linear closure_.

To be able to easily understand them, we will give them operational meaning.
Each lambda can be placed in one of three groups; goto, procedural, and higher-order.
The first is goto, which is the most primitive, it performs a one-way transfer of control.
We can imagine that the function $f : *(A times.circle *B)$ represents
a function that $A$ as an argument, produces a $B$ and continues with it.
The issue is that $*B$ can not have its own saved variables in an environment (its stack).
This is the essence of goto-programming.
//TODO: Sebastian: continue with stack closure

// Importantly, the goto style can not capture free variables, hence the environment must be empty. Because of the lack of free variables, we call it _static function_ rather than _static closure_. The _stack closure_ corresponds to a procedure, often referred to as function. 

- _static function_: goto
- _stack closure_: procedural (first-order)
- _linear closure_: higher-order

#figure(caption: [Typing rules for commands in #ln], negative(true)) <negative_fragment>

The juxtaposition of the negative and positive fragments create an elegant
picture. For every value $v$, a corresponding command exists for how to destruct
an environment that has $v$ #todo[is this even correct]. Variables can not be destructed, rather they are consumed
on use, following the rules of linear types.
