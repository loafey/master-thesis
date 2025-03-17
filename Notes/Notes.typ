#import "Prelude.typ": *

= Types and kinds

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  row-gutter: 16pt,
  [Type], [Rule], [Env], [Style],
  [$*A$], [$(A : omega) / (*A : 1)$], [$0$], [Goto],
  [$~A$], [$(A : n) / (~A : omega)$], [$n ~> omega$], [Procedural],
  [$not A$], [$(A : n) / (not A : 1)$], [$n$], [Higher-order],
)

= PLL:
#grid(
  columns: (1fr, 1fr),
  row-gutter: 16pt,
  [Positive], [Negative],
  align(center)[$(Gamma tack.r t : A space space Delta tack.r u : B) / (Gamma, Delta tack.r (t,u): A times.circle B)$],
  align(center)[$(Gamma, x : A, y : B tack.r c) / (Gamma, z : A times.circle B tack.r text("let")(x,y) = z; c)$],

  [],
  stack(
    [$rho(z) ->$],
    [$A : n$],
    [$rho(x)$],
    [$rho(y) ->$],
    [$B : omega$],
    [$$],
  ),

  align(center)[$(Gamma tack.r t: A_1) / (Gamma tack.r text("inj")_1t : A_1 xor A_2)$],
  align(center)[$(Gamma, x : A_1 tack.r c_1) / (Gamma, z : A_1 xor A_2 tack.r text("case") z text("of")
      text("inj"_1 x |-> c_1))$],

  align(center)[$(Gamma, alpha tack.r : A) / (Gamma tack.r angle.l A,t angle.r: exists alpha. A)$],
  align(center)[$(Gamma, alpha, x : A tack.r c) / (Gamma, z : exists alpha . A tack.r text("let") angle.l alpha, x angle.r = z; c)$],

  align(center)[$(Gamma, x : Alpha tack.r c) / (Gamma tack.r lambda x . c : not A)$],
  align(center)[$(Gamma tack.r t : A) / (Gamma, z: not A tack.r text("call") z (t))$,],
)

= Kinds and explicit (linear) pointers
$n,m$: known length\
$omega$: stack-like
#grid(
  columns: (1fr, 1fr),
  row-gutter: 16pt,
  align(center)[$(A:n quad B:omega) / (A times.circle B : omega)$],
  align(center)[$(A:n quad B:m) / (A times.circle B : n+m)$],
)

= Defunctionalization, part 1: Explicit pointers

=== Stacks expect a non-stack argument:
#grid(
  columns: (1fr, 1fr, 1fr),
  row-gutter: 16pt,
  align(center)[$(A:n) / (tilde.op A:omega)$],
  align(center)[$(Gamma, x:A tack.r c) / (Gamma tack.r lambda^(tilde.op) x . c : space tilde.op A)$],
  align(center)[$(Gamma tack.r t:A) / (Gamma, z:tilde.op A tack.r text("call")^tilde.op z (t))$],
)

=== Pointers to stacks:
#grid(
  columns: (1fr, 1fr, 1fr),
  row-gutter: 16pt,
  align(center)[$(A : omega) / (square.stroked A : 1)$],
  align(center)[$(Gamma tack.r t:A) / (Gamma tack.r square.stroked t: square.stroked A)$],
  align(center)[$(Gamma,x : A tack.r c) / (Gamma, z:square.stroked A ⊢ "let" square.stroked x=z; c)$],
)

= Defunctionalization, part 2: Explicit closures

#grid(
  columns: (1fr, 1fr, 1fr),
  row-gutter: 16pt,
  align(center)[$() / (circle.stroked : omega)$],
  align(center)[$() / (tack.r "newstack" : circle.stroked)$],
  align(center)[$(Gamma tack.r c) / (Gamma, z : circle.stroked tack.r "freestack" z; c)$],
)

=== Code pointers:

#grid(
  columns: (1fr, 1fr, 1fr),
  row-gutter: 16pt,
  column-gutter: 10pt,
  align(center)[$(A : omega) / (ast.basic A : 1)$],
  align(center)[$(x : A tack.r c) / (tack.r lambda^* x . c: ast.basic A)$],
  align(center)[$(Gamma tack.r t:A) / {Gamma,z:ast.basic A tack.r "call"^* z (t)}$],

  [
    `(void*)(A)` In `C`

    Type $A$ here is !Sized. A pointer to a value of type $A$ is Sized.
    $A: omega$ because otherwise it does not need to be heap allocated?],
  [Compile $c$. Push pointer for $c$ on SP],
  [$t$ is a program that can prepare a memory area of type $A$ ],
)

=== FFI (Brainstorm)
$("void" f(Psi) : Delta quad Gamma |-> Psi quad Delta tack.r c) / (Gamma tack.r "ffi" f; c)$
Prepare $Psi$ from $Gamma$ follow $m$. Call $f$, compile $c$.

=== Terminology
- $A^bot = not A$
- $not A := A multimap bot$ : function that consumes $A$ and terminates
- $A \& B = not (not A xor not B)$
- $A amp.inv B = not (not A times.circle not B)$
- $A multimap B = not (A times.circle not B)$
- $forall alpha. alpha multimap alpha = not (exists alpha not not (alpha
        multimap not alpha)) = not (exists alpha (alpha multimap not alpha))$

#pagebreak()

== Compile
#grid(
  columns: (1fr, 1fr),
  row-gutter: 16pt,
  column-gutter: 16pt,
  [*Before*], [*After*],
  [$~A$],
  [$exists (gamma : omega) ast.basic (A times.circle gamma) times.circle gamma$],

  [_call f a_], [$<Gamma, (y, rho)> = f; "call" y(a, rho)$],
  [$lambda^tilde.basic x. c$],
  [$<times.circle.big Gamma, (lambda^ast.basic (x,rho). "split" rho . c), "pair" x>$],
)

== How to convert from $Gamma : n$ to $Delta : omega$?

Let $Xi$ be the subset ${ (y : square.stroked (A : omega)) | y : square.stroked A in Gamma}$

#enum(
  numbering: "A.",
  [$"len"(Xi) = 1 => square.stroked z = y; lambda^tilde.basic x. c [y |-> square.stroked z]$],
  [$"len"(Xi) > 1 => "Repeat A on the \"first\" element of" Xi$],
  [$"len"(Xi) = 0 => "let" z = "newstack"; lambda^tilde.basic. "freestack" z; c$],
)

== Linear closure conversion

#grid(
  columns: (1fr, 1fr),
  row-gutter: 16pt,
  column-gutter: 16pt,
  [*Before*], [*After*],
  [$not A$], [$square.stroked tilde.basic A$],
  [_call f a_], [$"let" square.stroked f = z; "call f a"$],
  [$lambda x. c$], [$square.stroked(lambda^tilde.basic x. c)$],
)

== Stack selection (New pass)

Make sure that every closure has 1 or 0 stacks.

LinCloConv -> StackSelection -> PtrCloConv

- Option 1: Make NewStack a constant

== Compilation Assumption

1. If we have $A: n$ then $S p$ points to a valid stack.
2. If we have $A : omega$ then $[| A |]$


== Compilation Scheme

=== Case: $omega$

#let sem(t) = {
  $bracket.l.double #t bracket.r.double$
}
#let judge(above, below) = {
  $#above / #below$
}

$S p $ is free to use after #sem[.]. $S p$ points to the stack.

#judge($Gamma tack.r t: A quad Delta tack.r u: B: omega$
       ,$Gamma, Delta tack.r A times.circle B$) = $#sem[(t,u)] = #sem[u]^omega; #sem[t]^n$

#judge($Gamma tack.r t: A$, $Gamma tack.r "inl" t: A plus.circle B$) = $#sem[t]; "push" 0$

=== Case: $n$
