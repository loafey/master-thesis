#import "../Prelude.typ": *


== Future Work
We have produced a solid base, but a lot of work is still there to be made...

Some features we would like to see are:

#indent[
  - Interface for making system calls
  - Exponentials

  - And a lot more!
]

== Interface for System Calls
In a system language it is nice to interact with the system.

#align(
  center + horizon,
  $"__sys__" : *(int times.circle int times.circle int times.circle int times.circle int times.circle int times.circle int times.circle ~int)$,
)

#align(
  center + horizon,
  [
    ```haskell
    exit : *~int
      = \k -> __sys__((60, 42, 0, 0, 0, 0, 0), k)
    ```
    $approx$
    ```asm
    exit:
      ...
      mov $60, %RAX
      mov $42, %RDI
      syscall

      subq $8, %R15 ; push the result
      movq %RAX, 0(%R15)
      ...
    ```],
)

// == Register Allocation
// Optimization technique to utilize physical registers for variables.

// #ln currently uses the system-stack for all variables, and only
// uses registers to keep track of the current stack, calculations and for FFI/SysCalls.

// Could lead to performance improvements,
// but can be hard to implement efficiently however!

== Exponentials
Allows a variable to be used more than once!
Incredibly useful in a lot of programs.

Adds:

#indent[
  - Exponential types: #raw(lang: "haskell", "!int") as opposed to just #raw(lang: "haskell", "int")#v(0.5cm)

  - Reference duplication: #raw(lang: "haskell", "let b + c = a;")\
    where: `a :: !A` $space->space$ `b, c :: !A`#v(0.5cm)

  - Dereferencing: #raw(lang: "haskell", "let !d = b;")\
    where: `b :: !A` $space->space$ `d :: A`
]
// #pagebreak()

// #{
//   set text(size: 10pt)
//   ```hs
//   fib : *(!int ⊗ ~int)
//     = \(n,k) ->
//         let n1 + z1 = n; -- duplicate as a pattern, not addition
//         let !z2 = z1;
//         __eq__((z2, 0), \res -> case res of {
//           inl () ->
//             let n2 + o1 = n1;
//             let !o2 = o1;
//             __eq__((o2, 1), \res -> {
//               inl () ->
//                 let n3 + p = n2;
//                 let !n3 = n3;
//                 let !n4 = p;
//                 fib((n3 - 1, \r1 ->
//                 fib((n4 - 2, \r2 ->
//                 k(r1 + r2)))));
//               inr () -> k(1);
//             });
//           inr () -> k(0);
//         });
//   ```
// }
// #pagebreak()
// With some syntax sugar would could make this pretty nice!

// #table(
//   columns: (auto, 1fr, auto),
//   stroke: rgb("00000009"),
//   raw(lang: "haskell", "k(*n + *n)"),
//   align(center, $=$),
//   raw(lang: "haskell", "let a + b = n; let !n1 = a; let !n2 = b; k(n1 + n2)"),
// )
// #{
//   set text(size: 10pt)
//   ```hs
//   fib : *(!int ⊗ ~int)
//     = \(n,k) ->
//       __eq__((*n, 0), \res -> case res of {
//         inl () ->
//           __eq__((*n, 1), \res -> case res of {
//             inl () ->
//               fib((*n - 1, \r1 ->
//               fib((*n - 2, \r2 ->
//               k(r1 + r2)))));
//             inr () -> k(1);
//           });
//         inr () -> k(0);
//       });
//   ```
// }
// Might look similar to `__dup__` but the idea is that this should work for any exponential type,
// not just int!
