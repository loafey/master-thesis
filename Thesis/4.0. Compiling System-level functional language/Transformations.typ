#import "../Prelude.typ": *
#import "../3.0. System-level functional language/figures.typ": *

== Transformations <Transformations>

At this stage #ln is still a logic language. How do we bridge the gap between logic and machine?
This section goes into the necessary transformations to turn #ln into machine code.

There are three constructs in the language where it is not immediately obvious
how they can be represented as machine code. The first of which is the linear closure ($not$).
Remember the kind rule: #flex(linear_closure)

#ln consts of three steps, the conversion steps convert higher-level features
to lower level. Stack selection ensures that each function consist of at most
one stack.

- Linear closure conversion
- Stack selection
- Pointer closure conversion

=== Linear closure converison

The goal of the linear closure converion phase is to convert $not$

$(lambda^not x. c): not A => square (lambda^~ x. c): square (~A)$

$not$ is a source language construct only

After linear closure conversion we end up with:
$
  square lambda a. & "let" f,k = a; \
  &"let" square k' = k; \
  & k'(square lambda y. "let" square f' = f; f'(y))
$

After converting the type we end up with: $square ~(square ~ int times.circle square~square~int)$

//The astute reader will now realize that $not$ is a source language construct only. There is no compilation scheme that corresponds to it.


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

Now the inner closure contains a stack.

//We need to make sure each term consists of zero or one stack for the pointer
//closure conversion step. If it contains zero stacks, then the environment of
//the closure will create one using the _newstack_ primitive.

=== Pointer Closure Conversion

The goal of this phase is to make the structure of stacks explicit, replacing
a stack closure by an explicit pair of static function pointer and environment.
