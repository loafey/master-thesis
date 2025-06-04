#import "../Prelude.typ": *
#import "figures.typ": *
#import "@preview/curryst:0.5.1": prooftree, rule

= #ln <SlflChapter>

The intended use of #ln is as a compiler intermediate representation for
functional languages, similar to that of GHC Core @jones1993glasgow.
#ln differs from GHC Core and most functional language intermediate representations in
that it prioritizes finer control over resources. This is achieved by departing
from the lambda calculus and its natural deduction root, rather taking
inspiration from linear types and intuitionistic linear logic @lafont1988linear.

== Grammar <grammar_ln>

Before going into details on #ln it can be helpful to get an overview of how
the language looks. The grammar of #ln is depicted in @slfl_grammar.

#figure(caption: [Grammar of #ln], align(left, complete_grammar))<slfl_grammar>

Take this top-level function (_Definition_) as an example:
$
  & "swap" : *((B times.circle A) times.circle ~(A times.circle B)) \
  & quad = lambda((x,y), k) -> k((y,x));
$
$"swap"$ here can be broken up into three parts:
- The name: $"swap"$
- The type: $*((B times.circle A) times.circle ~(A times.circle B))$
- The value: $lambda((x,y), k) -> k((y,x))$

$"swap"$ takes two arguments: a tuple $(B times.circle A)$
and a continuation function $~(A times.circle B)$.
The first argument, the tuple, is pattern matched on,
exposing the variables $x$ and $y$.
The second argument, $k$, is the continuation function.


A module consists of a list of definitions, where a definition is a top-level
function. A definition consists of a name, a type, and
a value. The distinction between values and commands is the most interesting
aspect. Commands come into play in the bodies of lambdas. Commands consist of
let-bindings, case-expressions, or function calls. Note that the only way to
terminate a sequence of commands is by a function call $z(v)$. This means
#ln programs are written in continuation-passing style.

== Kinds & types <kind_and_types>

#ln is based on a variant of polarised linear logic @laurent2002etude. It is
essentially Lafont's linear logic @lafont1988linear, where $A lollipop B$ is
replaced by $not A$. Intuitively, we can think of $not A$ as $A lollipop bot$,
or from a programmer's perspective: a function that takes $A$ as argument and
terminates with no value, like in @cps.

#let pll_types = {
  $A, B : : = & fatone | fatzero | x | not A | A times.circle B | A plus.circle B | exists x. A | circle | square A | *A | ~A$
}
\
#align(center, pll_types)

There are four new constructs in #ln that extend intuitionistic linear logic.
These are: _empty stack_
($circle$), _linear pointer_ ($square$), _static closure_ ($~$), and _static function_ ($*$).
The latter two are variants of negation ($not$).

At the core of #ln is the kind system. Where values have types, types have
kinds. The two kinds in #ln are _stack_ ($omega$) and _known length_ $omega$
represents a region of memory of unknown length, with extra reserved space to
store arbitrarily sized data.

#figure(caption: [Kinding rules in #ln], align(center, kind_judgements(true)))<KindRules>


The kinding rules in @KindRules are mostly self-descriptive, but some things to keep in mind for the rules are:

#indent[
  + There is no sub-kinding; if a type with kind $omega$ is expected, then a type with kind $known$ is not allowed, and vice versa.
  + It is forbidden to construct a pair of two stacks
  + The kinds in a sum type must match
  + Type variables are always stacks, which means they cannot be used directly for haskell-style polymorphism
    (see @PointerClosureConversion).
]

Each negation enables one of three programming styles: goto ($*$) , procedural
($~$), and higher-order ($not$).

The goto style is the most primitive. It can be considered as a one-way
transfer of control. Consider the function $f : *(A times.circle *B times.circle circle)$.
From $f$ we can call the continuation $*B$, which is
just a static function pointer, and because it is only a static function
pointer, it can not capture any state. The state that $*B$ manipulates is
exactly the stack $B$, and it is passed by $f$.

The second style, procedural, enables exactly what its name suggests: procedures.
The type signature $f : *(A times.circle ~B)$ exactly corresponds to the
C function signature $B space f(A space a)$. The type $~B$ corresponds to
a stack that accepts $B$ as a return value to continue with. This stack can
store an arbitrary state of kind $omega$. Because of the kinding rules of $*$
and $times.circle$, only a single stack can be passed to a static function.

Finally we have higher-order programming, which
is not possible with $*$ and $~$ alone. The type $*(A times.circle ~B
  times.circle ~C)$ is ill-kinded, and $*(A times.circle *B times.circle ~C)$
would not work either because $*B$ can not capture state.
To enable higher-order programming we introduce the _linear closure_.
The linear closure can capture arbitrary state and produces a type with a known size (remember the kinding rule).
Now we can write the higher-order function: $*(A times.circle not B times.circle ~C)$.
In @Transformations we explain how closures are transformed to static functions
and explicit stack environments.

== Types & values<TypesAndValues>

#ln programs consist of two syntactic fragments:

#indent[
  - The _Positive fragment_ describes how values are created. When we talk about
    values we refer to the positive fragment.
  - The _Negative fragment_: describes how to consume environments of values. The
    negative fragment can also be referred to as commands.
]

The typing rules for values and commands are given the form $Gamma tack v : A$ and $Gamma tack c$, respectively.
Values have a right-side type ($v: A$) to symbolize construction. Conversely, commands do not have a right-side type, to symbolize consumption.
Because the rules for values have a right-side type, they are read in
a top-to-bottom fashion. The rules for commands are read in a bottom-to-top
fashion.

Kinds are also introduced to the environment $Gamma$. @kinds_env shows the rules for the environment.

#figure(caption: [], flex(prooftree(rule($dot : known$,$$)), prooftree(rule(
  $(Gamma, x: A) : omega$,
  $Gamma: omega$,
  $A : known$,
)), prooftree(rule($(dot, x: A) : omega$, $A : omega$)))) <kinds_env>

When the environment has kind $omega$, we know that it contains exactly one
stack. Conversely, when the environment has kind $known$, the environment does
not contain any stacks.

The typing rules for the positive fragment are depicted in
@typing_positive_fragment, while @typing_negative_fragment shows the typing
rules for the negative fragment.

#show figure: set block(breakable: true)
#let content = (a, b) => ("", a, block(breakable: false, b), "")
#figure(
  caption: [Typing rules for the positive fragment of #ln],
  grid(
    inset: (bottom: 15pt),
    columns: (0.2fr, 1fr, 1fr, 0.2fr),
    ..content(
      newstack_value,
      [Newstack is a primitive for creating an empty stack],
    ),
    ..content(
      var_value,
      [All variables must be used exactly once.],
    ),
    ..content(unit_value, [The unit value. The environment must be empty]),
    ..content(
      pair_value,
      [Constructing a pair from the two values $u$ and $v$. Note that the contexts $Gamma, Delta$, must be disjoint],
    ),
    ..content(inj_left_value, [Constructing the left value of a sum type]),
    ..content(inj_right_value, [Constructing the right value of a sum type]),
    ..content(linear_pointer_value, [Making an indirection]),
    ..content(
      exists_intro_value,
      [Existentially quantifying the term $t : A$ with the type variable $alpha$],
    ),
    ..content(
      static_function_value,
      [Create a static funcion. The environment must be empty, which means the static function can not capture any free variables.],
    ),
    ..content(
      stack_closure_value,
      [Create a stack closure, which can capture free variables. The environment must be a stack.],
    ),
    ..content(
      linear_closure_value,
      [Create a linear closure, which can capture free variables, The environment must not contain a stack.],
    )
  ),
)<typing_positive_fragment>

\

#figure(
  caption: [Typing rules for the negative fragment of #ln],
  grid(
    inset: (bottom: 15pt),
    columns: (0.1fr, 1.5fr, 1fr, 0.1fr),
    ..content(
      freestack_command,
      [Free the stack $z$. The variable $z$ is removed from the environment.],
    ),
    ..content(
      discard_command,
      [Discard the unit value. The variable $z$ is removed from the environment.],
    ),
    ..content(
      pair_command,
      [Destruct the pair $z$, introducing the variables $a$ and $b$, and remove $z$ from the environment.],
    ),
    ..content(
      case_command,
      [Pattern match on the sum, binding the value of $z$ to $x_i$ and continue
        with the continuation $c_i$. The subscript $i$ is used to indicate that
        there are two possible injections.],
    ),

    ..content(
      follow_command,
      [Follow the indirection, binding the stack behind the indirection to $x$],
    ),
    ..content(
      exists_elim_command,
      [Match the existentially quantified variable $z$ to access the actual value $x$],
    ),
    ..content(
      static_call_command,
      [Call the static function $z$ with the value $t$ as argument. Note that the environment does not need to be empty when calling static functions],
    ),

    ..content(
      stack_call_command,
      [Call the stack closure $z$ with the value $t$ as argument],
    ),
    ..content(
      linear_call_command,
      [Call the linear closure $z$ with the value $t$ as argument],
    ),
  ),
) <typing_negative_fragment>

The juxtaposition of the negative and positive fragments create an elegant
picture. For every value $v$, a corresponding command exists for how to destruct
an environment of $v$. Variables are not explicitly destructed; they are consumed
on use.

In @id_function we show how we can use the aforementioned rules to give the typing proof the identity function specialised to the type $A: known$.

#figure(
  caption: [The type proof for the identity function specialised to $A$.],
  prooftree(
    rule(
      $dot tack lambda^* x. "let" t,z = x; "call"^~ z(t) : *(A times.circle ~A)$,
      rule(
        $dot, x: (A times.circle ~A) tack "let" t,z = x; "call"^~z(t)$,
        rule(
          $dot, t: A, z: ~A tack "call"^~z(t)$,
          rule($dot, t: A tack t : A$, name: [_var_]),
          name: [$#math.italic[call]^~$],
        ),
        name: [_pair_],
      ),
      name: [_static function_],
    ),
  ),
) <id_function>

In @id_type we derive the proof for the type, to ensure that the type is kind correct.

#figure(
  caption: [The kind proof for the type of the identity function],
  prooftree(
    rule(
      $*(A times.circle ~A) : known$,
      rule(
        $(A times.circle ~A) : omega$,
        $A: known$,
        rule($~A: omega$, $A: known$),
      ),
    ),
  ),
) <id_type>

The kinding rules and typing rules provide a structured way of constructing
correct programs. When creating the compiler for #ln we can leverage these rules to construct the
kindchecker and typechecker.
