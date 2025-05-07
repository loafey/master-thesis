#import "../Prelude.typ": *
#import "@preview/curryst:0.5.1": rule, prooftree
#import "@preview/biceps:0.0.1": flexwrap

#let stlc = [simply typed lambda calculus]

#let lc = flexwrap(
  main-spacing: 15pt,
  cross-spacing: 15pt,
  prooftree(
    rule(
      $Gamma tack x: sigma$,
      $x:sigma in Gamma$,
      name: "Var",
    ),
  ),
  [],

  prooftree(
    rule(
      $Gamma tack (lambda x:sigma. space e) : sigma -> tau$,
      $Gamma, x:sigma tack e: tau$,
      name: "Abs",
    ),
  ),
  prooftree(
    rule(
      $Gamma tack e_1 e_2: tau$,
      $Gamma tack e_1 : sigma -> tau quad Gamma tack e_2 : sigma$,
      name: "App",
    ),
  ),
)

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

== Programming languages with linear types

This section aims to remind the reader of the lambda calculus, and some of its
variants. We will assume the reader has encountered lambda calculus previously.

=== Simply Typed Lambda Calculus

Simply typed lambda calculus was first introduced by Church to avoid the
paradoxical use of the untyped lambda calculus @church1940formulation. It
consists of two worlds; the type world and the term world. The two worlds
correspond to logic and computation, respectively. The syntax for #stlc is
shown in @stlc_syntax.

#figure(
  caption: [Syntax for #stlc],
  $
    & #math.italic[Types] A "::=" A_1 -> A_2 | T \
    & #math.italic[Terms] e "::=" x | e_1 e_2 | lambda x. e
  $,
)<stlc_syntax>

To ensure that terms in #stlc are well-typed we define a relation between terms
and types. The typing relation uses the syntax $Gamma tack e: sigma$, which
says that in context $Gamma$, term $e$ has type $sigma$. The context $Gamma$ is
a mapping from free variables to types. $Gamma, (x : A)$ is the context that
extends $Gamma$ by associating the variable $x$ with $A$. The typing rules for
#stlc are shown in @stlc_typing.

#figure(
  caption: [Typing rules for #stlc],
  lc,
)<stlc_typing>

// The first rule reads: in context $Gamma$, the variable $x : sigma$ is a term if $x : sigma$ is in $Gamma$.
The first rule, Var, reads: if $x : sigma$ is in $Gamma$ then $x : sigma$ is
a term in context $Gamma$. The rule Abs, short for abstraction, also commonly
called lambda says that if, with context $Gamma$, extended with $x : sigma$ the
term $e : tau$ can be deduced, then in the context $Gamma$ without $x$,
$(lambda x : sigma. space e) : sigma -> tau$. The last rule, App, short for
application says that if in the context $Gamma$ we have $e_1 : sigma -> tau$
and $e_2 : tau$ then in the context $Gamma$ the term $e_1 e_2$ has type $tau$. 

=== Polymorphic Lambda Calculus (System F)

System F is a typed lambda calculus that introduces universal quantification
over types @girard1972systemf. It was first discovered by logician Girard in
1972 (System F) and in 1974 by computer scientist Reynolds (Polymorphic
lambda calculus).

$
  & #math.italic[Types] A "::=" A_1 -> A_2 | T | alpha | forall alpha. A \
  & #math.italic[Terms] e "::=" x | e_1 e_2 | lambda x. e | Lambda alpha. e | e[A]
$

Where in #stlc variables range over terms and lambdas have
binders for terms, System F additionally introduces variables ranging over
types as well as binders for types.

#grid(
  columns: (1fr, 1fr),
  align: center,
  prooftree(app), prooftree(abs),
)

=== Linear types (Substructural) <LinearTypes>

=== Polarised linear logic <PolarisedLinearLogic>
