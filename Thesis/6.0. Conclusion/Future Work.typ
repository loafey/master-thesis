#import "../Prelude.typ": *


== Future Work
As with any thesis involving the creation of a language, there
are of course more things that can be added to said language.

// === Utilizing linearity fully
// While #ln is a linear language it currently does

=== Register allocation
When optimizing the generated code, one important technique is
utilizing the physical registers for variable allocation. #todo("source")
If one were to implement this naively, it would suffice with putting the first few variables of a
function into registers, and the rest on the system stack.
This would however not necessarily suffice for larger functions, where one might have
more variables than registers as it might be more efficient to store a variable
declared later on as opposed to one declared early.
To combat this, an efficient compiler should move variables back onto the stack
(a process often called spilling) when they are not used, and back into registers when they are.
Doing this efficently can prove difficult as the compiler should try to minimize
the amount of spilling needed, and this has in fact been proven to be
NP-complete #todo("source"). This was not implemented for #ln as it was
deemed an optimization, that while interesting, not something we would have the time to
implement properly.

=== System Calls
As #ln is a system-level language, it might be useful to have the ability
to directly make system calls to interact with the operating system.
This allow for the possibility of not relying on, for example, LIBC,
as the behaviour one would need from LIBC could be re-implemented
in the language. This would in theory make the language more portable,
as it would be easier to port it to systems where LIBC might not be available.
System calls are used under the hood in the language, but it is not something
that is exposed to a user of the language.

=== Foreign Function Interface
Similarly to system calls, proper support for Foreign Function Interfaces (FFI)
would permit the language to interact with software outside.
A prime example of this would be libraries written in other languages,
or even libraries writen in #ln. Just like system calls, FFI is currently
used under the hood for printing and the likes using LIBC, but this is not
exposed to a user of the language.

=== Exponentionals
While linearity in a programming language is useful for managing resources
such as memory, sometimes one needs to use values more than once.
Consider a function for fibbonacci written in #ln:

```hs
fib : *(int ⊗ ~int)
  = \(n,k) -> case n == 0 of {
      inl unit -> let () = unit; k(0);
      inr unit -> let () = unit;
        case n == 1 of {
          inl unit -> let () = unit; k(1);
          inr unit -> let () = unit; fib((n - 1 + n - 2, k))
        }
    }
-- The equality operator `==` returns `inl ()` or `inr ()`,
-- depending on if the values were equal or not.
```

This function does sadly not compile, as the variable `n` is used 4 times,
and due to linearity one may only use it once!
To combat this issue we would want to introduce exponentials.

Exponentionals would let a user reuse a value multiple times opening up
for some much needed expressiveness. Take fibbonacci again with some imagitive
syntax introducing a `!` kind:

```hs
fib : *(!int ⊗ ~int)
  = \(n,k) ->
    let !n1 = n;
    case n1 == 0 of {
      inl unit -> let () = unit; k(0);
      inr unit -> let () = unit;
        let !n2 = n;
        case n2 == 1 of {
          inl unit -> let () = unit; k(1);
          inr unit -> let () = unit;
            let !n3 = n;
            let !n4 = n;
            fib((n3 - 1, \r1 ->
            fib((n4 - 2, \r2 ->
            k(r1 + r2)))))
        }
    }
```
As can be seen here, we can now re-use `n`, allowing us to actually write
fibbonacci.

By imagining some more syntax, we could simplify this even further!
If we were to introduce some sugar, for example a `?` operator,
which could simplify a term such as `let !n1 = n; let !n2 = n; k(n1 + n2)`
into: `k(n? + n?)`.
Rewriting fibbonacci with this operator could result in something like this instead:
```hs
fib : *(!int ⊗ ~int)
  = \(n,k) ->
    case n? == 0 of {
      inl unit -> let () = unit; k(0);
      inr unit -> let () = unit;
        case n? == 1 of {
          inl unit -> let () = unit; k(1);
          inr unit -> let () = unit;
            fib((n? - 1, \r1 ->
            fib((n? - 2, \r2 ->
            k(r1 + r2)))))
        }
    }
```


To avoid leaking memory, exponentials would need automatic de-allocation.
We would suggest using reference counting for this, but other methods such as
garbage collection could suffice.

#bigTodo("insert logic rules here plz :)")

=== Data Types
While the language currently contains sum and product types
($a plus.circle b$ and $a times.circle b$ respectively), having
types with named fields or constructors would be
useful for more complex types. It would also be required for recursive
types such as linked lists, which are currently not representable.

It would also be beneficial to have access to contiguous data types
such as arrays. In the paper "Linear types can Change the World" #todo[source]
Wadler introduces a way to implement arrays which could perhaps be mimicked.

=== Using #ln as a compilation target
While just writing #ln on its own would be nice, a good benchmark
and milestone of the languages capability would be another language using #ln
as a compilation target.

While the #ln is currently in the start up stage and lacks features such
as exponentials which would be required for more complex languages,
a simpler linear functional language could probably be compiled to #ln.
// A linear variant of a Lisp-or ML-like language could probably suffice for this purpose.
Currently not many of these do exist, but a subset of something like
Linear Haskell#todo[source] could provide a suitable goal. This would make
it easy to see what features or areas #ln is lacking in,
making future goals clearer.
