= PLL:
#grid(
  columns: (1fr, 1fr),
  row-gutter: 16pt,
  [Positive], [Negative],
  align(center)[$(Gamma tack.r t : A space space Delta tack.r u : B) / (Gamma, Delta tack.r (t,u): A times.circle B)$],
  align(center)[$(Gamma, x : A, y : B tack.r c) / (Gamma, z : A xor B tack.r text("let")(x,y) = z; c)$],
  align(center)[$(Gamma tack.r t: A_1) / (Gamma tack.r text("inj")_1t : A_1 xor A_2)$],
  align(center)[$(Gamma, x : A_1 tack.r c_1) / (Gamma, z : A_1 xor A_2 tack.r text("case") z text("of")
    text("inj"_1 x |-> c_1))$],
  align(center)[$(Gamma, alpha tack.r : A) / (Gamma tack.r angle.l A,t angle.r: exists alpha. A)$],
  align(center)[$(Gamma, alpha, x : A tack.r c) / (Gamma, z : exists alpha . A tack.r text("let") angle.l alpha, x angle.r = z; c)$],
  align(center)[$(Gamma, x : Alpha tack.r c) / (Gamma tack.r lambda x . c : not A)$],
  align(center)[$(Gamma tack.r t : A) / (Gamma, z: not A tack.r text("call") z (t))$,]
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
#grid(columns: (1fr, 1fr, 1fr), row-gutter: 16pt,
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

#grid(columns: (1fr, 1fr, 1fr), row-gutter: 16pt, column-gutter: 10pt,
align(center)[$(A : omega) / (ast.basic A : 1)$],
align(center)[$(x : A tack.r c) / (tack.r lambda^* x . c: ast.basic A)$],
align(center)[$(Gamma tack.r t:A) / {Gamma,z:ast.basic A tack.r "call"^* z (t)}$],
[
`(void*)(A)` In `C`

Type $A$ here is !Sized. A pointer to a value of type $A$ is Sized. $A: omega$ because otherwise it does not need to be heap allocated?],
[Compile $c$. Push pointer for $c$ on SP],
[$t$ is a program that can prepare a memory area of type $A$ ]//[Value $x$ is of type $A$, and $c$ is a continuation. Roughly: place the variable on the stack, set the program counter to $c$.]
)

=== Terminonogy
- $A^bot = not A$
- $not A := A multimap bot$ : function that consumes $A$ and terminates
- $A \& B = not (not A xor not B)$
- $A amp.inv B = not (not A times.circle not B)$
- $A multimap B = not (A times.circle not B)$
- $*A$ pointer to a value
- $square.stroked A$ is a pointer to a stack
