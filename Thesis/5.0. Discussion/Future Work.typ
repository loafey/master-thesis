#import "../Prelude.typ": *


== Future Work<FutureWork>
Developing a language and a compiler is a continuous process of refinement and
discovery, seldom with a clear finish line in sight. In this chapter we discuss
some features to work on in the immediate future. The proposed future work is
listed in no particular order.

=== Compiler interface for creating stacks
In the current implementation of #ln, all stacks are heap-allocated. This can
lead to unnecessary overhead, and can be a hindrance for using the language on
more restricted platforms such as embedded devices. To mitigate this, giving
the developer the option to allocate stacks on the system stack would work
(maybe as a compiler flag or as a linked library).

To implement this the language would need to include a runtime which can keep
track of which memory regions on the system stack are currently in use, to make sure
that stacks are not overlapping. It is also important to allocate these dynamic stacks
_above_ the programs singular stack frame (remember: the stack grows downwards).
This is important because accessing memory below the stack pointer is considered
undefined behavior on a lot of platforms because hardware or an OS may potentially
use that memory for things such as interrupts or exceptions.
This is similar in concept to GCC's split stacks, which lets threads share
a fragmented stack, leading to less allocations.

Another feature that can be added is to add an option allowing discontiguous stacks,
similarly to GCC's split stack option. Newly allocated stacks start out as
small, and as the stacks start being filled, a new stack is allocated (either on
the heap, or on the system stack) and linked to the old stack.
This would allow stacks to be small, but grow in size dynamically if need be.
Implementing this would place some requirements on the push and pop push semantics
however, because we would need to keep track of
the stack size while the program is running, and allocate more memory if need be.
This bookkeeping could have an impact on performance, and should ideally be
as fast as possible. Overall, this option would effectively trade a little
bit of performance for potentially more effective memory usage.
// For programs that do not allocate a large number of stacks, which
// all differ a lot in allocation sizes, this would probably not be a benefit.

=== Register allocation
When optimizing the generated code, one important technique is utilizing the
physical registers for variable allocation. If one were to implement this
naively, it would suffice to put the first few variables of a function
into registers, and the rest on the system stack.
This would however not
necessarily suffice for functions where there are more variables
than available physical registers. In this case it would be more efficient to analyze the usage of variables,
and prioritize them based on the order they are used.

// It might be more efficient to store a variable
// declared later on in a register as opposed to one declared early. #todo[review sentence]

Doing this efficiently can prove difficult because the compiler has to minimize
the amount of register spilling needed, and this has in fact been proven to be
NP-complete @RegisterAllocationbouchez2006register. This was not implemented for #ln because it was
deemed an optimization that, while interesting, was not something we would have time to
implement properly.

=== System Calls
Due to #ln being a system-level language, it may be useful to have the ability
to directly make system calls to interact with the operating system.
This allows for the possibility of not relying on, for example, libc,
because the behavior one would need from libc could be re-implemented
in the language. This would in theory make the language more portable,
because it would be easier to port it to systems where libc might not be available.
System calls are used under the hood in the language, but it is not something
that is exposed to a user of the language.
One simple approach would be to implement a compiler function, similar to
`__dup__` and `__eq__` called `__sys__`. This function would have the type
signature $*(int times.circle \"(int + fatone) dot 6\" ~int)$, where the meta
syntax $\"(int + fatone) dot 6\"$ stands for the 6-tuple of $int + fatone$, which is used for optionality. The
first argument would be the number of the system call, and the 6-tuple
represents the arguments passed to it.

=== Foreign Function Interface
Similarly to system calls, proper support for Foreign Function Interfaces (FFI)
would permit the language to interact with software outside.
A prime example of this would be libraries written in other languages.
Just like system calls, FFI is currently
used under the hood for printing and the likes using libc, but this is not
exposed to a user of the language.

=== Exponentials
While linearity in a programming language is useful for managing resources
such as memory, sometimes one needs to use values more than once.
Consider the fibonacci function where we do not use `__dup__`:
```hs
fib : *(int ⊗ ~int)
  = \(n,k) -> __eq__((n,0), \res -> case res of {
    case res of {
        inl () -> k(0);
        inr () ->
          __eq__((n,0), \res -> case res of {
            inl () -> k(1);
            inr () ->
              fib((n-1, \r1 ->
              fib((n-2, \r2 -> k(r1 + r2)))))
          })
      }
  })
```

This function does not compile sadly, because the variable `n` is used 4 times,
and due to linearity one may only use it once!
To address this issue we would want to introduce exponentials.

Exponentials would let a user reuse a value multiple times opening up
for some much needed expressiveness. Take Fibonacci again with syntax for
duplicating exponential variables and reading exponential variables. The variable $z$ has type $!A$

#indent[
  - $"let" a + b = z$: the environment is extended with $a: !A$ and $b: !A$
  - $"let" !z_1 = z$: the environment is extended with $z_1: A$.
]

The first extension corresponds to the Duplicate rule in @linear_rules, and the
second one corresponds to Derelict in the same figure.
We would also need syntax for Promote and Discard, but we leave that to the reader's imagination.

#block(
  breakable: false,
  ```hs
  fib : *(!int ⊗ ~int)
    = \(n,k) ->
        let n1 + z1 = n; -- duplicate as a pattern, not addition
        let !z2 = z1;
        __eq__((z2, 0), \res -> case res of {
          inl () -> k(0);
          inr () ->
            let n2 + o1 = n1;
            let !o2 = o1;
            __eq__((o2, 1), \res -> {
              inl () -> k(1);
              inr () ->
                let n3 + p = n2;
                let !n3 = n3;
                let !n4 = p;
                fib((n3 - 1, \r1 ->
                fib((n4 - 2, \r2 ->
                k(r1 + r2)))))
            })
        })
  ```,
)
As can be seen here, we can now re-use the value in `n`, allowing us to write
the fibonacci function without compiler defined functions.

Although the function is now possible, it is still noisy.
If we were to introduce some syntax sugar, for example a `*` operator that combines both Duplicate and Derelict.
we could simplify the term: `let a + b = n; let !n1 = a; let !n2 = b; k(n1 + n2)`
to: `k(*n + *n)`.
Rewriting the fibonacci function with this operator would result in:
#block(
  breakable: false,
  ```hs
  fib : *(!int ⊗ ~int)
    = \(n,k) ->
      case *n == 0 of {
        inl () -> k(0);
        inr () ->
          case *n == 1 of {
            inl () -> k(1);
            inr () ->
              fib((*n - 1, \r1 ->
              fib((*n - 2, \r2 ->
              k(r1 + r2)))))
          }
      }
  ```,
)

Because exponentials create more than one reference to memory, we would need
automatic deallocation, or we risk leaking memory. This could be solved using
reference counting or garbage collection.

=== Data Types<DataTypes>
While the language currently contains sum and product types
($a plus.circle b$ and $a times.circle b$ respectively), having
types with named fields or constructors would be
useful for more complex types. It would also be required for recursive
types such as trees or linked lists.
Having access to contiguous data types such as the array is also a very useful thing
when contiguous memory is wanted.

// It would also be beneficial to have access to contiguous data types
// such as arrays. In the paper "Linear types can Change the World" @LinearTypeswadler1990linear
// Wadler introduces a way to implement arrays which could perhaps be mimicked.
//
// When deallocating memory for data types, it has to be done recursively _if_
// the type is recursive. A simple free would not suffice for these @LinearTypeswadler1990linear.

In other immutable languages such as Haskell, data is copied when
you operate on it. Take this Haskell function for example:
```asm
plus1 :: [Int] -> [Int]
plus1 xs = map (+1) xs
```
In Haskell any list you input into this function will be duplicated, returning
a new list while keeping the original, in case it is used again.
In a linear language the original list would no longer be usable, and this opens up
room for optimizations. Instead of working on a copy of the old list,
a linear language could mutate the original list in place.

As long as the size of the type contained by the list is not changed, a
function such as map can simply mutate the content, and thus just replace the original data.
This can lead to major performance benefits in programs where data is
pipelined in such a way where there is not a lot for need for duplication.

=== Using #ln as a compilation target
While just writing #ln on its own works, a good benchmark
and milestone of the language's capability would be another language using #ln
as a compilation target.

If the work presented in this chapter were implemented, then using #ln as
a compilation target would be feasible.
A future project could be to compile a subset of Linear Haskell @linearhaskell2017 (or other linear functional languages) to #ln.
This would make it easy to see what features or areas #ln is lacking in, making future goals clearer.

// While #ln is currently in the start up stage and lacks features such
// as exponentials which would be required for more complex languages,
// a simpler linear functional language could probably be compiled to #ln.
// // A linear variant of a Lisp-or ML-like language could probably suffice for this purpose.
// Currently not many of these do exist, but a subset of something like
// Linear Haskell @linearhaskell2017 could provide a suitable goal. This would make
// it easy to see what features or areas #ln is lacking in,
// making future goals clearer.
