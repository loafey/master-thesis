#import "../Prelude.typ": *

= Usage
As of this report #ln is in it's infancy, but #ln has been used
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
