#import "../Prelude.typ": *
#import "../Figures.typ": *

== Compiling #ln


#indent[
  - A calculus
    - How to transform to assembly?

  - $*$ is a label
    - What about $~$ and $not$ ?

  - Three transformations
    - #text(fill: blue.darken(40%), [Linear closure conversion])
    - #text(fill: blue.darken(40%), [Stack selection])
    - #text(fill: blue.darken(40%), [Pointer closure conversion])
]

== Transformations

=== Linear closure conversion

Goal: make pointers to stacks explicit

#grid(
  columns: (0.5fr, 1fr, 1.3fr),
  stroke: black + 0.1pt,
  inset: 10pt,
  [], [Source], [Target],
  [Type], $not A$, $square~A$,
  [Value], $lambda^not x. c$, $square lambda^~ x. c$,
  [Command], $f(x)$, $"let" square g = f; g(x)$,
  [Example],
  $"foo" : *(not & A times.circle ~ not A) \
  = lambda x. & "let" f,k = x; & \ & k(lambda y. f (y))$,

  $"foo" : *(square & ~ A times.circle ~ (square ~ A)) \
  = lambda x. & "let" f,k = x; \ & k(lambda y. "let" square g = f; g(y))$,
)

== Transformations

#let hl_gr(x) = text(fill: green.darken(20%), x)
#let hl_re(x) = text(fill: red, x)

=== Stack selection

Goal: identify a unique stack for every stack closure

#block(stroke: black + 0.1pt, inset: 10pt, $"foo" : *(square& ~A times.circle ~ (square~ A)) \
= lambda x. & "let" f,k = x; \ & k(square lambda y. "let" square g = f; g (y))$)

Problem: 
  - Environment for $not A$ must be $known$
  - Environment for $~ A$ must be $omega$
    - $Gamma = dot, f : square ~A$
    - $Gamma : known$

== Transformations
=== Stack selection

Goal: identify a unique stack for every stack closure

#block(
  stroke: black + 0.1pt,
  inset: 10pt,
  $"foo" : *(square& ~A times.circle ~ (square~ A)) \
  = lambda x. & "let" f,k = x; \ & k(square lambda y. #hl_re($"let" square g = f; $) g(y))$,
)

Solution: move the \"unboxing\" out of the closure

#block(stroke: 0.1pt + black, inset: 10pt,
  $"foo" : *(square& ~A times.circle ~ (square~ A)) \
  = lambda x. & "let" f,k = x; \ & #hl_gr($"let" square g = f;$) \ &k(square lambda y. g(y))$
)

== Transformations
=== Stack selection

#indent[
  Can not always find a unique stack:

  $& "bar" : *(A times.circle circle) \ & "baz" : *(~not A) = lambda k. k(lambda y. "bar"(y, newstack))$
]

- $Gamma = dot$
- $Gamma : known$

Impossible to find stack for the closure

== Transformations
=== Pointer closure conversion
Goal: make the structure of stacks explicit

How: convert stack closure to a pair of a static function and an environment.

#grid(
  columns: (1fr, 2fr),
  stroke: black + 0.1pt,
  inset: 10pt,
  [Source], [Target],
  $~A$, $exists gamma. *(A times.circle gamma) times.circle gamma$,
  $lambda^~ . c$,
  $#angled($times.circle.big Gamma$, $((lambda^* (x, rho) . "unpairAll"(rho); c), "pairvars"(Gamma))$)$,

  $z(a)$, $"let" #angled($alpha$, $z_1$) = z; "let" z_2, rho = z_1; z_2(a,rho)$,
)

#grid(
  columns: (1fr, 1fr),
  [
    - $exists gamma. #text(fill: green.darken(20%), $*(A times.circle gamma)$) times.circle #text(fill: red, $gamma$)$
      - pair of a #text(fill: green.darken(20%), "static function") and an #text(fill: red, "environment")
  ],
  [
    If $Gamma = dot, x : A, y : B, z : C$ then
    - $times.circle.big Gamma = A times.circle B times.circle C$
    - $"pairvars"(Gamma : omega) = (x,y,z)$
    - $"pairvars"(Gamma : known) = (x,y,z,newstack)$
    - $"unpairAll"$ inverts $"pairvars"$
  ],
)

== Transformations
=== Pointer closure conversion

$Gamma = dot, x : A, y : B, z : C$

$Gamma : known$

$"pairvars"(Gamma) = (x,y,z,newstack) = rho$

$"unpairAll"(rho); c = & "let" x, rho_1 = rho; \
& "let" y, rho_2 = rho_1; \
& "let" z,n s = rho_2; \
& "freestack"(n s); \
& c$

Now $not$ and $~$ are eliminated!
