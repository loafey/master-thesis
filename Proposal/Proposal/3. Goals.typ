#import "Prelude.typ": *

= Goals and planning
#green_text[
  The goal of this thesis is to extend the language of SLFL, as well as
  building a compiler for it. At the time of writing we are considering adding
  the following features to the language:
  - exponentials
  - records
  - recursive data types
  - laziness #todo[expand here?]

  For the compilation part we preliminary want to compile the language to LLVM @lattner2004llvm.
  Time will be spent on investigating if LLVM is a good compilation target, and if not, other
  low level targets such as x86-64 assembly will be considered.

  == Language extensions
  #todo[add text]
  === Exponentials
  #todo[figure out what this means, closures??]
  === Records
  While simple data types suffice in a lot of places, records provide important 
  context to data types, allowing for labeled fields.
  === Recursive data types
  When representing more complicated data types such as different types of trees or list
  in functional programming, they are almost always implemented using recursive data types.
  In theory this is fine, but in practice it leads to overhead such as pointer 
  indirection, bad cache locality and more. Due to the linearity of our memory management
  we will investigate if an automatic "flattening" can occur, #todo[spit ballar ba, men contigous minne är viktigt pga prestanda]
  converting for example a linearly recursive type such as a linked list into a contiguously 
  allocated list. #todo[kanske är out of scope? kanske är crazy? cooky]

  === Laziness
  #red_text[lite osäker på hur vi ska justifya de]
]


#block(stroke: red, inset: 10pt)[#figure(caption: [An outline of our planned work schedule])[
  #timeliney.timeline(
    show-grid: true,
    {
      import timeliney: *

      headerline(
        group(..range(20).map(n => text(size: 10pt, strong(str(n + 3))))),
      )

      taskgroup(title: [*Practical Work*], {
        task("Extending SLFL", (2, 9), style: (stroke: 2pt + gray))
        task("Compiler", (2, 13), style: (stroke: 2pt + gray))
      })

      taskgroup(title: [*Writing*], {
        task("Planning report", (0, 3), style: (stroke: 2pt + gray))
        task("Halftime report", (6, 9), style: (stroke: 2pt + gray))
        task("Final report", (10, 20), style: (stroke: 2pt + gray))
      })

      taskgroup(title: [*Extra*], {
        task("Opposition", (17, 18), style: (stroke: 2pt + gray))
        task("Presentation", (16, 18), style: (stroke: 2pt + gray))
      })
    }
  )
]]

#block(width: 100%, stroke: red, inset: 10pt)[
-   how it differs from previous work (Nordmark)
  -   Nordmark has a special purpose VM.
  -   using Nordmark\'s VM as an intermediate language goes against
      Principle 1.
-   what to do?
  -   Translate each construction/typing rule into code
  -   if a construction cannot be translated this way: refine it
      (design a more low-level rule which serves in an intermediate
      compilation step.)
]