#import "../Prelude.typ": *
#import "@preview/curryst:0.5.1": prooftree, rule

#let stlc = [simply typed lambda calculus]

#let lc = flex(
  prooftree(rule($Gamma tack x: sigma$, $x:sigma in Gamma$, name: "Var")),
  [],

  prooftree(
    rule(
      $Gamma tack lambda x:sigma. space e : sigma -> tau$,
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

== Lambda calculus and linear types

This section aims to remind the reader of the lambda calculus and some of its
variants, we assume familiarity with the untyped lambda calculus and typing judgements.
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
    & #math.italic[Types] A "::=" A_1 -> A_2 | T \
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
calculus). The grammar of types is extended with type variables ($alpha$) and universal
quantification ($forall$). Two new terms are introduced to the grammar as well; type
abstraction and type application.

$
  & #math.italic[Types] A "::=" A_1 -> A_2 | T | alpha | forall alpha. A \
  & #math.italic[Terms] e "::=" x | e_1 e_2 | lambda x. e | Lambda alpha. e | e[A]
$

Where in #stlc variables range over terms and lambdas have binders for terms,
System F additionally introduces variables ranging over types as well as
binders for types. The context $Gamma$ is no longer only a mapping from
variables to types, it also includes type variables. Shown in @SystemF_rules
are the rules for type abstraction and type application.

#figure(
  caption: [Type abstraction and type application rules in System F],
  flex(prooftree(tabs), prooftree(tapp)),
) <SystemF_rules>

The syntax $sigma[tau slash alpha]$ means replace each occurence of $alpha$ with $tau$ in $sigma$.
As the reader might now be familiar with how proofs are read, we will give the
proof tree of how the identity function can be constructed and applied to the variable $y$ with
monomorphic type $A$. We assume that $y : A in Gamma$.


#let id_proof = prooftree(
  rule(
    $Gamma tack Lambda alpha. space lambda x : alpha. space x : forall alpha. space alpha -> alpha$,
    rule(
      $Gamma, alpha tack lambda x : alpha. space x : alpha -> alpha$,
      rule(
        $Gamma, alpha, x : alpha tack x : alpha$,
        $x : alpha in (Gamma, alpha, x : alpha)$,
      ),
    ),
  ),
)
#let metaid = math.bold[id]
#let id_app_proof = prooftree(
  rule(
    $Gamma tack #metaid\[A] space y : A$,
    rule(
      $Gamma tack #metaid\[A] : A -> A$,
      rule(
        $Gamma tack #metaid : forall alpha. alpha -> alpha$,
        $$,
      ),
    ),
    rule($Gamma tack y : A$, $y : A in Gamma$),
  ),
)

#figure(caption: [The identity function], flex(id_proof)) <id_proof>

We will use the meta symbol $#metaid$ to refer to the identity function in @id_proof.

#figure(caption: [Applying the identity function], flex(id_app_proof))

=== Linear types <LinearTypes>

The core idea of a linear type system is that variables must be used _exactly
once_. This means the typing relation $Gamma tack e : sigma$ no longer only
requires that the set of variables in $e$ are a subset of $Gamma$, but rather
that the set of variables in $e$ is $Gamma$.

This means the typing rules App and Var in @stlc_typing are no longer valid.

#let linear_app = prooftree(
  rule(
    name: "App",
    $Gamma, Delta tack e_1 e_2 : tau$,
    $Gamma tack e_1 : sigma lollipop tau$,
    $Delta tack e_2 : sigma$,
  ),
)

#let linear_abs = prooftree(rule(name: "Abs", $Gamma tack lambda x. e : sigma -> tau$, $Gamma, x: sigma tack e : tau$))
#let linear_var = prooftree(rule(name: "Var", $dot, x: A tack x: A$))

#figure(
  caption: [Typing rules for App, Abs, and Var in a linear type system],
  flex(
    linear_app,
    linear_abs,
    linear_var,
  ),
)<linear_rules>

The linear rules for App and Var are shown in @linear_rules. Note how the
contexts for $e_1$ and $e_2$ in App are disjoint, i.e. $Gamma$ and $Delta$ must
not share any variables. Similarily, the rule for Var, also depicted in
@linear_rules differs from its simply typed variant, which now requires that
the context contains only the variable $x: A$. This is a great restriction of
the system as many simple terms are no longer valid. For example, the term in @const_term
would not have a valid derivation.

#figure(
  caption: [A lambda term that discards a variable],
  $lambda x. lambda y. x : sigma -> (tau -> sigma)$,
)<const_term>

Linear logic, and in turn linear types, solves this issue using _exponentials_.
Exponentials introduce an explicit way to duplicate and discard variables.

#let exponential_rules = flex(
  prooftree(rule(name: [Read], $Gamma, !A tack B$, $Gamma, A tack B$)),
  prooftree(rule(name: [Disc], $Gamma, !A tack B$, $Gamma tack B$)),
  prooftree(rule(name: [Dupl], $Gamma, !A tack B$, $Gamma, !A, !A tack B$)),
  prooftree(rule(name: [Promote], $!Gamma tack !A$, $!Gamma tack A$)),
)

#figure(
  caption: [Typing rules for exponentials. $!Gamma$ represents a sequence $!A_1,..., !A_n$],
  exponential_rules,
)<exponential_rules>

Using the rules in @exponential_rules, it is possible to create terms that discard and
reuse variables.

=== Polarised Linear Logic

hej då
