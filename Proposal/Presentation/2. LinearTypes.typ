== Linear types

Every variable must be used *exactly once*

- Linear arrow: #text(size: 15pt, $multimap$)
- Normal arrow: #text(size: 15pt, $->$)

```hs
id :: a -o a
id a = a -- good

append :: [a] -o [a] -o [a]
append [] ys = ys
append (x:xs) ys = x : append xs ys -- good

const :: a -o b -o c
const a b = a -- error
```

- Now `append` can mutate `ys` in a safe manner

#pagebreak()

== Linear types

For a function `f` with arguments `x` using *exactly once* means:
- Returning x unmodified.

- Passing x to a linear function and using the result exactly once in the same fashion.

- Pattern-matching on x and using each argument exactly once in the same fashion.

- Calling it as a function and using the result exactly once in the same fashion.

