#import "../Prelude.typ": *

== Transformations

#indent[
  - $*$ is a label

  - What about $~$ and $not$ ?

  - Three transformations
    - Linear closure conversion
    - Stack selection
    - Pointer closure conversion
]

== Transformations

=== Linear closure conversion

Goal: make pointers to stacks explicit

#grid(
  columns: (1fr, 1fr),
  stroke: black + 0.1pt,
  inset: 10pt,
  [Source], [Target],
  $not A$, $square~A$,
  $lambda^not x. c$, $square lambda^~ x. c$,
  $f(x)$, $"let" square g = f; g(x)$,
  $
    "apply" : & *(#text(fill: red, $not$) (A times.circle #text(fill: red, $not$) B) times.circle A times.circle ~B) \
    = lambda x. & "let" f, y = x; \
    & "let" a,k = y; \
    & #text(fill: red, $f$) (a, square k); \
  $,
  $
    "apply" : & *(#text(fill: green.darken(20%), $square~$) (A times.circle #text(fill: green.darken(20%), $square~$) B) times.circle A times.circle ~B) \
    = lambda x. & "let" f, y = x; \
    & "let" a,k = y; \
    & #text(fill: green.darken(20%), $"let" square g = f;$) \
    & #text(fill: green.darken(20%), $g$) (a, square k); \
  $,
)

== Transformations

=== Stack selection

#bigTodo[Continue here]
$"exit" : *(int times.circle circle)$

$"foo" : *(int times.circle not int)$
