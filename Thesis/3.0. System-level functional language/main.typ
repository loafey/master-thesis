#import "../Prelude.typ": *
#import "figures.typ": *
#import "@preview/curryst:0.5.1": rule, prooftree

= #ln <SlflChapter>

The intended use of #ln is as a compiler intermediate representation for
functional languages, similar to that of GHC Core. #todo[CITE GHC CORE]
#ln diverges from GHC Core and most functional language intermediate representations in
that it prioritizes finer control over resources. This is achieved by departing
from the lambda calculus and its natural deduction root, rather taking
inspiration from linear types.

An important aspect of a system-level language is the representation of types
and values. We want the language to be efficient, and thus, the representation
must match the computer's representation of memory. For instance, in many
functional programming languages values are boxed, i.e, placed behind pointers.
In a system-level language this would be counter-productive because the control
over memory should be in the hands of the developer. Because linear types
require variables to be used exactly once, the need for immutability is relaxed.

== Grammar

Before going into details on #ln it can be helpful to get an overview of how
the language looks. The grammar of #ln is depicted in @slfl_grammar.

#figure(caption: [Grammar of #ln], align(left, complete_grammar))<slfl_grammar>

Before describing the grammar, we will show an example of the function swap.
The example will assume $A$ and $B$ are concrete types which are inhabited by
the values $a$ and $b$ respectively.

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
let-bindings, case-expressons, or function calls. Note that the only way to
terminate a sequence of commands is by a function call $z(v)$. This ensures
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
which ensures that tail call optimization (see @CompilingCompilationTarget) #todo[consider moving to footnote] is always possible. A second benefit of CPS
is that the order of evaluation is made explicit by the syntax.
If we consider the following program written in normal style:

#align(
  center,
  $& "let" y = "bar"(x) "in" \ & "let" z = "baz"(x) "in" \ & y + z$,
)

Is $y$ evaluted first or is $z$ evaluted first? The choice would be up to the
specification. If we look at the same function in CPS we will see that the
evaluation order is determined by the order of the function calls.

#align(
  left,
  [

    + $"bar"(x, lambda y. "foo"(x, lambda z. k(y+z)))$
    + $"foo"(x, lambda z. "bar"(x, lambda y. k(y+z)))$

    In the first one, because the second argument of bar is in normal-form
    #footnote[A term is in normal-form if it can not be evaluated any further],
    the only possible execution order is to evaluate $"bar"(x,...)$.
    Conversely, in the second one $"foo"(x,...)$ has to be evaluted first, for the same reason.
  ],
)

== Kinds & types

#ln is based on a variant of polarised linear logic. It is essentially Lafont's
intuitionistic linear logic (ILL) @lafont1988linear, where $A lollipop B$ is replaced
by $not A$.

#let pll_types = {
  $A, B : : = & fatone | fatzero | x | not A | A times.circle B | A plus.circle B | exists x. A | circle | square A | *A | ~A$
}
\
#align(center, pll_types)

There are four new constructs in #ln that extend ILL. These are: _empty stack_
($circle$), _linear pointer_ ($square$), _static function_ ($*A$), and _stack
closure_ ($~A$). The latter two are variants of $not A$.

At the core of #ln is the kind system. Where values have types, types have
kinds. The two kinds in #ln are _stack_ ($omega$) and _known length_
($known$). The kinding rules in #ln are given in @KindRules.

#figure(caption: [Kinding rules in #ln], align(center, kind_judgements(true)))<KindRules>

The kinding rules in @KindRules are mostly self-descriptive, except the three
negation types, which we will explain in more detail. Some things to keep in mind for the rules are:

#indent[
+ It is forbidden to construct a pair of two stacks
+ The kinds in a sum type must match
+ Type variables are stacks, which means they can not be used for polymorphism.
]

Each negation can be placed in one of three groups; goto, procedural, and
higher-order. The first, goto, is the most primitive, it performs a one-way
transfer of control. Consider the function $f : *(A times.circle *B)$. From $f$
we can call the continuation $*B$, but $*B$ itself does not contain anything
other than the stack $B$. Every captured variable would need to be made
explicit in $B$, and hence, not be captured. This is why we call $*B$ a
_static function_ rather than a _static closure_. 

The second style, procedural, enables just that, procedures. The type signature
$f : *(A times.circle ~B)$ now exactly corresponds to the C function signature
$B space f(A space a)$. The type $~B$ corresponds to a stack frame that accepts
$B$ as a return value to continue with, and because the environment is a stack,
remember the kind rule $(~A : omega)$, there is a single chosen stack to
continue on.

Finally we have higher-order programming, which unfortunately
is not possible with $*$ and $~$. The type $*(A times.circle ~B
times.circle ~C)$ is ill-kinded, and $*(A times.circle *B times.circle ~C)$
would not work either as $*B$ can not cature variables.
To allow higher-order programming we introduce the _linear closure_.
The linear closure can capture free variables and produces an
environment that has a known size. For example, the higher-order function apply has the type $*(¬(A ⊗ ¬B) ⊗ A ⊗ ~B)$
In @Transformations we will explain how we transform both closures to static functions.

There is no subkinding in the language; if a type that is stack
is expected, then a type with known length is not allowed, and vice versa.

== Types & values<TypesAndValues>

#ln consists of two fragments:

#indent[
- _Positive fragment_ describes how things are created. When we talk about
  values we refer to the positive fragment.
- _Negative fragment_: describes how to deconstruct environments of values. We will refer to
  the negative fragment as _commands_.
]

The typing rules for the positive fragment of #ln is depicted in @positive_fragment

#figure(caption: [Typing rules for values in #ln], positive(true)) <positive_fragment>

Most of the typing judgements are uncontroversial in a linearly typed setting.
The interesting additions in #ln are _newstack_, _static function_, and the two
closures. The first addition is _newstack_, which, as the name suggests, is
an atomic value for an empty stack. Next up is _linear pointer_, which, if we
remember the kind judgement for the linear pointer ($(A : omega) / (square
A : known)$) is a pointer to a stack. 


#figure(caption: [Typing rules for commands in #ln], negative(true)) <negative_fragment>

The juxtaposition of the negative and positive fragments create an elegant
picture. For every value $v$, a corresponding command exists for how to destruct
an environment that has $v$ #todo[is this even correct]. Variables can not be destructed, rather they are consumed
on use, following the rules of linear types.
