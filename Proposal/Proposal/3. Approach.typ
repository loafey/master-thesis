#import "Prelude.typ": *
= Approach
The work can be divided into two parts: 
1. Creating a compiler for SLFL as it exists currently.
2. Extending SLFL and the compiler with the new features.

We plan on first focusing on the actual creation of the compiler. 
Once this "base compiler" has been made, we will focus on adding the 
new features to the language.

We have made a preliminary plan of how we will schedule our time:
#timeliney.timeline(
show-grid: true,
{
  import timeliney: *

  headerline(
    group(..range(20).map(n => text(size: 10pt, strong(str(n + 3))))),
  )

  taskgroup(title: [*Practical Work*], {
    task("Extending SLFL", (5, 13), style: (stroke: 2pt + gray))
    task("Compiler", (2, 9), style: (stroke: 2pt + gray))
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

== Evaluation


Although this is a system-level language, and performance and resource usage is
key, the language will still be in the infant stage of development after the
thesis. Rather than compare the language to mature pre-existing system-level languages, we will focus on two key aspects:

- Self-evident: Every intermediate compilation step should be typed

- Correctness: Every intermediate compilation step should be type checked. 

As SLFL is a system-level language, it is very important that no memory is leaked during the running time of the program.
We will measure this using Valgrind @valgrind.
If time allows we will also measure the memory usage of the language most likely using the `glibc` tool `memusage` @gnuGlibc.

// As this is a system-level language, performance and resource usage is key.
// To evalute how performant the language is, simple programs will be written
// in SLFL and other system-level languages such as C to compare how well they 
// perform against each other. Primarily execution time and memory usage will be
// measured, most likely using the GNU tool `time` @gnuTimeProject and the `glibc` tool `memusage` @gnuGlibc
// to do so. The SLFL programs will also be evaluated using Valgrind @valgrind to make sure that 
// memory leaks do not occur. #green_text[Important to note here is that we are not planning to focus
// too heavily on the execution time of the program. It is an interesting metric, but one
// we feel would take too much time to focus on as we prioritize memory safety and efficiency.]
