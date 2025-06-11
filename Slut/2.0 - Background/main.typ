#import "../Prelude.typ": *

= Background

== Linear Types

#indent[
  - Normal: variables can be used however many times

  - Linear: variables must be used exactly once

  #align(center, grid(
    columns: (1fr, 1fr, 1fr),
    prooftree(rule($Gamma,x tack e$, $Gamma tack e$, name: [_Weakening_])),
    prooftree(
      rule($Gamma,x tack e$, $Gamma, x, x tack e$, name: [_Contraction_]),
    ),
  ))
  - Normal: Haskell, C, Java

  - Linear: Linear Haskell, Austral

]


== Continuation-Passing Style (CPS)

#indent[
  - Normal style: return values
    - $A -> B$

  - Continuation-Passing Style: pass a continuation as argument
    - $A -> (B -> bot) -> bot$

    - $B -> bot$ = function with $B$ as argument, that terminates with no value
]

- Exactly one function call per closure


== Continuation-Passing Style (CPS)

=== Benefits

1. #underline[Always tail call]

#align(left, grid(
  columns: (1fr, 1fr),
  inset: 1em,
  [Normal:],

  [CPS:],

  ```hs
  sum :: [Int] -> Int
  sum [] = 0
  sum (x:xs) = x + sum xs
  ```,

  ```hs
  sum :: [Int] -> (Int -> r) -> r
  sum [] k = k 0
  sum (x:xs) k =
    sum xs (\r -> k (x + r))
  ```,
))

== Continuation-Passing Style (CPS)

=== Benefits

2. #underline[Evaluation order determined syntactically]

Normal:

#box(
  inset: 5pt,
  stroke: 1pt,
  ```hs
  foo x = let y = bar x
          let z = baz x
           in x + y

  ```,
)

CPS:

#grid(
  columns: (1fr, 1fr),
  box(
    inset: 5pt,
    stroke: 1pt,
    ```hs
    foo x k =
      bar x (\y ->
        baz x (\z ->
          k (y + z)))
    ```,
  ),

  box(
    inset: 5pt,
    stroke: 1pt,
    ```hs
    foo x k =
      baz x (\z ->
        bar x (\y ->
          k (y + z)))
    ```,
  ),
)
