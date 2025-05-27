#import "../Prelude.typ": *
#import "figures.typ": *
#import "@preview/curryst:0.5.1": prooftree, rule

= #ln <SlflChapter>

The intended use of #ln is as a compiler intermediate representation for
functional languages, similar to that of GHC Core @jones1993glasgow.
#ln diverges from GHC Core and most functional language intermediate representations in
that it prioritizes finer control over resources. This is achieved by departing
from the lambda calculus and its natural deduction root, rather taking
inspiration from linear types and intuitionistic linear logic @lafont1988linear.

== Grammar

Before going into details on #ln it can be helpful to get an overview of how
the language looks. The grammar of #ln is depicted in @slfl_grammar.

#figure(caption: [Grammar of #ln], align(left, complete_grammar))<slfl_grammar>

Before describing the grammar, we will show an example of the function swap:
$
  & "swap" : *((B times.circle A) times.circle ~(A times.circle B)) \
  & quad = lambda((x,y), k) -> k((y,x)); \
  \
  & "main" : *~(A times.circle B) \
  & quad = lambda k -> "swap"((b,a), k); \
$

A module consists of a list of definitions, where a definition is a top-level
function. A definition consists of a name, a type, and
a value. The distinction between values and commands is the most interesting
piece. Commands come into play in the bodies of lambdas. Commands consist of
let-bindings, case-expressions, or function calls. Note that the only way to
terminate a sequence of commands is by a function call $z(v)$. This ensures
that #ln is written in continuation-passing style.

== Kinds & types <kind_and_types>

#ln is based on a variant of polarised linear logic @laurent2002etude. It is essentially Lafont's
intuitionistic linear logic @lafont1988linear, where $A lollipop B$ is replaced
by $not A$. Intuitively, we can think of $not A$ as $A -> bot$, or from a programmer's perspective: a function
that takes $A$ as argument and terminates with no value, like in @cps.

#let pll_types = {
  $A, B : : = & fatone | fatzero | x | not A | A times.circle B | A plus.circle B | exists x. A | circle | square A | *A | ~A$
}
\
#align(center, pll_types)

There are four new constructs in #ln that extend intuitionistic linear logic.#todo[fact check]
These are: _empty stack_
($circle$), _linear pointer_ ($square$), _static closure_ ($~$), and _static function_ ($*$).
The latter two are variants of negation ($not$).

At the core of #ln is the kind system. Where values have types, types have
kinds. The two kinds in #ln are _stack_ ($omega$) and _known length_
($known$).

#figure(caption: [Kinding rules in #ln], align(center, kind_judgements(true)))<KindRules>

The kinding rules in @KindRules are mostly self-descriptive, but some things to keep in mind for the rules are:

#indent[
  + It is forbidden to construct a pair of two stacks
  + The kinds in a sum type must match
  + Type variables are stacks, which means they cannot be used for polymorphism
    (see @PointerClosureConversion).
]

Each negation enables one of three programming styles: goto ($*$) , procedural
($~$), and higher-order ($not$).

The first, goto, is the most primitive.
It can be considered as a one-way transfer of control. Consider the function $f
: *(A times.circle *B)$. From $f$ we can call the continuation $*B$, which is
just a static function pointer, and because it is only a static function pointer, it can not capture any
state.
The state that $*B$ manipulates is exactly the stack $B$,
and it is passed by $f$. #todo[add image, ill-kinded]

The second style, procedural, enables exactly what its name suggests: procedures.
The type signature $f : *(A times.circle ~B)$ now exactly corresponds to the
C function signature $B space f(A space a)$. The type $~B$ corresponds to
a stack that accepts $B$ as a return value to continue with. This stack can
capture arbitrary state of kind $omega$. Because of the kinding rules of $*$
and $times.circle$, only a single stack can be passed to a static function.

Finally we have higher-order programming, which
is not possible with $*$ and $~$. The type $*(A times.circle ~B
  times.circle ~C)$ is ill-kinded, and $*(A times.circle *B times.circle ~C)$
would not work either because $*B$ can not capture state.
To enable higher-order programming we introduce the _linear closure_.
The linear closure can capture arbitrary state and produces an
environment with a known size (remember the kinding rule).
Now we can write the higher-order function: $*(A times.circle not B times.circle ~C)$.
In @Transformations we explain how closures are transformed to static functions
and explicit stack environments.

Finally, there is no sub-kinding in #ln\; if a type with kind $omega$
is expected, then a type with kind $known$ is not allowed, and vice versa.

== Types & values<TypesAndValues>

#ln consists of two fragments:

#indent[
  - _Positive fragment_ describes how things are created. When we talk about
    values we refer to the positive fragment.
  - _Negative fragment_: describes how to consume environments of values. The
    negative fragment can also be referred to as commands.
]

Values and commands are given the form $Gamma tack v : A$ and $Gamma tack c$.
Values have a right side type to symbolize construction. Conversely, commands lack a right
side type, to symbolize consumption. The rules for values are read in a top-to-bottom fashion, whereas the rules for commands are read in a bottom-to-top fashion.

The typing rules for the positive fragment are depicted in
@typing_positive_fragment, while @typing_negative_fragment shows the typing
rules for the negative fragment.

#show figure: set block(breakable: true)
#figure(
  caption: [Typing rules for the positive fragment of #ln],
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

\

#figure(
  caption: [Typing rules for the negative fragment of #ln],
  grid(
    inset: (bottom: 15pt),
    columns: (0.1fr, 1.5fr, 1fr, 0.1fr),
    "", freestack_command, [Free the stack $z$], "",
    "", pair_command, [Destruct the pair $z$, introducing the variables $a$ and $b$], "",
    "",
    case_command,
    [Pattern match on the sum, binding the value of $z$ to $x_i$ and continue
      with the continuation $c_i$. The subscript $i$ is used to indicate that
      there are two possible injections.],
    "",

    "", follow_command, [Follow the indirection, binding the stack behind the pointer to $x$], "",
    "", exists_elim_command, [Match the existentially quantified term $z$ to access the actual term $x$], "",
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
