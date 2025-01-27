#import "Prelude.typ": *
#pagebreak()

= Limitations
Creating a programming language and a compiler are two a large tasks. As our
time is limited, we will not be able to tackle everything.
The following are some topics that we will not focus on:

- *Optimizations* \

  Although SLFL is a systems programming language, where performance is
  critical, we will not spend any time on optimizations. Perhaps optimizations
  can be a topic for a future thesis.

- *Laziness*\

  Laziness, or commonly referred to as call-by-name, means that values and
  expressions are evaluated only when they are used. Lazy evaluation is an
  effective tool for achieving modularisation @hughes1989.

  Although laziness does provide several benefits @hughes1989, the work to
  implement it is not trivial. Perhaps this could be a topic for the future as well.

- *Ergonomics*\
  For a language and a compiler to gain traction among the masses it has to be
  _ergonomic_. That is, it has to provide good error messages when the
  programmer writes incorrect code, the tooling has to be user friendly,
  and the language and its tools have to be well documented. Unfortunately,
  this requires a lot of work, most of which would be reimplementations of
  tools from other programming languages.
