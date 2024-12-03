== System level programming today
In todays world we are blessed with a lot of choices for system level programming:
- C

- C++

- Rust

- And more . . .

#pagebreak()
== System level programming today
Although these languages are great, they are missing some things
that some developers enjoy:

- Referential transparency

- Purity

- Strongly typed

#pagebreak()
== Functional programming to the rescue!

What does FP not lack in?

- Referential transparency

- Purity

- Strongly typed

_You could of course create a FP language without these_

== Functional programming to the rescue!
Is system-level programming we often have to care about memory,
but most functional languages use garbage collectors!

Due to how most languages are made a lot of copying is done when updating
values, and the old value has to be garbage collected

A garbage collector is not preferred for system-level programming\
as we want control over memory!

We want to know when memory is collected, and what gets collected

#pagebreak()
== Functional programming to the rescue!
So are we stuck with a garbage collector?

#pagebreak()
== Functional programming to the rescue!
So are we stuck with a garbage collector?

#align(center + horizon, text(size: 20pt, [
  #strong[No!] We can use linear types!
]))