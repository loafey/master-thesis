#import "../Prelude.typ": *

= Future Work

== Future Work
We have produced a solid base, but a lot of work is still there to be made...

Some features we would like to see are:

#indent[
  - Control over how, and where stacks are allocated
  - Register allocation
  - Interface for making system calls
  - Interface for Foreign Function Interface
  - Exponentials
  - Data types
  - A project using #ln as a compilation target

  - Probably a lot more that we don't know about yet...
]


== Register Allocation
Optimization technique to utilize physical registers for variables.

#ln currently uses the system-stack for all variables, and only
uses registers to keep track of the current stack, temporary registers
for calculations and for FFI.

Could lead to performance improvements,
but can be hard to implement efficiently however!

== Exponentials
Allows a variable to be used more than once!
Incredibly useful in a lot of programs.

#{
  set text(size: 10pt)
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
  ```
}
#pagebreak()
With some syntax sugar would could make this pretty nice!

#table(
  columns: (auto, 1fr, auto),
  stroke: rgb("00000009"),
  raw(lang: "haskell", "k(*n + *n)"),
  align(center, $=$),
  raw(lang: "haskell", "let a + b = n; let !n1 = a; let !n2 = b; k(n1 + n2)"),
)
#align(center)[


]
#{
  set text(size: 10pt)
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
              k(r1 + r2)))));
          };
      };
  ```
}
Might look similar to `__dup__` but the idea is that this should work for any type,
not just int!
