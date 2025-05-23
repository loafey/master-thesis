#import "../Prelude.typ": *
#import "figures.typ": *
#import "@preview/curryst:0.5.1": rule, prooftree

= #ln <SlflChapter>

The intended use of #ln is as a compiler intermediate representation for
functional languages, similar to that of GHC Core @jones1993glasgow.
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
#todo[Move to 4.x probably]

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

== Continuation-passing Style <cps>
_Continuation-passing style_ (CPS) is a style where control is passed
explicitly via continuation functions rather than returning values.
intuitively, we can think of continuations as functions that capture "the rest
of the program".
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

Continuations have been used extensively in compiler engineering #todo[cite appel, STG, and more?]
A natural question that comes to mind now is why we want continuation-passing
style? An immediate benefit of CPS is that every function call is a tail call,
which ensures that tail call optimization (see @CompilingCompilationTarget) #todo[consider moving to footnote] is always possible. A second benefit of CPS
is that the order of evaluation is made explicit by the syntax.
#todo[provide sources of usages of CPS]
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

== Kinds & types <kind_and_types>

#ln is based on a variant of polarised linear logic. It is essentially Lafont's
intuitionistic linear logic (ILL) @lafont1988linear, where $A lollipop B$ is replaced
by $not A$. Intuitively, we can think of $not A$ as $A -> bot$, i.e. a function
that takes $A$ as argument and terminates with no value, like in @cps.

#let pll_types = {
  $A, B : : = & fatone | fatzero | x | not A | A times.circle B | A plus.circle B | exists x. A | circle | square A | *A | ~A$
}
\
#align(center, pll_types)

There are four new constructs in #ln that extend ILL. These are: _empty stack_
($circle$), _linear pointer_ ($square$), and _static function_ ($*A$).
The latter two are variants of $not A$.

At the core of #ln is the kind system. Where values have types, types have
kinds. The two kinds in #ln are _stack_ ($omega$) and _known length_
($known$). The kinding rules in #ln are given in @KindRules.

#figure(caption: [Kinding rules in #ln], align(center, kind_judgements(true)))<KindRules>

The kinding rules in @KindRules are mostly self-descriptive, but some things to keep in mind for the rules are:

#indent[
  + It is forbidden to construct a pair of two stacks
  + The kinds in a sum type must match
  + Type variables are stacks, which means they can not be used for regular polymorphism.
]

The reason type variables are stacks is a requirement for when we make the
structure of stacks explicit. We will expand on this in
@PointerClosureConversion.

Each negation can be placed #todo[enables ...] in one of three programming styles; goto, procedural, and
higher-order. The first, goto, is the most primitive, we can consider it as a one-way
transfer of control. Consider the function $f : *(A times.circle *B)$. From $f$
we can call the continuation $*B$, which is just a static function pointer. //itself does not contain anything
As such, it can not capture any state. The state that it manipulates is exactly $B$, and it is passed explicitly by $f$.
// other than the stack $B$. Every captured variable would need to be made
// explicit in $B$, and hence, not be captured. This is why we call $*B$ a
// _static function_ rather than a _static closure_.

The second style, procedural, enables just that, procedures (functions). The type signature
$f : *(A times.circle ~B)$ now exactly corresponds to the C function signature
$B space f(A space a)$. The type $~B$ corresponds to a stack that accepts
$B$ as a return value to continue with. This stack can capture arbitrary
state of kind $omega$.
There can only be a single stack passed to a static function due to the kinding rules of $*$ and $times.circle$ #todo[maybe change].

//and because the environment is a stack,
// remember the kind rule $~A : omega$, there is a single chosen stack to
// continue on.

Finally we have higher-order programming, which
is not possible with $*$ and $~$. The type $*(A times.circle ~B
  times.circle ~C)$ is ill-kinded, and $*(A times.circle *B times.circle ~C)$
would not work either because $*B$ can not capture state.
To allow higher-order programming we introduce the _linear closure_.
The linear closure can capture arbitrary state and produces an
environment that has a known size. For example, the higher-order function apply has the type $*(¬(A ⊗ ¬B) ⊗ A ⊗ ~B)$.
In @Transformations we will explain how we transform closures to static functions.
#todo[REWRITE using state rather than free variables]

Finally, there is no subkinding in the language; if a type with kind $omega$
is expected, then a type with kind $known$ is not allowed, and vice versa.

== Types & values<TypesAndValues>

#ln consists of two fragments:

#indent[
  - _Positive fragment_ describes how things are created. When we talk about
    values we refer to the positive fragment.
  - _Negative fragment_: describes how to deconstruct environments of values. The
    negative fragment can also be referred to as commands.
]

The typing rules for the positive fragment are depicted in
@typing_positive_fragment, while @typing_negative_fragment shows the typing
rules for the negative fragment.

#figure(
  caption: [],
  grid(
    inset: (bottom: 15pt),
    columns: (0.2fr, 1fr, 1fr, 0.2fr),
    "", newstack_value, [Newstack is a primitive for creating an empty stack], "",
    "", var_value, [All variables must used exactly once], "",
    "",
    pair_value,
    [Constructing a pair from the two values $u$ and $v$. Note that the contexts $Gamma, Delta$, must be disjoint],
    "",

    "", inj_left_value, [Constructing the left value of a sum type], "",
    "", inj_right_value, [Constructing the right value of a sum type], "",
    "", linear_pointer_value, [Making an indirection], "",
    "", exists_intro_value, [Existentially quantifying the term $t : A$ with the type variable $alpha$], "",
    "",
    static_function_value,
    [Because the static function can not capture any variables, the remaining environment has to be empty],
    "",

    "",
    stack_closure_value,
    [The stack closure can capture variables, so the remaining environment does not need to be empty],
    "",

    "",
    linear_closure_value,
    [The linear closure can capture variables, so the remaining environment does not need to be empty],
    "",
  ),
)<typing_positive_fragment>

The typing rules for _pair_, _var_, and the closures mimic those in @LinearTypes.
The interesting additions in #ln are _newstack_, _static function_, and the two
closures.

#figure(
  caption: [Typing rules for the negative fragment],
  grid(
    inset: (bottom: 15pt),
    columns: (0.1fr, 1.5fr, 1fr, 0.1fr),
    "", freestack_command, [Consume and free the stack $z$], "",
    "", pair_command, [Consume and destruct the pair $z$, introducing the variables $a$ and $b$], "",
    "",
    case_command,
    [Pattern match on the sum, binding the value of $z$ to $x_i$ and continue with the continuation $c_i$],
    "",

    "", follow_command, [Follow the indirection, binding the stack behind the pointer to $x$], "",
    "", exists_elim_command, [Match the existenially quantified term $z$ to access the actual term $x$], "",
    "",
    static_call_command,
    [Call the static function $z$ with the term $t$ as argument. Note that the environment does not need to be empty when calling static functions],
    "",

    "", stack_call_command, [Call the stack closure $z$ with the term $t$ as argument], "",
    "", linear_call_command, [Call the linear closure $z$ with the term $t$ as argument], "",
    "",
  ),
) <typing_negative_fragment>

The juxtaposition of the negative and positive fragments create an elegant
picture. For every value $v$, a corresponding command exists for how to destruct
an environment of $v$. Variables are not explicitly destructed; they are consumed
on use.
