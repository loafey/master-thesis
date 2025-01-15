== Linear Types

Every variable must be used *exactly once*

- Linear arrow: #text(size: 15pt, $multimap$)
- Normal arrow: #text(size: 15pt, $->$)

```hs
const :: a -o b -o c
const a b = a -- error

append :: [a] -o [a] -o [a]
append [] ys = ys
append (x:xs) ys = x : append xs ys -- good
```

- Some programs no longer compile
- No need to copy the data structure, instead mutate!

#pagebreak()

== Linear Types

What is *using exactly once*?
For a function `f` with arguments `x`:

#pagebreak()

== Linear Types

What is *using exactly once*?
For a function `f` with arguments `x`:

- Returning x unmodified.
    - ```hs f x = x```

#pagebreak()
== Linear Types

What is *using exactly once*?
For a function `f` with arguments `x`:

- Returning x unmodified.
    - ```hs f x = x```

- Passing x to a linear function `g` and using the result exactly once in the same fashion.
    - ```hs f x = g x```

#pagebreak()
== Linear Types

What is *using exactly once*?
For a function `f` with arguments `x`:

- Returning x unmodified.
    - ```hs f x = x```

- Passing x to a linear function `g` and using the result exactly once in the same fashion.
    - ```hs f x = g x```

- Pattern-matching on x and using each argument exactly once in the same fashion.
    - ```hs 
        f x = case x of
            Pair a b -> a + b
        ```

#pagebreak()
== Linear Types

What is *using exactly once*?
For a function `f` with arguments `x`:

- Returning x unmodified.
    - ```hs f x = x```

- Passing x to a linear function `g` and using the result exactly once in the same fashion.
    - ```hs f x = g x```

- Pattern-matching on x and using each argument exactly once in the same fashion.
    - ```hs 
    f x = case x of
        Pair a b -> a + b
      ```

- Calling it as a function and using the result exactly once in the same fashion.
    - ```hs
        f x = x + 1
        g = let k = f 0 in f k 
      ```
