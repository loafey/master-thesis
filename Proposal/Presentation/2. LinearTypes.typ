== Linear types

Every variable must be used *exactly once*

- Linear arrow: `-o`
- Normal arrow: `->`

```hs
id :: a -o a
id a = a -- good

append :: [a] -o [a] -o [a]
append [] ys = ys
append (x:xs) ys = x : append xs ys -- good

const :: a -o b -o c
const a b = a -- error
```

- Now `append` can mutate `ys` safely!
