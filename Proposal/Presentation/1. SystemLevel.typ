== System level programming today
In todays world we are blessed with a lot of choices for system level programming:
- C

- C++

- Rust

- Probably a lot more . . .

#pagebreak()
What are these languages lacking?

- Referential transparency

- Purity (potentially)

- Strongly typed

- Automatic memory management TODO (not Rust or C++, but you can)

#pagebreak()
== Functional programming to the rescue!

What does FP not lack in?

- Referential transparency

- Purity

- Strongly typed

- Automatic memory management

_You could of course create a FP language without these_

#pagebreak()
== Functional programming to the rescue!
But wouldn't automatic memory management require some sort of garbage collector?

No! We could use linear types!