#import "Prelude.typ": *


#align(center)[= The Main Function]
When the program starts the first thing it does is call a pre-written
assembly function which acts as the actual main function for the program.
This main function will henceforth be called the "main" function, and 
the main function the user writes in their code will henceforth be called "false main".

This main function will to do three things: 
- parse command line arguments and store them in a globally accessible location
  (#text(fill: red)[not implemented, and will most likely not be for the thesis]).
- allocate a closure on a new stack (called a future), which will simply 
  execute the false main.
- execute said future, switching stack to the newly allocated one.

The reason for this decision is so that the there is no hidden discrepancy between
the users main function and any function the user writes or calls.
If, for example, the compiler needs to deallocate the false main stack, it is free to do so 
without a special case, which would not be possible with a normal stack. 

#align(center)[= Calling Convention]
The language has at this point not stable ABI, nor does it promise that it will have one in
the future. This is to allow innovation and redesign if need be. A small shim is 
added when calling functions using the C ABI @wiki:X86_calling_conventions_cdecl, 
as to allow for FFI.

In the examples given below the following abbreviations will be used:
#let abbrName(nm) = [#h(10pt) #sym.bullet #h(4pt) #nm:];
#grid(
  columns: (4.6em, 1fr),
  gutter: 1em,
  abbrName("RP"), [return pointer; the pointer which points back the function that called us],
  abbrName("RVP"), [
    return value pointer; the pointer where the return value will be stored.
    This value is always allocated, even if the function called does not return a value.
  ],
  abbrName("BP"), [
    stack base pointer; should always point to the bottom of the current
    stack frame. This plus an offset is used when getting variables stored on the stack.
  ],
  abbrName("SP"), [
    stack pointer; moves up and down when pushing and popping on stacks.
    Not to be used when getting variables, as offsets will be relative instead
    of "static" like when BP is used.
  ],
  abbrName[RV($x$)], [
    return value called $x$; this is where the result of a function call will be stored.
  ]
)

#align(center)[== About registers]
The X86-64 registers are only to be used as temporary storage for variables.
Outside of using C ABI functions, variables should always be stored on the stack,
and variables passed to other functions are done by copying them to the suitable stack.
If registers need to be kept inbetween function calls, temporarily push and pop them  
from the stack! The ABI make no promises about which registers functions may or may not
interact with. 

#let call = [
  #align(center)[== Calling functions using: `call`]
  This is a standard function call, which is somewhat similar to the C ABI.
  The difference here is that return values are passed by pointers.
  This is to avoid discrepancies between normal
  and closure based function calls.

  === Example:
  Consider this simple example program created using our Haskell DSL:
  ```haskell
  function "a" 0 \[] -> do
    a <- push . Int $ 0
    b <- push . Int $ 1
    result <- call "b" [intA, intB]
    pure ()
  ```
  
  #grid(
    columns: (1fr,1fr),
    gutter: 10pt,
    [
      === Stack before `call b`:
      #stack(
        [Frame X $->$  ], [RVP       ], [$+$08],
        [              ], [RP        ], [$+$00],
        [              ], [a         ], [$-$08],
        [              ], [b         ], [$-$10],
        [              ], [RV(result)], [$-$18],
        [SP is here$->$]
      )
    ],
    [
      === Stack during `call b` start:
      #stack(
        [Frame X $->$    ], [RVP       ], [$+$ 40],
        [                ], [RP        ], [$+$ 38],
        [                ], [a         ], [$+$ 30],
        [                ], [b         ], [$+$ 28],
        [                ], [RV(result)], [$+$ 20],
        [Frame X + 1 $->$], [b         ], [$+$ 18],
        [                ], [a         ], [$+$ 10],
        [                ], [RVP       ], [$+$ 08, $*$result],
        [                ], [RP        ], [$+$ 00],
        [SP is here$->$  ],
      )
    ],
    [
      === Stack after `call b`:
      #stack(
        [Frame X $->$    ], [RVP       ], [$+$ 40],
        [                ], [RP        ], [$+$ 38],
        [                ], [a         ], [$+$ 30],
        [                ], [b         ], [$+$ 28],
        [                ], [RV(result)], [$+$ 20, `b` result is now here],
        [SP is here$->$  ],
      )
    ]
  )
]


#let future = [
  #align(center)[== Future]
]

#let await = [
  #align(center)[== Await]
]

#let flush = [
  #align(center)[== Flush]
]

#let cCalls = [
  #align(center)[== C Calls]
]

#pagebreak()
#call

#pagebreak()
#grid(
  columns: (1fr, 1fr),
  gutter: 10pt, future, await, flush, cCalls
)

#pagebreak()
#bibliography("Refs.bib")
