= Demonstration
== Demonstration
The language is still in its early stages, but some software can be created!

#grid(
  columns: (1fr, 1fr),
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
)

#pagebreak()

#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot, chart
#let lithiumResults = csv("benches/Lithium.csv")
#let cBad03 = csv("benches/C Bad O3.csv")
#let cBadO0 = csv("benches/C Bad O0.csv")
#let style = (stroke: black, fill: rgb(0, 0, 200, 75))
#let m = 1000;
#let fn1 = (
  ("Lithium", (paint: blue), x => float(lithiumResults.at(calc.floor(x + 1)).at(3)) * m),
  ("C O0", (paint: red, dash: "densely-dashed"), x => float(cBadO0.at(calc.floor(x + 1)).at(3)) * m),
  ("C O3", (paint: green, dash: "dotted", thickness: 1.4pt), x => float(cBad03.at(calc.floor(x + 1)).at(3)) * m),
)
Currently sadly slower!
#canvas({
  import draw: *
  set-style(
    axes: (stroke: .2pt, tick: (stroke: .2pt)),
    legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 40%),
  )
  plot.plot(
    y-mode: "log",
    size: (10, 4),
    x-tick-step: 1,
    y-tick-step: 1,
    y-min: 1,
    y-max: m * 20,
    axis-style: "left",
    legend: "north-west",
    {
      let domain = (30, 40)

      for (title, stroke, f) in fn1 {
        plot.add(f, style: (stroke: stroke), domain: domain, label: title)
      }
    },
  )
})
The y axis represents milliseconds in a logartihmic fashion,
and x is the fibonnaci number we are evaluting.
