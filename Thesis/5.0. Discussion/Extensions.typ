
== Compiler primitives
As can be seen in the earlier chapters, the language provides some of the necessities
needed to construct programs, but not all.
To alleviate with the construction of software the standard library introduces two functions
which are needed when writing more advanced programs.

// #figure(
// ```hs
// inc : *((int ⊕ int) ⊗ ~int)
// = \(n,k) -> case n of {
// inl x -> k(x+1);
// inr x -> k(x+2);
// };
//
// main : *~int
//  = \e -> inc((inl 2, e));
// ```,
// caption: [
// Simple arithmetic and pattern matching on a sum type\ (`int ⊕ int`)
// ],
// )
//
First we have the equality function, which takes in two integers and returns a value of
type `() ⊕ ()` (acts as a boolean) which can be pattern matched on.
```hs
main : *~int
    = \e -> __eq__((3,4), \res -> case res of {
      inl () -> e(0); -- true
      inr () -> e(1); -- false
    });
```
And then we have the duplication function:
```hs
main : *~int
    = \e -> __dup__((4, \(n,m) -> e(n+m)));
```
This lets you duplicate integers, which is a necessity in more advanced programs.
Using these two extensions we can write some more interesting programs: see @Fibbo.
