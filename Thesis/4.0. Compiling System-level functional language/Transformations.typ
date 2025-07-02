#import "../Prelude.typ": *
#import "../3.0. System-level functional language/figures.typ": *

== Transformations <Transformations>

So far we have only seen #ln as a lambda calculus. In this section we
go into the necessary transformations made to types, values, and commands, to turn
#ln into a sublanguage which can then be mapped to assembly.

The first three phases of the #ln compiler are:
+ Linear closure conversion: makes pointers to stacks explicit (@LinearClosureConversion)
+ Stack selection: ensures that every stack closure contains at most one stack to execute on (@StackSelection)
+ Pointer closure conversion: replaces each stack closure by an explicit pair of a static function and environment (@PointerClosureConversion)

Although the transformations perform source-to-source transformations, only
a subset of the full #ln syntax remains after pointer closure conversion.

=== Linear closure conversion <LinearClosureConversion>

It is critical for first-order programs to identify the call stack, i.e.
where a procedure should return control when finishing execution. The
first step in this process is making pointers to stacks explicit.
We do this by transforming types and closure values in the following manner:

#grid(
  columns: (1fr, 1fr),
  stroke: black + 0.1pt,
  inset: 10pt,
  [Source], [Target],
  $not A$, $square~A$,
  $lambda^not x. c$, $square lambda^~ x. c$,
)

We must not forget to transform the commands as well. Before calling
a function with type $not A$, which after conversion has type $square ~A$, we
have to follow the indirection to access the closure.

#block(breakable: false, grid(
  columns: (1fr, 1fr),
  stroke: black + 0.1pt,
  inset: 10pt,
  [Source], [Target],
  $f(x)$, $"let" square g = f; g(x)$,
))

Because the type $not A$ is transformed
to $square ~A$, the type checker allows the type $square ~A$ where the type $not A$ is
expected.

In the typing rules in @TypesAndValues, we have seen that linear closures
require the environment $Gamma$ to have kind $known$, which means $Gamma$ does
not contain a stack. However, because linear closures are transformed to stack
closures behind linear pointers, the environment for stack closures end up
being ill-kinded. In the next two sections (@StackSelection and @PointerClosureConversion)
we explain how this is remedied.

=== Stack Selection <StackSelection>

It is important for every stack closure ($~A$) to identify a single unique stack that
it can execute on. The stack selection phase selects a single unique stack for every
closure if at least one stack exists, ensuring that every closure has _at most_ one stack
prepared. The reason we cannot guarantee that there is _exactly one_ stack
prepared is because stacks have not been made explicit yet.
In @PointerClosureConversion we will show the necessary transformations to make
stacks explicit, and how to introduce new stacks.

Consider the following program:
$ lambda (f,k). space k(lambda y. space f(y)) : ast.basic (not A times.circle ~not A) $

Which, after linear closure conversion, becomes this:
$
  lambda (f,k). space k(square lambda y. "let" square f' = f; space f'(y))
  : ast.basic (square ~ A times.circle ~(square~A))
$

Because $k$ has type $~(square~A)$, its environment must be a stack.
The problem is that the environment is now ill-kinded.
Fortunately, the variable $f' : ~ A$ has kind $omega$, but it is
bound inside the closure, which means the pointer to it must be stored on the stack.
The stack that the closure identifies must be a variable that is bound outside
the closure i.e. a free variable, or an explicit newstack.

The stack selection phase moves the $"let" square f' = f$ out of the closure, making $f'$
free in the closure, thus making it a valid option.

The resulting program would end up being:
$
  lambda (f,k). space "let" square f' = f; space k(lambda y. space f'(y))
  : ast.basic (square ~ A times.circle ~(square~A))
$

// f : #~A
// f' : ~A
// k : ~(~#A)

Now $lambda y. f'(y) :$ contains exactly the stack $f'$.

=== Pointer Closure Conversion <PointerClosureConversion>

The goal of the pointer closure conversion is to make the structure of stacks
explicit, replacing a stack closure by an explicit pair of a static function
pointer and an environment. At the assembly level the concept of procedures and
closures do not exist, there are only jumps (gotos) and labels.

The representation for $ast.basic A$ is straightforward; it is a label. Calling
a function of type $ast.basic A$ corresponds to jumping to the label. Because labels and
jumps are the only thing available to us at the assembly level, we need to
transform $~$ to $ast.basic$, and we need to make the closure explicit.

The pointer closure conversion phase transforms $~A$ to $exists gamma. ast.basic (A
  times.circle gamma) times.circle gamma$, eliminating both procedures and
closures. The existential quantification is there because the structure of the
environment is unknown for the callee. Now we can see why type variables must
have kind $omega$; if they had kind $known$, then $ast.basic (A times.circle gamma)$
would be ill-kinded, and we would not be able to represent the environment
in the type.

Values and commands need to be transformed as well to ensure that they match the types.
Stack closures $(lambda^~)$ are transformed in the following manner:
#grid(
  columns: (1fr, 2fr),
  stroke: black + 0.1pt,
  inset: 10pt,
  [Source], [Target],
  $~A$, $exists gamma. ast.basic (A times.circle gamma) times.circle gamma$,
  $lambda^~ . c$,
  $#angled($times.circle.big Gamma$, $((lambda^* (x, rho) . "unpairAll"(Gamma, rho); c), "pairvars"(Gamma))$)$,
)
$Gamma$ represents the free variables in the closure.
$times.circle.big Gamma$ is short for $A_1 times.circle A_2 times.circle ... times.circle A_n$.
If $Gamma$ has kind $known$, then $"pairvars"$ must construct a newstack
($circle$). For example: if $Gamma = dot, a : A: known, b : B: known$, then the output
of $"pairvars"$ will be $(a, b, newstack)$.
$"unpairAll"$ is a macro that inverts this procedure, i.e.
$
  "unpairAll"(Gamma, rho) = & "let" a,rho_1 = rho; \
                            & "let" b,n s = rho_1;
$

The first argument of $"unpairAll"$ is the statically known environment
$Gamma$, and the second argument is the variable name of the lambda bound
environment. $"unpairAll"$ should insert the let-binds, keeping the original names of the variables.

Because the closures are converted, the corresponding commands must also be
transformed to match. Fortunately, the transformation is straightforward:

#grid(
  columns: (1fr, 2fr),
  stroke: black + 0.1pt,
  inset: 10pt,
  [Source], [Target],
  $z(a)$, $"let" angled(alpha, z_1) = z; "let" z_2, rho = z_1; z_2(a, rho)$,
)

The conversion can be easier to understand given an example. We will
show two examples: one for each kind of the environment.

Take the resulting program from @StackSelection.
$
  lambda (f,k). space "let" square f' = f; space k(lambda y. space f'(y))
  : ast.basic (square ~ A times.circle ~(square~A))
$

Because the closure $lambda y. f'(y)$ contains the stack $f'$, $"pairvars"$
does not need to construct a newstack. Transforming the program would yield the
following:

/*
\ b,c -> let #d = b;
         let @e, f = c;
         let g, h = f;
         g(◻(@ ∃γ . * (int ⊗ γ) ⊗ γ, \j,k -> let @l, m = k;
                                             let n, o = m;
                                             n (j, o), d), h)

*/
$
  lambda^*(f,k). & "let" square f' = f;           \
                 & "let" angled(alpha, k') = k;   \
                 & "let" g, rho_1 = k';         & \
                 & g(square #angled(
                       $@ exists gamma. ast.basic (A times.circle gamma) times.circle gamma$,
                       $(lambda^* (y, rho_2). & & "let" angled(beta, x) = rho_2; & \
                         & & & "let" h,rho_4 = x; & \
                         & & & h(y, rho_4), f')$,
                     )
                     , rho_1)
$

Because $k$ has type $exists gamma. ast.basic (A times.circle gamma) times.circle gamma$
after closure conversion, the second, and third rows are necessary to access the
static function $g : ast.basic (A times.circle gamma)$. The same process is repeated
inside the argument of $g$. Also, note how $f'$ is the environment inside $g$
now.

Let us now consider an example where a stack closure does not contain a stack in the environment.
Assume that the static function $"foo" : ast.basic A$ exists.

$ (lambda^~ x. "foo"(x)) : space ~A $

There is no stack in the environment of the closure; the conversion phase needs
to insert an explicit newstack to ensure that there is a stack to execute on.
After conversion this closure would end up being:
$
  #angled($circle$, $(lambda^* (x,rho_1). "freestack" rho_1; "foo"(x), newstack)$)
$

Now the environment is a stack, ensuring we have a stack to execute on. The empty stack must be freed before calling the static function $"foo"()$ to ensure that no memory is leaked.

