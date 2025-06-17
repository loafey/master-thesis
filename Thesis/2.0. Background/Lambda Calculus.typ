#import "../Prelude.typ": *
#import "@preview/curryst:0.5.1": prooftree, rule

#let stlc = [simply typed lambda calculus]

#let lc = flex(
  prooftree(rule($Gamma, x : sigma tack x: sigma$, $$, name: "Var")),
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
variants. We assume familiarity with the untyped lambda calculus and typing rules.
We introduce the simply typed lambda calculus, extend it with
polymorphic types, and introduce linear types.

=== Simply Typed Lambda Calculus <stlc>

The simply typed lambda calculus was first introduced by Alonzo Church to avoid the
paradoxical use of the untyped lambda calculus @church1940formulation as a proof system through the Curry-Howard correspondence. It
consists of two separate syntactic categories: the category of types and the category of terms. The two categories
correspond to types and computation, respectively. The syntax for #stlc is
shown in @stlc_syntax. The symbol $T$ is used to denote base types.

#figure(
  caption: [Syntax for #stlc.],
  $
    & #math.italic[Types] sigma, tau "::=" sigma -> tau | T \
    & #math.italic[Terms] e_1, e_2 "::=" x | e_1 e_2 | lambda x. e_1 \
  $,
)<stlc_syntax>

To ensure that terms in #stlc are well-typed, we define a relation between terms
and types. The typing relation uses the syntax $Gamma tack e: sigma$, which
says that in environment $Gamma$, the term $e$ has type $sigma$. The environment $Gamma$ is
a mapping from free variables to types. $Gamma, x : sigma$ is the environment that
extends $Gamma$ by associating the variable $x$ with $sigma$. If a dot ($dot$) is used in place of $Gamma$ then the environment is empty. The typing rules for
#stlc are shown in @stlc_typing.

#figure(caption: [Typing rules for #stlc.], lc)<stlc_typing>

The first rule, Var, says that $x : sigma$ is a term if the environment $Gamma$ contains the variable $x : sigma$.
The rule Abs, short for abstraction, also commonly
called \"lambda\" says that if the term $e : tau$ can be deduced in the environment $Gamma$ extended with $x: sigma$, then in the environment $Gamma$ the term
$(lambda x : sigma. space e)$ has type $sigma -> tau$.
The last rule, App, short for
application says that if in the environment $Gamma$ we have $e_1 : sigma -> tau$
and $e_2 : tau$ then in the environment $Gamma$ the term $e_1 e_2$ has type $tau$.

=== Polymorphic Lambda Calculus

The polymorphic lambda calculus is a typed lambda calculus that introduces universal quantification
over types @girard1972systemf. It was independently discovered by logician Girard in
1972 as System F and in 1974 by computer scientist Reynolds as Polymorphic lambda
calculus.

We extend the simply typed lambda calculus grammar with type variables ($alpha$) and universal
quantification ($forall$). The grammar of terms is also extended with type abstraction ($Lambda alpha. e$) and type application ($e[A]$).

$
  & #math.italic[Types] A "::=" A -> A | T | alpha | forall alpha. A \
  & #math.italic[Terms] e "::=" x | e e | lambda x. e | Lambda alpha. e | e[A]
$

Where in #stlc variables range over terms and lambdas have binders for terms,
the polymorphic lambda calculus additionally introduces variables ranging over types as well as
binders for types. The environment $Gamma$ is no longer only a mapping from
variables to types, it also includes type variables. Shown in @SystemF_rules
are the rules for type abstraction and type application.

#figure(
  caption: [Type abstraction and type application rules in polymorphic lambda calculus.],
  flex(prooftree(tabs), prooftree(tapp)),
) <SystemF_rules>

The syntax $sigma[tau slash alpha]$ means replace each occurrence of $alpha$ with $tau$ in $sigma$.
In the polymorphic lambda calculus we can implement the identity function. The derivation for the identity function and the identity function
applied to the variable $y$ with type $A$ can be seen in @id_proof and @id_apply_proof.


#let id_proof = prooftree(
  rule(
    $Gamma tack Lambda alpha. space lambda x : alpha. space x : forall alpha. space alpha -> alpha$,
    rule(
      $Gamma, alpha tack lambda x : alpha. space x : alpha -> alpha$,
      rule(
        $Gamma, alpha, x : alpha tack x : alpha$,
        $$,
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

#figure(caption: [The identity function.], flex(id_proof)) <id_proof>

We will use the meta-symbol $#metaid$ to refer to the identity function constructed in @id_proof to keep it concise.

#figure(
  caption: [Applying the identity function to the variable $y$ with type $A$.],
  flex(id_app_proof),
) <id_apply_proof>

=== Linear types <LinearTypes>

// Linear types come from linear logic, introduced by Girard in 1987 @girard1987linear.
// In linear logic, a deduction is no longer an ever-expanding collection of
// truths, but rather a way of manipulating resources that can not always be discarded our duplicated.

The core idea of a linear type system is that variables must be used _exactly
once_. This means the typing relation $Gamma tack e : sigma$ no longer only
requires that the set of free variables in $e$ are a subset of $Gamma$, but rather
that the set of free variables in $e$ are the set of variables in $Gamma$.
This means the typing rules App and Var in @stlc_typing are no longer valid.

The typing rules for a linear type system are shown in @linear_rules. Note how the
environments for $e_1$ and $e_2$ in App are disjoint, i.e. $Gamma$ and $Delta$ must
not share any variables. Similarly, the rule for Var, differs from its simply typed variant, which now requires that
the environment contains only the variable $x: A$. The arrow $lollipop$ is used instead of $->$ to denote linearity.

#let linear_app = prooftree(
  rule(
    name: "App",
    $Gamma, Delta tack e_1 e_2 : tau$,
    $Gamma tack e_1 : sigma lollipop tau$,
    $Delta tack e_2 : sigma$,
  ),
)

#let linear_abs = prooftree(
  rule(
    name: "Abs",
    $Gamma tack lambda x. e : sigma lollipop tau$,
    $Gamma, x: sigma tack e : tau$,
  ),
)
#let linear_var = prooftree(rule(name: "Var", $dot, x: sigma tack x: sigma$))

#figure(
  caption: [Typing rules for App, Abs, and Var in a linear type system.],
  flex(linear_app, linear_abs, linear_var),
)<linear_rules>

How would we derive terms that use a variable twice, or perhaps a term that does not use a variable?
Linear logic, and in turn linear types, solves this using _exponentials_.
Exponentials introduce an explicit way to duplicate and discard variables.
The rules for exponentials are shown in @exponential_rules.

#let exponential_rules = flex(
  prooftree(rule(name: [Derelict], $Gamma, x : !A tack e : B$, $Gamma, x : A tack e : B$)),
  prooftree(rule(name: [Discard], $Gamma, x : !A tack e : B$, $Gamma tack e : B$)),
  prooftree(rule(name: [Duplicate], $Gamma, x : !A tack e : B$, $Gamma, x : !A, x : !A tack e : B$)),
  prooftree(rule(name: [Promote], $!Gamma tack e : !B$, $!Gamma tack e : B$)),
)

#figure(
  caption: [Context and term rules for exponentials.],
  exponential_rules,
)<exponential_rules>

The function $!\_ : "Environment" -> "Environment"$, called \"bang\", is defined by:
$
  !(Gamma, x: sigma) & = (!Gamma, x: !sigma) \
  !(dot) & = dot
$
Note that \"bang\" is both a type constructor ($!A$) and a function on environments ($!Gamma$).
Because Derelict, Discard, and Duplicate manipulate the left-side of the
turnstyle, they are read bottom-to-top. The Promote rule manipulates the right-side
of the turnstyle, and is read top-to-bottom.
Syntactically we leave the terms for derelict, discard, and duplicate silent,
i.e. no explicit syntax is used to derelict, discard, and duplicate variables.
Now we can create a derivation for the term $lambda x. lambda y. y : !tau
lollipop sigma lollipop sigma$ that discards the variable $x$. The derivation
is show in @const_term.

#figure(
  caption: [Derivation of a linearly typed term that discards the variable $x$.],
  prooftree(
    rule(
      name: [Abs],
      $dot tack lambda x. lambda y. y : !B lollipop A lollipop A$,
      rule(
        name: [Discard],
        $dot, x : !B tack lambda y. y : A lollipop A$,
        rule(
          name: [Abs],
          $dot tack lambda y. y : A lollipop A$,
          rule(name: [Var], $dot, y : A tack y : A$),
        ),
      ),
    ),
  ),
) <const_term>

Linear types do not entirely prohibit the duplication and discarding of
variables, but rather make it explicit.
