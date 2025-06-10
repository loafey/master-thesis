#import "../Prelude.typ": *

= Background
// Lite för lågnivå och
// #include "Comp.typ"

#let linear_types = (
  b => {
    if b {
      indent[
        - Normal: variables can be used however many times #text(fill: red, $square.filled$) #text(fill: green, $square.filled$) #text(fill: blue, $square.filled$)

        - Affine: variables must be used at most once #text(fill: red, $square.filled$) #text(fill: green, $square.filled$)

        - Linear: variables must be used exactly once #text(fill: red, $square.filled$)
      ]
    } else {
      indent[
        - Normal: variables can be used however many times

        - Affine: variables must be used at most once

        - Linear: variables must be used exactly once
      ]
    }
  },
  {
    align(center, grid(
      columns: (1fr, 1fr, 1fr),
      text(fill: red, prooftree(rule(
        $Gamma,x,y tack e$,
        $Gamma, y, x tack e$,
        name: [_Exchange_],
      ))),
      text(fill: green, prooftree(rule(
        $Gamma,x tack e$,
        $Gamma tack e$,
        name: [_Weakening_],
      ))),
      text(fill: blue, prooftree(rule(
        $Gamma,x tack e$,
        $Gamma, x, x tack e$,
        name: [_Contraction_],
      ))),
    ))
  },
  {
    indent[
      - Normal: Haskell, C, Java

      - Affine: Clean, Rust

      - Linear: Linear Haskell, #ln
    ]
  },
)
== Linear Types

#linear_types.at(0)(false)

== Linear Types
#linear_types.at(0)(true)
#linear_types.at(1)

== Linear Types

#linear_types.at(0)(true)
#linear_types.at(1)
#linear_types.at(2)

== Continuation-Passing Style (CPS)

#indent[
  - Normal style: return values
    - $
        & id : forall a. space a -> a \
        & id = lambda x. space x
      $

  - Continuation-Passing Style: pass a \"continuation\" as argument
    - $& id : forall a. space a -> (a -> bot) -> bot \
      & id = lambda x. lambda k. space k space x$

    - $a -> bot$ = \"function that terminates with no value\"
]

- A single function call per closure


== Continuation-Passing Style (CPS)

=== Benefits

1. #underline[Always tail call]

#align(left, grid(
  columns: (1fr, 1fr),
  inset: 1em,
  [Normal:],

  [CPS],

  ```hs
  product [] = 1
  product (x:xs) = x * product xs
  ```,

  ```hs
  product [] k = k 1
  product (x:xs) k =
    product xs (\r -> k(x * r))
  ```,
))





== Continuation-Passing Style (CPS)

=== Benefits

  2. #underline[Evaluation order determined syntactically]

  Normal:

#box(inset: 5pt, stroke: 1pt,
  ```hs
  foo x = let y = bar x
          let z = baz x
           in x + y

  ```
)

  CPS:

#box(inset: 5pt, stroke: 1pt, 
  ```hs
  foo x k = bar x (\y -> 
            baz x (\z -> 
            k (y + z)))
  ```
)

#box(inset: 5pt, stroke: 1pt, 
  ```hs
  foo x k = baz x (\z -> 
            bar x (\y -> 
            k (y + z)))
  ```
)
