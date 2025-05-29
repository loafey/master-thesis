#import "../Prelude.typ": *

== Usage<Fibbo>
Fibonacci is not the most the most interesting program,
but from the standpoint of linearity it is _somewhat_ interesting, as
it requires the reuse of variables:

#align(
  center,
  grid(
    row-gutter: 10pt,
    $F_n = F_(n - 1) + F_(n - 2)$,
    $F_0 = 0$,
    $F_1 = 1$,
  ),
)

The following are two different implementations, one in Lithium,
and a recursive one in C.

This program uses the compiler defined functions `__dup__` and `__eq__`.
`__dup__` has the type signature $*(int times.circle ~(int times.circle int))$,
which means it takes a tuple of an integer to duplicate, and a continuation that takes the
two new integers as argument.
`__eq__` has type signature $*(int times.circle int times.circle ~(fatone plus.circle fatone))$. 
This function takes two integers to check for equality, and a continuation that takes the result as argument.
The value `inl ()` represents true and the value `inr ()` represents false.

#block(
  breakable: false,
  fancyTable(
    columns: (1.2fr, 1fr),
    [A #ln version:],
    [A recursive version made in C:],
    table.cell(
      colspan: 1,
      ```haskell
      fib : *(int ⊗ ~int) =
        \n,k ->
          __dup__(n,      \n,n'    ->
          __eq__((n', 0), \is_zero ->
          case is_zero of {
            inl () ->
              __dup__(n,      \n,n'   ->
              __eq__((n', 1), \is_one ->
              case is_one of {
                inl () ->
                  __dup__(n, \n,m ->
                  fib((n-1), \n   ->
                  fib((m-2), \m   ->
                  k(n+m))));
                inr () -> k(n);
              }));
            inr () -> k(n);
          }));
      ```,
    ),

    ```c
    long fib(long m) {
      if (m == 0 || m == 1) {
        return m;
      }
      long a = fib(m - 1);
      long b = fib(m - 2);
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
  ),
)


=== Benchmarks
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot, chart

#let lithiumResults = csv("benches/Lithium.csv")
#let cBad03 = csv("benches/C Bad O3.csv")
#let cBadO0 = csv("benches/C Bad O0.csv")

// #figure(
//   caption: [
//     Benchmark comparing the average time needed to calculate the
//     fibonacci numbers 30 to 40 in the two different
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

#let style = (stroke: black, fill: rgb(0, 0, 200, 75))
#let m = 1000;
#let fn1 = (
  ("Lithium", (paint: blue), x => float(lithiumResults.at(calc.floor(x + 1)).at(3)) * m),
  ("C O0", (paint: red, dash: "densely-dashed"), x => float(cBadO0.at(calc.floor(x + 1)).at(3)) * m),
  ("C O3", (paint: green, dash: "dotted", thickness: 1.4pt), x => float(cBad03.at(calc.floor(x + 1)).at(3)) * m),
)
The y-axis in the benchmark represents time measured in milliseconds, and the
x-axis represents the input to the fibonacci function. Note that the y-axis grows logarithmically.

#figure(
  caption: [
    Benchmark comparing the average time needed to calculate the
    Fibonacci numbers 30 to 40 in the two different
    implementations.
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

            for (title, stroke, f) in fn1 { plot.add(f, style: (stroke: stroke), domain: domain, label: title) }
          },
        )
      },
    ),
  ],
)<fibbo-benchmarks>

#let fn2 = (
  ("Lithium", (paint: blue), x => float(lithiumResults.at(calc.floor(x + 1)).at(3)) * (m / 10)),
  ("C O0", (paint: red, dash: "densely-dashed"), x => float(cBadO0.at(calc.floor(x + 1)).at(3)) * m),
  ("C O3", (paint: green, dash: "dotted", thickness: 1.4pt), x => float(cBad03.at(calc.floor(x + 1)).at(3)) * m * 2.3),
)
#let overlap = canvas({
  import draw: *
  set-style(
    axes: (stroke: .2pt, tick: (stroke: .2pt)),
    legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 40%),
  )
  plot.plot(
    y-mode: "log",
    size: (12, 2),
    x-tick-step: 100,
    y-tick-step: 100,
    y-min: 5,
    y-max: m,
    axis-style: "left",
    legend: "north-west",
    {
      let domain = (30, 40)

      for (title, stroke, f) in fn2 { plot.add(f, style: (stroke: stroke), domain: domain, label: title) }
    },
  )
})

As can be seen in the benchmarks in @fibbo-benchmarks there is quite a
large gap between the version written in #ln and the version written in C.
Each input was measured 100 times.
The C version was compiled using GCC with O0 and O3.
However, while the #ln version is around one order of magniture slower than the unoptimized C verison,
the growth in execution time is a constant factor between all three programs.

This can be observed even more clearly if we overlap the benchmarks over
each other, and then we can see that the unoptimized C version grows
the same way as the #ln version, while the optimized C version is slightly
more efficient.
#figure(caption: [Benchmarks from @fibbo-benchmarks overlapped], overlap)

The performance difference we can see @fibbo-benchmarks
can be attributed to several factors but the two most significant ones
are most likely that #ln is currently not optimized at all, and it
generates more code than is likely necessary. Also worth to note
that the calling convention is less performant than System V @SystemVmatz2013system which
C uses. System V prioritizes passing arguments using registers while #ln strictly passes arguments on stacks.

// Overall a benchmark is currently not necessarily that interesting #todo[Either remove the entire chapter or this paragraph] in #ln current state.
// They are presented here nonetheless to showcase some of the language's current capabilities.


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
//     fibonacci numbers 30 to 40 in the two different
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
// as with the C version, this is not the most optional way to write fibonacci in Haskell,
// nor is it the best benchmark as it is a heavier language relying upon an entire runtime.
// It is presented here as an interesting sidenote, nothing more.
