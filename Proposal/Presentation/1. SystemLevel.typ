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
What does FP lack in?

Most functional languages use garbage collectors!

Depending on the collector we might have performance impacts

A garbage collector is not preferred for system-level programming!

#pagebreak()
== Functional programming to the rescue!
So are we stuck with a garbage collector?

#pagebreak()
== Functional programming to the rescue!
So are we stuck with a garbage collector?

#align(center + horizon, text(size: 20pt, [
  #strong[No!] We can use linear types!
]))