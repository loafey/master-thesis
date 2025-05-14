#import "../Prelude.typ": *

= Usage
As of this report #ln is in it's infancy and it is very limited, but #ln has been used
to write some smaller programs!

== Fibonacci
Fibonacci is not the most the most interesting program,
but from the standpoint of linearity it is _somewhat_ interesting, as
it reuses variables:
#align(
  center,
  grid(
    row-gutter: 10pt,
    $F_n = F_(n - 1) + F_(n - 2)$,
    $F_0 = 0$,
    $F_1 = 1$,
  ),
)
The following is two different implementions, one in Lithium,
and a recursive one in C. /*, and a recursive one in Haskell, as to compare it against
                          a mature functional programming language:*/
#fancyTable(
  columns: (1.2fr, 1fr),
  [A #ln verison:],
  [A recursive version made in C:],
  table.cell(
    colspan: 1,
    ```haskell
    fib : *(int ⊗ ~int) = \n,k ->
      n,n' <- __dup__(n);
      is_zero <- __eq__(n', 0);
      case is_zero of {
        inl () ->
          n,n' <- __dup__(n);
          is_one <- __eq__(n', 1);
          case is_one of {
            inl () ->
              n,m <- __dup__(n);
              n <- fib(n-1);
              m <- fib(m-2);
              k(n+m);
            inr () -> k(n);
          };
        inr () -> k(n);
      };
    ```,
  ),

  ```c
  long fib(long m) {
    if (m == 0 || m == 1) {
      return m;
    }
    long a = fib(n - 1);
    long b = fib(n - 2);
    return a + b;
  }
  ```,
  // table.cell(colspan: 2, [Haskell]),
  // table.cell(
  //   colspan: 2,
  //   ```haskell
  //   fib :: Int -> Int
  //   fib 0 = 0
  //   fib 1 = 1
  //   fib n = fib (n - 1) + fib (n - 2)
  //   ```,
)


=== Benchmarks
#import "@preview/cetz:0.3.2": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot, chart

#let lithiumResults = csv("benches/Lithium.csv")
#let cBad03 = csv("benches/C Bad O3.csv")
#let cBadO0 = csv("benches/C Bad O0.csv")

#let style = (stroke: black, fill: rgb(0, 0, 200, 75))
#let m = 1000;
#let fn1 = (
  ("Lithium", x => float(lithiumResults.at(calc.floor(x + 1)).at(3)) * m),
  ("C O0", x => float(cBadO0.at(calc.floor(x + 1)).at(3)) * m),
  ("C O3", x => float(cBad03.at(calc.floor(x + 1)).at(3)) * m),
)
// #figure(
//   caption: [
//     Benchmark comparing the average time needed to calculate the
//     fibbonaci numbers 30 to 40 in the two different
//     implementions. Each number was ran and timed 100 times.
//     Time is measured in milliseconds.
//     The C version was compiled using GCC using O0 and O3.
//   ],
//   stack(
//     canvas({
//       import draw: *
//       set-style(
//         axes: (stroke: .2pt, tick: (stroke: .2pt)),
//         legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 40%),
//       )
//       plot.plot(
//         size: (12, 4),
//         x-tick-step: 1,
//         y-tick-step: m * 2,
//         y-min: 0,
//         y-max: m * 8,
//         axis-style: "left",
//         legend: "inner-north",
//         {
//           let domain = (30, 40)

//           for (title, f) in fn1 {
//             plot.add(f, domain: domain, label: title)
//           }
//         },
//       )
//     }),
//   ),
// )

#figure(
  caption: [
    Benchmark comparing the average time needed to calculate the
    fibbonaci numbers 30 to 40 in the two different
    implementions. Each number was ran and timed 100 times.
    Time is measured in milliseconds, and displayed in a logarithmic manner.
    The C version was compiled using GCC using O0 and O3.
  ],
  [#canvas(
      {
        import draw: *
        set-style(
          axes: (stroke: .2pt, tick: (stroke: .2pt)),
          legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 40%),
        )
        plot.plot(
          y-mode: "log",
          size: (12, 4),
          x-tick-step: 1,
          y-tick-step: 1,
          y-min: 1,
          y-max: m * 20,
          axis-style: "left",
          legend: "north-west",
          {
            let domain = (30, 40)

            for (title, f) in fn1 { plot.add(f, domain: domain, label: title) }
          },
        )
      },
    ),
  ],
)<fibbo-benchmarks>

As can be seen in the benchmarks in @fibbo-benchmarks there is quite a
large gap between the version written in #ln and the version written in C.


This can be attributed to several factors but the two most significant ones
are most likely that #ln is currently not optimized at all, and its calling
convention is heavier compared to System V#todo[source].
Also worth to note that this is not the most performant implemention you can create in
C. A version using looping and some basic memoization is much more performant.

// #let haskellO0 = csv("benches/Haskell O0.csv")
// #let haskellO2 = csv("benches/Haskell O2.csv")
// #let fn2 = (
//   ("Lithium", x => float(lithiumResults.at(calc.floor(x + 1)).at(3)) * m),
//   ("Haskell O0", x => float(haskellO0.at(calc.floor(x + 1)).at(3)) * m),
//   ("Haskell O2", x => float(haskellO2.at(calc.floor(x + 1)).at(3)) * m),
// )
// #figure(
//   caption: [
//     Benchmark comparing the average time needed to calculate the
//     fibbonaci numbers 30 to 40 in the two different
//     implementions. Each number was ran and timed 100 times.
//     Time is measured in milliseconds.
//     The Haskell version was compiled with GHC using O0 and O2.
//   ],
//   canvas({
//     import draw: *

//     // Set-up a thin axis style
//     set-style(
//       axes: (stroke: .2pt, tick: (stroke: .2pt)),
//       legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 40%),
//     )

//     plot.plot(
//       size: (12, 8),
//       x-tick-step: 1,
//       y-tick-step: m,
//       y-min: 0,
//       y-max: m * 8,
//       axis-style: "left",
//       legend: "inner-north",
//       {
//         let domain = (30, 40)

//         for (title, f) in fn2 {
//           plot.add(f, domain: domain, label: title)
//         }
//       },
//     )
//   }),
// )

// As is to be expected, the Haskell version falls far behind both, but
// as with the C version, this is not the most optional way to write fibbonaci in Haskell,
// nor is it the best benchmark as it is a heavier language relying upon an entire runtime.
// It is presented here as an interesting sidenote, nothing more.
