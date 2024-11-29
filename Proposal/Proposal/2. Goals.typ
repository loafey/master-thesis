#import "Prelude.typ": *

= Goals and planning
This chapter will define what the goals are, why they are interesting, and estimate what needs to done.

  == Language extensions
  Currently the language is somewhat simple, and the following sections cover extensions
  to the language we want to add. As SLFL follows a formal specification,
  all of these new rules have to do so as well. For each new feature new typing
  rules and new reduction rules will be introduced for working with them.
  === Exponentials
  Add text here!
  #todo[Explain exponentials and their relevance]
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
  Add text here!
  #todo[Explain laziness and its relevance]

  == Evaluation
  As this is a system-level language, performance and resource usage is key.
  To evalute how performant the language is, simple programs will be written
  in SLFL and other system-level languages such as C to compare how well they 
  perform against each other. Primarily execution time and memory usage will be
  measured, most likely using the GNU tool `time` @gnuTimeProject and the `glibc` tool `memusage` @gnuGlibc
  to do so. The SLFL programs will also be evaluated using Valgrind @valgrind to make sure that 
  memory leaks do not occur.  


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

/*
-   what to do?
  -   Translate each construction/typing rule into code
  -   if a construction cannot be translated this way: refine it
      (design a more low-level rule which serves in an intermediate
      compilation step.)
*/
