#import "../Prelude.typ": *
#import "figures.typ": *
#import "@preview/curryst:0.5.1": rule, prooftree

= System-Level Functional Language<slflChapter>

In this section we will introduce the reader to SLFL. We will explain how the language works and argue why the choices are made.

// System-Level Functional Language (SLFL) is meant to be an intermediate compilation target for linearly typed functional programming languages. Popular compilation targets today are LLVM, Cranelift, C, and compiling to assembly languages directly.
// Although the aforementioned alternatives are all viable, for a functional programming language several transformations have to be made. For instance, most functional programming languages have closures.

// SLFL consists of two fragments; positive and negative. The positive fragment describes how terms are created, while the negative fragment describes how terms are consumed.
// Two kinds, known size ($n,m$) and stack size $omega$.
// Continuation-passing style.


== Continuation-passing Style
An immediate notable difference between SLFL and other functional programming
languages is the programming style. SLFL is written in _continuation-passing
style_ (CPS), a programming style where control is passed explicitly via
continuation functions rather than returning values. We will provide a simple example of CPS using the identity function. In normal style it would be:

#align(
  center,
  $
    & id : forall a. a -> a\
    & id = lambda x. space x
  $,
)

contrast it to the CPS version:

#align(
  center,
  $
    & id : forall a, r. space a -> (a -> r) -> r \
    & id = lambda x. lambda k. space k(n)
  $,
)

A natural question that comes to mind now is why we want continuation-passing style? An immediate benefit of CPS is that every function call is a tail call, which enables tail call optimization for every function call. Another benefit is that the order of evaluation is made explicit. If we consider the following program written in normal style:

#align(
  center,
  $"foo" = lambda x. & "let" y = "bar"(x) \ & "in" "let" z = "baz"(x) \ & "in" y + z$,
)

Is $y$ evaluted first or is $z$ evaluted first? The choice would be up to the
compiler developer. If we look at the same function in CPS we will see that the
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

At the core of SLFL is the kind system which describes the size of types. There
are two kinds in SLFL:
- $omega$. _dynamic size_
- $n,m,k$: _constant size_

The following are all the kind judgements in the language. They describe how
types can be combined in a kind-correct fashion.

#text(size: 1.3em, align(center, kind_judgements))

We can now derive types following the kind rules. For instance, let
us derive the types 
$A times.circle B times.circle ~C$ and $A times.circle (B plus.circle C) times.circle circle$

#let tree = rule(
  ($A times.circle B times.circle ~C: omega$),
  prooftree(rule($A:n$, "")),
  prooftree(
    rule(
      $B times.circle ~C: omega$,
      rule($B: m$),
      prooftree(rule($~C: omega$, prooftree(rule($C: k$)))),
    ),
  ),
)
#let tree2 = rule(
  ($A times.circle (B plus.circle C) times.circle circle: omega$),
  prooftree(rule($A:n$, "")),
  prooftree(
    rule(
      $(B plus.circle C) times.circle circle: omega$,
      prooftree(rule($B plus.circle C: max(m, k)$, $B: m$, $C: k$)),
      prooftree(rule($circle: omega$)),
    ),
  ),
)
#grid(
  columns: (1fr, 1fr),
  inset: (top: 0.3cm, bottom: 0.3cm, right: -3pt, left: -3pt),
  prooftree(tree), prooftree(tree2),
)

The $omega$ case of the product type ($times.circle$) can be interpreted as
 pushing its left operand on the right operand stack. The circle ($circle$) can
 be interpreted as being the empty stack, while $~A$ is a closure type that
 represents "the rest of the stack". $*A$ and $not A$ are also closure types,
 but since they construct type with kind $n$, they have no stack-like
 representation.
 This part will become clear when we give meaning to the types in their memory
 representation. #todo[Refer to section]

== Types & values

SLFL consists of two fragments:

- _Positive fragment_ describes how things are created. When we talk about
  values we refer to the positive fragment.

- _Negative fragment_: describes how values are destructed. We will refer to
  the negative fragment as _commands_

@positive_fragment contains the typing rules for the positive fragment of SLFL.

#figure(caption: [The positive fragment], positive(true)) <positive_fragment>

#figure(caption: [The negative fragment], negative(true)) <negative_fragment>

The juxtaposition of the negative and positive fragments create an elegant
picture. For every value $v$, a corresponding command exists for how to consume
$v$. Variables have no explicit rule for consumption, rather they are consumed
on use, following the rules of linear types.

== Grammar

#figure(caption: [Grammar of SLFL], align(left,complete_grammar))

== Transformations

SLFL consists of three intermediate languages:
- Linear closure converted
- Stack selected
- Pointer closure converted

We will consider the following program to explain each step: $lambda a. "let"
f,k = a; k(lambda y. space f(y))$ with type $not (not int times.circle not not
int)$. We use $int$ to avoid considering existential types for now.

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

== Compilation Scheme

$rho : Gamma -> "List"("Reg")$ \
$rho$ is a mapping from variables to a list of memory addresses.

The reason the range of $rho$ is a list of memory addresses is because some values
require more space than one memory address can fit.

$#sem($t$)^alpha_rho = #code_box($c$)$ reads as follows: The compilation scheme
for $t$ with kind $alpha$ and variable environment $rho$ is $c$. We use $alpha$
to represent either $n$ or $omega$.

The scheme uses a mix of meta syntax, i.e, instructions that does not generate
any code, and instructions that generate code. We differentiate meta syntax
with instructions using double quotes.

=== Positive fragment

#positive_compilation_scheme

=== Negative fragment

#negative_compilation_scheme

