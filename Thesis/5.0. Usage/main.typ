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

#bigTodo[fibbo]
And the same program rewritten in C:

#bigTodo[fibbo-c]

And once again written in C but in a way that utilizes the language in a better manner:

#bigTodo[fibbo-c-but-good]


=== Benchmarks
#import "@preview/cetz:0.3.2": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot, chart

#let lithiumResults = csv("benches/Lithium.csv")
#let cGoodO3 = csv("benches/C Good O3.csv")
#let cGoodO0 = csv("benches/C Good O0.csv")
#let cBad03 = csv("benches/C Bad O3.csv")
#let cBadO0 = csv("benches/C Bad O0.csv")
#let style = (stroke: black, fill: rgb(0, 0, 200, 75))
#let m = 1000;
#let fn = (
  // ("Lithium Min", x => float(lithiumResults.at(calc.floor(x + 1)).at(1)) * m),
  // ("Lithium Max", x => float(lithiumResults.at(calc.floor(x + 1)).at(2)) * m),
  ("Lithium - Avg", x => float(lithiumResults.at(calc.floor(x + 1)).at(3)) * m),
  // ("cBad03 Min", x => float(cBad03.at(calc.floor(x + 1)).at(1)) * m),
  // ("cBad03 Max", x => float(cBad03.at(calc.floor(x + 1)).at(2)) * m),
  ("C, Recursive, O3 - Avg", x => float(cBad03.at(calc.floor(x + 1)).at(3)) * m),
  // ("cBadO0 Min", x => float(cBadO0.at(calc.floor(x + 1)).at(1)) * m),
  // ("cBadO0 Max", x => float(cBadO0.at(calc.floor(x + 1)).at(2)) * m),
  ("C, Recursive, O0 - Avg", x => float(cBadO0.at(calc.floor(x + 1)).at(3)) * m),
  // ("cGoodO3 Min", x => float(cGoodO3.at(calc.floor(x + 1)).at(1)) * m),
  // ("cGoodO3 Max", x => float(cGoodO3.at(calc.floor(x + 1)).at(2)) * m),
  ("C, Loop, O3 - Avg", x => float(cGoodO3.at(calc.floor(x + 1)).at(3)) * m),
  // ("cGoodO0 Min", x => float(cGoodO0.at(calc.floor(x + 1)).at(1)) * m),
  // ("cGoodO0 Max", x => float(cGoodO0.at(calc.floor(x + 1)).at(2)) * m),
  ("C, Loop, O0 - Avg", x => float(cGoodO0.at(calc.floor(x + 1)).at(3)) * m),
)
// #fn.at(0).at(1)(6)
#figure(
  caption: [
    Benchmark comparing the time needed to calculate the
    fibbonaci numbers 30 to 40 in the three different
    implementions. The C tests were compiled using GCC using O0 and O3.
    Time is measured in milliseconds.
  ],
  canvas({
    import draw: *

    // Set-up a thin axis style
    set-style(
      axes: (stroke: .2pt, tick: (stroke: .2pt)),
      legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 40%),
    )

    plot.plot(
      size: (12, 8),
      x-tick-step: 1,
      y-tick-step: m,
      y-min: 0,
      y-max: m * 8,
      axis-style: "left",
      legend: "inner-north",
      {
        let domain = (30, 40)

        for (title, f) in fn {
          plot.add(f, domain: domain, label: title)
        }
      },
    )
  }),
)

#bigTodo[fibbo-benchmark]
As can be seen in these benchmarks there is quite a large gap between the version
written in #ln and the two version written in C.

This can be attributed to several factors but the two most significant ones
are most likely that #ln is currently not optimized at all, and that
#ln does a lot more functions calls compared to the C implementations, and its calling
convention is heavier compared to System V#todo[source].

#bigTodo[program]
#bigTodo[program-c]
#bigTodo[program-c-benchmark]
