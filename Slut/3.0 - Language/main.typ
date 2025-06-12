#import "../Prelude.typ": *
#import "../Figures.typ": *

= #ln

== Grammar

_Value_\
$v, v' : : = x | lambda x. c | newstack | (v, v') | square v | angle.l A. v angle.r |...$

_Command_\
$c : : = z(a) | "let" p = x; c | ...$

_Pattern_\
$p,p' : : = x | square p | (p,p') | angle.l x, p angle.r | ...$

_Type_\
$A,B ::= circle | alpha | not A | ~ A | * A | square A | A times.circle B | exists alpha. A | ...$

\
$"swap" : *(( & A times.circle B) times.circle ~(B times.circle A)) \
 = lambda x. & "let" y, k = x;                                     \
             & "let" a,b = y;                                      \
             & k(b,a)                                              \ $


== Kinds

#let frame(stroke) = (x, y) => (
  if x == 1 { none } else if y == 6 or y == 7 or y == 0 or y == 1 or y == 2 {
    none
  } else if y == 5 {
    (
      top: stroke,
      bottom: (dash: "dashed", join: "miter"),
      left: stroke,
      right: stroke,
    )
  } else if y == 7 or y == 8 {
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

    - Every type has one of the two kinds


  ],
  [
    #linebreak()
    #stack(
      dir: ltr,
      spacing: 0.5em,
      $omega space lr(\{ #v(17em)) #table(
        stroke: frame(rgb("000")),
        columns: (10em, 10em),
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
        [], [],
        [], [$space <- omega$],
      )$,
    )],
)


== Types

=== Kind rules

#align(center + horizon, kind_judgements)

- No pairs of stacks
- Type variables are stacks
- No subkinding

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
  prooftree(rule($(Gamma, x: A)$, $Gamma$, $A : known$)),
)) <kinds_env>

#indent[
  - Empty environment has known size

  - At most stack in an environment

  - Environment has a kind

  - Kind omitted = either allowed
]

== Values & commands
=== Values: Positive fragment
\
#grid(
  align: left,
  columns: (1fr, 1fr),
  row-gutter: 16pt,
  var_value, newstack_value,
  linear_pointer_value, exists_intro_value,
  pair_value, linear_closure_value,
  static_function_value, stack_closure_value,
)

== Values & commands

=== Commands: Negative fragment
\

#grid(
  align: left,
  columns: (1fr, 1fr),
  row-gutter: 16pt,
  judge(
    $Gamma tack t: A$,
    $Gamma, z: (not A "or" ~A "or" *A) tack "call" z(t)$,
    note: $#math.italic[call]$,
  ),
  freestack_command,

  pair_command, exists_elim_command,
  follow_command,
)

== Values & commands

#let with_closures(ix, b, extend: none) = {
  let arr = (static_function_value, stack_closure_value, linear_closure_value)
  let one = none
  let two = none
  let three = none
  if ix == "all" {
    one = arr.at(0)
    two = arr.at(1)
    three = arr.at(2)
  }
  if ix.contains("static") { one = arr.at(0) }
  if ix.contains("stack") { one = arr.at(1) }
  if ix.contains("linear") { one = arr.at(2) }
  grid(
    columns: (1fr, 1fr),
    b,
    grid(
      columns: (
        1fr
      ), inset: 10pt,
      one, two, three, extend
    ),
  )
}

#with_closures("all")[
  #indent[
    === Functions and closures

    $*A$ = goto programming

    $~A$ = procedural programming

    $not A$ = higher-order programming

    \
    #stack(dir: ltr, $*A \ \ ~A \ \ not A$, $lr(#v(5em) \})$, $lr(#v(5em) A -> bot)$)
  ]
]


== Values & commands

#with_closures("static", extend: prooftree(rule($*A : known$, $A : omega$)))[

  #indent[
    === Static function: $*A$

    - Goto programming

    - $*A$ is a label

    - Can not capture state

    - State of $*A$ is exactly the stack $A$
  ]
]

== Values & commands
#with_closures(
  "stack",
  extend: $#prooftree(rule($*A : known$, $A : omega$)) quad #prooftree(rule(
    $A times.circle B : omega$,
    $A : known$,
    $B : omega$,
  ))$,
)[
  #indent[
    === Stack closure: $~A$

    - Procedural programming

    - $*(A times.circle ~B)$ corresponds to C function signature $B space (A space a)$

    - Can capture state
      - Must be a stack ($omega$)

    - Single stack per static function ($*$)
      - Kind rules for $*$ and $times.circle$

  ]
]

== Values & commands
#with_closures("linear")[
  #indent[
    === Linear closure: $not A$
    - Higher-order programming

    - $*(A times.circle *B times.circle ~C)$
      - $*B$ can not capture state

    - $*(A times.circle ~B times.circle ~C)$
      - ill-kinded

    - Can not capture stack state
  ]


  Because $not A : known$ we can do higher-order programming!

  #block(
    stroke: 0.1pt + black,
    inset: 10pt,
    $"foo" : & *(not A times.circle ~ not A)               \
          = & lambda x. "let" f,k = x; k(lambda y. f (y)) \ $,
  )
]
