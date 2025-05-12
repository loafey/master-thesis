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
#let fn = (
  ("Lithium Min", x => float(lithiumResults.at(calc.floor(x + 1)).at(1)) * 1000),
  ("Lithium Max", x => float(lithiumResults.at(calc.floor(x + 1)).at(2)) * 1000),
  ("Lithium Avg", x => float(lithiumResults.at(calc.floor(x + 1)).at(3)) * 1000),
  ("cGoodO3 Min", x => float(cGoodO3.at(calc.floor(x + 1)).at(1)) * 1000),
  ("cGoodO3 Max", x => float(cGoodO3.at(calc.floor(x + 1)).at(2)) * 1000),
  ("cGoodO3 Avg", x => float(cGoodO3.at(calc.floor(x + 1)).at(3)) * 1000),
  ("cGoodO0 Min", x => float(cGoodO0.at(calc.floor(x + 1)).at(1)) * 1000),
  ("cGoodO0 Max", x => float(cGoodO0.at(calc.floor(x + 1)).at(2)) * 1000),
  ("cGoodO0 Avg", x => float(cGoodO0.at(calc.floor(x + 1)).at(3)) * 1000),
  ("cBad03 Min", x => float(cBad03.at(calc.floor(x + 1)).at(1)) * 1000),
  ("cBad03 Max", x => float(cBad03.at(calc.floor(x + 1)).at(2)) * 1000),
  ("cBad03 Avg", x => float(cBad03.at(calc.floor(x + 1)).at(3)) * 1000),
  ("cBadO0 Min", x => float(cBadO0.at(calc.floor(x + 1)).at(1)) * 1000),
  ("cBadO0 Max", x => float(cBadO0.at(calc.floor(x + 1)).at(2)) * 1000),
  ("cBadO0 Avg", x => float(cBadO0.at(calc.floor(x + 1)).at(3)) * 1000),
)
#for i in range(0, 5) { [#fn.at(0).at(1)(i)\ ] }
// #fn.at(0).at(1)(6)
// uo
#canvas({
  import draw: *

  // Set-up a thin axis style
  set-style(
    axes: (stroke: .5pt, tick: (stroke: .5pt)),
    legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 80%),
  )

  plot.plot(
    size: (12, 8),
    x-tick-step: 5,
    // x-format: plot.formats.multiple-of,
    y-tick-step: 1000,
    y-min: 0,
    y-max: 9000,
    legend: "inner-north",
    {
      let domain = (30, 40)

      for (title, f) in fn {
        plot.add(f, domain: domain, label: title)
      }
    },
  )
})

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
