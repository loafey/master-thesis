#import "../Prelude.typ": *
#import "../3.0. System-level functional language/figures.typ": *

== Transformations <Transformations>

At this stage #ln is still a logic language. How do we bridge the gap between logic and machine?
This section goes into the necessary transformations to turn #ln into machine code.

#ln consists of three intermediate steps: linear closure conversion, stack
selection, and pointer closure conversion. The first step eliminates linear
closures, the second step ensures that each closure contains a stack to execute
on, and the third transformation, pointer closure conversion, replaces each
stack closure by an explicit pair of static function and environment.

=== Linear closure conversion

// Linear closure conversion: this is about making the stack pointers explicit.
// (As we saw earlier, it is critical for 1st order programming to identify the
// call stack. This phase introduces explicit call stacks.) The starting point
// is: □(∼ 𝐴)

It is critical for first-order programs to identify the call stack, that is,
the point where a procedure should return control when finishing execution. In
#ln, rather than returning control it is about where a procedure should continue when finishing
execution. The first step in this
process is making pointers to stacks explicit.

The linear closure conversion phase transforms $not A$ to $square (~A)$, making
the pointer explicit. Values are transformed in the following manner:
$ (lambda^not x. c): not A => square (lambda^~ x. c): square (~A) $ It is
important not to forget the negative fragment as well. Before calling
a function with type $not A$, which after conversion has type $square ~A$, we
have to follow the indirection to access the closure. If we have the call
$f(x)$ with $f : not A$ and $x : A$. After conversion the call would look like
this: $"let" square g = f; g(x)$. Lastly, since the type $not A$ is transformed
to $square ~A$, the type checker should allow $square ~A$ where $not A$ is
expected.

=== Stack Selection

It is important for every stack closure ($~A$) to identify a single unique stack that
it can execute on. Stack selection selects a single unique stack for every
closure if at least one stack exists, ensuring that every closure has _at most_ one stack
prepared. In @PointerClosureConversion we will explain why stack selection can
not guarantee that there is _exactly one_ stack prepared for every closure.

Consider the following program: 
$ lambda (f,k). space k(lambda y. space f(y)) : *(not A times.circle ~not A) $

After making the pointers to stacks explicit we end up with the following program:
$ lambda (f,k). space "let" square k' = k; space k'(lambda y. "let" square f' = f; space f'(y)) 
: *(square ~ A times.circle ~(square~A)) $

Because $k'$ has type $~(square~A)$, it must also be a stack. The issue is that the
only variable that is a stack is $f'$, but it can not be the chosen stack because 
bound variables are stored on the stack. The chosen stack must be a variable
that is bound outside the closure, or an explicit newstack.

Stack selection moves the $"let" square f' = f$ out of the closure, making $f'$
free in the closure, and selecting it as the stack.

The resulting program would end up being: 
$ lambda (f,k). space "let" square k' = k; "let" square f' = f; space k'(lambda y. space f'(y)) 
: *(square ~ A times.circle ~(square~A)) $ 

=== Pointer Closure Conversion <PointerClosureConversion>

The goal of the pointer closure conversion is to make the structure of stacks
explicit, replacing a stack closure by an explicit pair of static function
pointer and environment. At the assembly level the concept of procedures and
closures do not exist, there are only jumps (gotos) and labels.

The representation for $*A$ is straightforward; it is a label. Calling
a function of type $*A$ corresponds to jumping to the label. The pointer
closure conversion phase transforms $~A$ to $exists gamma. *(A times.circle
gamma) times.circle gamma$, eliminating both procedurs and closures. The
existential quantification is there because the structure of the environment is
unknown for the callee. Now we can see why type variables must have kind
$omega$; if they had kind $known$, then $*(A times.circle gamma)$ would be
ill-kinded, and we would have no way of representing the environment in the type.

#todo[
  Explain translation of values. 

  Explain translation of commands. 

  Explain why introducing newstacks is possible only after closures are explicit
]
