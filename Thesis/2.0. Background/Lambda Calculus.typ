#import "../Prelude.typ": *
#import "@preview/curryst:0.5.1": prooftree, rule

#let stlc = [simply typed lambda calculus]

#let lc = flex(
  prooftree(rule($Gamma tack x: sigma$, $x:sigma in Gamma$, name: "Var")),
  [],

  prooftree(rule(
    $Gamma tack (lambda x:sigma. space e) : sigma -> tau$,
    $Gamma, x:sigma tack e: tau$,
    name: "Abs",
  )),
  prooftree(rule(
    $Gamma tack e_1 e_2: tau$,
    $Gamma tack e_1 : sigma -> tau quad Gamma tack e_2 : sigma$,
    name: "App",
  )),
)

#let tapp = rule(
  $Gamma tack e[tau]:sigma[tau slash alpha]$,
  $Gamma tack e:forall alpha. sigma$,
  name: emph[TApp],
)
#let tabs = rule(
  $Gamma tack Lambda alpha. space e: forall alpha. sigma$,
  $Gamma, alpha tack e:sigma$,
  name: emph[TAbs],
)

== Programming languages with linear types

This section aims to remind the reader of the lambda calculus, and some of its
variants, we assume familiarity with the untyped lambda calculus.
We will introduce the simply typed lambda calculus, then extending it with
polymorphic types, and finally explain linear types.

=== Simply Typed Lambda Calculus

Simply typed lambda calculus was first introduced by Church to avoid the
paradoxical use of the untyped lambda calculus @church1940formulation. It
consists of two worlds; the type world and the term world. The two worlds
correspond to logic and computation, respectively. The syntax for #stlc is
shown in @stlc_syntax.

#figure(
  caption: [Syntax for #stlc],
  $
    & #math.italic[Types] A "::=" A_1 -> A_2 | T            \
    & #math.italic[Terms] e "::=" x | e_1 e_2 | lambda x. e \
  $,
)<stlc_syntax>

To ensure that terms in #stlc are well-typed we define a relation between terms
and types. The typing relation uses the syntax $Gamma tack e: sigma$, which
says that in context $Gamma$, term $e$ has type $sigma$. The context $Gamma$ is
a mapping from free variables to types. $Gamma, (x : A)$ is the context that
extends $Gamma$ by associating the variable $x$ with $A$. The typing rules for
#stlc are shown in @stlc_typing.

#figure(caption: [Typing rules for #stlc], lc)<stlc_typing>

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
1972 (System F) and in 1974 by computer scientist Reynolds (Polymorphic lambda
calculus). The grammar of types is extended with type variables and universal
quantification. Two new terms are introduced to the grammar as well; type
abstraction and type application.

$
  & #math.italic[Types] A "::=" A_1 -> A_2 | T | alpha | forall alpha. A \
  & #math.italic[Terms] e "::=" x | e_1 e_2 | lambda x. e | Lambda alpha. e | e[A]
$

Where in #stlc variables range over terms and lambdas have binders for terms,
System F additionally introduces variables ranging over types as well as
binders for types. Shown in @SystemF_rules are the two new rules introduced.

#figure(
  caption: [Type abstraction and type application rules in System F],
  flex(prooftree(tabs), prooftree(tapp)),
) <SystemF_rules>

// The rule for type abstraction says that if in the context $Gamma$ extended with
// $alpha$ the term $e$ has type $sigma$, then in the context $Gamma$ without
// $alpha$ then the term $Lambda alpha. space e$ has type $forall alpha. space sigma$.
Rather than explain how the proofs are read we will provide an example of how
they are used to construct the identity function, and apply it to the
monomorphic type $A$.

=== Linear types (Substructural) <LinearTypes>

=== Polarised linear logic <PolarisedLinearLogic> #todo[Move this to 3.0]
