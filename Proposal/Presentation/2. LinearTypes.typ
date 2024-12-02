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
