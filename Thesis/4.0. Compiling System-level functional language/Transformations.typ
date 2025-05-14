#import "../Prelude.typ": *
#import "../3.0. System-level functional language/figures.typ": *

== Transformations <Transformations>

At this stage #ln is still a logic language. How do we bridge the gap between logic and machine?
This section goes into the necessary transformations to turn #ln into machine code.

#ln consists of three intermediate steps; linear closure conversion, stack
selection, and pointer closure conversion. The first step eliminates linear
closures, the second step ensures that each closure contains a stack to execute
on, and the third transformation, pointer closure conversion, replaces each
stack closure by an explicit pair of static closure and environment.

=== Linear closure conversion

// Linear closure conversion: this is about making the stack pointers explicit.
// (As we saw earlier, it is critical for 1st order programming to identify the
// call stack. This phase introduces explicit call stacks.) The starting point
// is: □(∼ 𝐴)

It is critical for first-order programs to identify the call stack, that is,
the point where a procedure should return control when finishing execution. In
the case of #ln it is about where a procedure should continue when finishing
execution because rather than where a procedure should return control, it is
about where a procedure should continue execution. The first step in this
process is making pointers to stacks explicit. This phase achieves this by
converting the type $not A$ to $square (~A)$, and similarly, values are
transformed in the following manner: $(lambda^not x. c): not A => square
(lambda^~ x. c): square (~A)$. It is important not to forget the negative
fragment as well. Before calling a function with type $not A$, which after
conversion has type $square ~A$, we have to unbox the closure. For instance, if
we have the call $f(x)$ with $f : not A$ and $x : A$. After conversion the call
would look like this: $"let" square g = f; g(x)$. Since the conversion happens
from $not A$ to $square ~A$, we can always treat $not A$ as $square ~A$.
#todo[expand on this bit]

=== Stack Selection

In the final closure conversion step we make environments explicit and make
sure that each closure contains a stack to execute on. However, because of how
the linear closure conversion step works closures will never contain a stack.
Since all closures are boxed there are no stacks, remember #judge($A:omega$, $square A: 1$).
This can be observed in the example where we see that $f$ is unboxed inside the
closure. The solution is to move the unboxing of $f$ outside the inner closure:
$
  square lambda a. & "let" f,k = a; \
  &"let" square k' = k; \
  &"let" square f' = f; \
  & k'(square lambda y. f'(y))
$
#todo[This section and example should be rewritten or cleaned up]

Now the inner closure contains a stack.

//We need to make sure each term consists of zero or one stack for the pointer
//closure conversion step. If it contains zero stacks, then the environment of
//the closure will create one using the _newstack_ primitive.

=== Pointer Closure Conversion

The goal of this phase is to make the structure of stacks explicit, replacing
a stack closure by an explicit pair of static function pointer and environment.
