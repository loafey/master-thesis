#import "../Prelude.typ": *
#import "@preview/curryst:0.5.1": rule, prooftree

== Programming languages with linear types

This section aims to remind the reader of the lambda calculus, and some of its
variants. We will assume the reader is somewhat knowledgeable

=== Simply Typed Lambda Calculus

The simply typed lambda calculus was first introduced by Church to avoid the
paradoxical use of the untyped lambda calculus @church1940formulation.

#let lc = grid(
  columns: (1fr, 1fr, 1fr),
  align: center,
  prooftree(rule($Gamma tack x: sigma$, $x:sigma in Gamma$)),
  prooftree(
    rule(
      $Gamma tack lambda x:sigma. e : sigma -> tau$,
      $Gamma, x:sigma tack e: tau$,
    ),
  ),
  prooftree(
    rule(
      $Gamma tack e_1 e_2: tau$,
      $Gamma tack e_1 : sigma -> tau quad Gamma tack e_2 : sigma$,
    ),
  ),
)

$
  & #math.italic[Terms] e "::=" x | e_1 e_2 | lambda x. e \
  & #math.italic[Types] A "::=" A_1 -> A_2 | T
$

For instance, in simply typed lambda calculus the identity
function for the monomorphic type $A$ would be $ lambda x. space x : A -> A $


=== Polymorphic Lambda Calculus (System F)

System F is a typed lambda calculus that introduces universal quantification
over types @girard1972systemf. It was first discovered by logician Girard in
1972 (System F) and in 1974 by computer scientist Reynolds (Polymorphic
lambda calculus).

$
  & #math.italic[Terms] e "::=" x | e_1 e_2 | lambda x. e | Lambda alpha. e | e[A] \
  & #math.italic[Types] A "::=" A_1 -> A_2 | T | alpha | forall alpha. A
$

In simply typed lambda calculus variables range over terms and lambdas have
binders for terms. System F additionally introduces variables ranging over
types as well as binders for types. The identity function in System F would now
be:

$
  Lambda alpha. lambda x^alpha. x : forall a. alpha -> a
$
where $alpha$ is a type variable and $x$ is a term variable.

#let app = rule(
  $Gamma tack M tau:sigma[tau slash alpha]$,
  $Gamma tack M:forall alpha. sigma$,
  name: emph[App],
)
#let abs = rule(
  $Gamma tack Lambda alpha. M: forall alpha. sigma$,
  $Gamma, alpha tack M:sigma$,
  name: emph[Abs],
)
#grid(
  columns: (1fr, 1fr),
  align: center,
  prooftree(app), prooftree(abs),
)

=== Linear types (Substructural)

=== Polarised linear logic
