#import "Prelude.typ": *

= Goals and planning
#green_text[
  The goal of this thesis is to extend the language of SLFL, as well as
  building a compiler for it. For the compilation part we preliminary want to compile the language to LLVM @lattner2004llvm.
  Time will be spent on investigating if LLVM is a good compilation target, and if not, other
  low level targets such as x86-64 assembly will be considered.

  == Language extensions
  Currently the language is somewhat simple, and the following sections cover extensions
  to the language we want to add if time allows. As SLFL follows a formal specification,
  all of these new rules have to do so as well. For each new feature new typing
  rules and new reduction rules will be introduced for working with them.
  === Exponentials
  #red_text[figure out what this means, closures??]
  === Records
  While simple data types suffice in a lot of places, records provide important 
  context to data types, allowing for labeled fields.
  === Recursive and contiguous data types 
  When representing more complicated data types such as different types of trees or list
  in functional programming, they are almost always implemented using recursive data types.
  In theory this is fine, but in practice it leads to overhead such as pointer 
  indirection, bad cache locality and more. Due to this we will also investigate adding 
  statically or dynamically sized contiguous types, such as arrays or vectors.

  === Laziness
  #red_text[lite osäker på hur vi ska justifya de]

  == Evaluation
  As this is a system-level language, performance and resource usage is key.
  To evalute how performant the language is, simple programs will be written
  in SLFL and other system-level languages such as C to compare how well they 
  perform against each other. Primarily execution time and memory usage will be
  measured, most likely using the GNU tool `time` @gnuTimeProject and the `glibc` tool `memusage` @gnuGlibc
  to do so. The SLFL programs will also be evaluated using Valgrind @valgrind to make sure that 
  memory leaks do not occur.  
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