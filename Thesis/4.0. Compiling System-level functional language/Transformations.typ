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

=== Linear closure converison

Remember the kind for the linear closure: ($(A : n) / (not A: n)$). As neither
$A$ or $not A$ are stacks we have to introduce a stack somewhere. We can
introduce a stack by converting it into a stack closure ($(A :n) / (~
A : omega) $). This changes the kind of the type from $n$ to $omega$. 
This is solved by introducing the linear pointer ($(A: omega) / (square A : n)$).
The type $not A$ is thus converted to $square (~A)$.
Similarily, values are transformed in the following manner:
$(lambda^not x. c): not A => square (lambda^~ x. c): square (~A)$

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
