#import "Prelude.typ": *
#pagebreak()
= Limitations
These are different topics and areas this project will more than likely avoid,
for time's sake.

== Optimizations
Although SLFL is a systems programming language, where performance is critical,
we will not spend any time implementing optimizations. 

== Laziness
Laziness, or commonly referred to as call-by-name, means that values and
expressions are evaluated only when they are used. 
Lazy evaluation is an effective tool for achieving modularisation @hughes1989. 

While laziness is a common want#todo[source] for a functional programming language,
it might too much of a burden for this project. As we will be devloping on 
a lower level, having to consider laziness as well might prove too much.
