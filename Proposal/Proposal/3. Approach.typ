#import "Prelude.typ": *
= Approach

#red_text[How do we attack the project?]
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
