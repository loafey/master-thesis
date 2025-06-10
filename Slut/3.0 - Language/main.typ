#import "../Prelude.typ": *
#import "../Figures.typ": *

= #ln

== Grammar

#let complete_grammar = [
  _Value_
  #values
  #dbl_linkbreak()
  _Command_
  #commands
  #dbl_linkbreak()
  _Pattern_
  #pat
  #dbl_linkbreak()
  _Type_
  #type
  #dbl_linkbreak()
  _Definition_
  #def
]

#complete_grammar

== Grammar

#align(
  center + horizon,
  $
    "swap" : *(( & A times.circle B) times.circle ~(B times.circle A)) \
     = lambda x. & "let" y, k = x;                                     \
                 & "let" a,b = y;                                      \
                 & k(b,a)
  $,
)

== Kinds

#let frame(stroke) = (x, y) => (
  if x == 1 { none } else if y == 6 or y == 0 or y == 1 or y == 2 {
    none
  } else if y == 5 {
    (
      top: stroke,
      bottom: (dash: "dashed", join: "miter"),
      left: stroke,
      right: stroke,
    )
  } else if y == 7 {
    (
      top: (dash: "dashed", join: "round"),
      bottom: stroke,
      left: stroke,
      right: stroke,
    )
  } else {
    (top: stroke, bottom: stroke, left: stroke, right: stroke)
  }
)

#grid(
  columns: (1fr, 1fr),
  [
    #ln has two kinds

    $#math.italic[Kind] : : = omega | known$

    - $omega$ is called _stack_

    - $known$ is called _known size_


  ],
  [
    #linebreak()
    #stack(
      dir: ltr,
      spacing: 0.5em,
      $omega space lr(\{ #v(17em)) #table(
        stroke: frame(rgb("000")),
        columns: (10em, 10em),
        fill: (x, y) => { if y == 8 and x == 0 { black } else { none } },
        rows: (2em, 2em, 2em, 2em, 2em, 2em, 2em, 2em, 0.5em),
        inset: 0pt,
        gutter: 0pt,
        [#align(center + horizon, $circle.filled.small$)], [],
        [#align(center + horizon, $circle.filled.small$)], [],
        [#align(center + horizon, $circle.filled.small$)], [],
        [#align(center + horizon, $known$)], [],
        [#align(center + horizon, $known$)], [],
        [#align(center + horizon, $known$)], [],
        [], [],
        [#align(center + horizon, $known$)], [],
        [], [$space <- omega$],
      )$,
    )],
)

Every type has one of the two kinds

The environment of free variables has a kind

== Types

=== Grammar
\
$A,B & ::= fatzero & #[empty] \
& space | fatone & #[unit] \
& space | circle & #[empty stack] \
& space | alpha & #[type variable] \
& space | not A & #[linear closure] \
& space | ~ A & #[stack closure] \
& space | * A & #[static function] \
& space | square A & #[linear pointer] \
& space | A times.circle B & #[product] \
& space | A plus.circle B & #[sum] \
& space | exists alpha. A & #[exists] \ $

== Types

// #align(
//   center,
//   $A,B & ::= fatzero | fatone
//   | circle
//   | alpha
//   | not A
//   | ~ A
//   | * A
//   | square A
//   | A times.circle B
//   | A plus.circle B
//   | exists alpha. A$,
// )

=== Kind rules

#align(center + horizon, kind_judgements)

#grid(
  columns: (1fr, 1fr),
  [
    - Sums must have matching kinds
    - No pairs of stacks
  ],
  [
    - Type variables are stacks (no Haskell-style polymorphism)
    - No subkinding
  ],
)

== Typing environment

=== Grammar
#indent[
  $Gamma ::= dot | Gamma, x : A$
]

#indent[
  - $Gamma$ is a mapping from free variables to types

  - $Gamma, x : A$ means: environment $Gamma$ extended with $x : A$
]


=== Kind rules
#align(center, flex(
  prooftree(rule($dot : known$, $$)),
  prooftree(rule($(Gamma, x: A) : omega$, $Gamma: known$, $A : omega$)),
  prooftree(rule($(Gamma, x: A) : omega$, $Gamma: omega$, $A : known$)),
  prooftree(rule($(Gamma, x: A) : known$, $Gamma : known$, $A : known$)),
)) <kinds_env>

#indent[
  - Empty environment has known size

  - At most stack in an environment
]

== Values & commands

=== How to read

\

$#prooftree(rule(
  $Gamma,
  Delta tack (t,u) : A times.circle B$,
  $Gamma tack t: A$,
  $Delta tack u : B$,
))$

\
If the following hold:

+ $Gamma tack t : A$ = \" $t$ has type $A$ in the environment $Gamma$\"

+ $Delta tack u : B$ = \" $u$ has type $B$ in the environment $Delta$\"

then:

$Gamma, Delta tack (t,u) : A times.circle B$ = \" $(t,u)$ has type $A times.circle B$ in the environment $Gamma,Delta$\"

$Gamma$ and $Delta$ must be disjoint.

== Values & commands
=== Values
#align(center + horizon, positive(none))

== Values & commands

=== Commands

#align(center + horizon, negative(none))

== Values & commands

=== Functions and closures

#grid(
  columns: (1fr, 1fr),
  indent[
    - $*A$ -- _static function_

    - $~A$ -- _stack closure_

    - $not A$ -- _linear closure_
  ],
  grid(
    columns: (
      1fr
    ), inset: 10pt, static_function_value,
    stack_closure_value,
    linear_closure_value,
  ),
)

#indent[
  - $*A$ = goto programming

  - $~A$ = procedural programming

  - $not A$ = higher-order programming
]

== Values & commands

=== Goto programming
#indent[
  - $*A$ is a label
  - Can not capture state
]

=== Procedural programming

#indent[
  - Can capture state
  - $*(A times.circle ~B)$ corresponds to C function signature $B space (A space a)$
]

=== Higher-order programming

#indent[
  - $*(A times.circle *B times.circle ~C)$
  - $*(A times.circle ~B times.circle ~C)$
]
