#import "Prelude.typ": *

#set heading(numbering: "1.1.")
#set heading(numbering: (first, ..other) => {
  let res = str(first);
  for o in other.pos() {
    res += "." + str(o);
  }
  if other.pos().len() < 3 { return res + "." }
})

#set text(font: "New Computer Modern")

#align(center,text(size: 4em,font: "DejaVu Sans Mono", [SLFL ABI Specification]))
This is a rough specification, nothing is set in stone, and changes are to be expected.

#outline(indent: true, depth: 2)

#pagebreak()

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
As stated before the language does not have a stable ABI, nor does it promise that
it will have one in the future. This is to allow innovation and redesign if need be. 
A small shim is added when calling functions using the C ABI @wiki:X86_calling_conventions_cdecl, 
as to allow for FFI. See @cCalls for more details about this.


#align(center)[== About registers]
The X86-64 registers are only to be used as temporary storage for variables.
Outside of using C ABI functions, variables should always be stored on the stack,
and variables passed to other functions are done by copying them to the suitable stack.
If registers need to be kept inbetween function calls, temporarily push and pop them  
from the stack! The ABI make no promises about which registers functions may or may not
interact with. 

#pagebreak()
#align(center)[== Abbreviations]
The following document will use these abbreviations for readability.
#let abbrName(nm) = [#h(10pt) #sym.bullet #h(4pt) #nm:];
#grid(
  columns: (5.6em, 1fr),
  gutter: 1em,
  abbrName[`RP`], [return pointer; the pointer which points back to the location that called us.],
  abbrName(`RSP`), [
    return stack pointer; where the stack pointer should be placed when returning.
    See @future for more details.
  ],
  abbrName(`RVP`), [
    return value pointer; the pointer where the return value will be stored.
    This value is always allocated, even if the function called does not return a value.
  ],
  abbrName(`BP`), [
    stack base pointer; should always point to the bottom of the current
    stack frame. This plus an offset is used when getting variables stored on the stack.
  ],
  abbrName(`SP`), [
    stack pointer; moves up and down when pushing and popping on stacks.
    Not to be used when getting variables, as offsets will be relative instead
    of "static" like when BP is used.
  ],
  abbrName(`RV(x)`), [
    return value called `x`; this is where the result of a function call will be stored.
  ],
  abbrName[`SEP(x)`], [
    stack execution pointer; where the stack pointer should be moved when executing a closure.
  ],
  abbrName[`SSP`], [
    stack start pointer; this is a pointer that points to the start of this stacks allocation.
    As a stack and the heap grows in different interactions, newly created stacks 
    have their pointers offset by their size. See @future for more details.
  ],
  abbrName[`FX`], [
    stack frame `X`; indicates the base pointer of some arbitrary stack frame.
    `FX + N` is used to indicate that we are adding stack frames above `FX`. 
    If multiple stacks are used in an example they will be enumarated as `FY`, `FZ`...
  ],
  abbrName[`FXM`], [
    stack frame `X` metadata; the region of memory before a stackframe containing necessary
    runtime information. Follows the same enumeration rules as `FX`. Also contains any potential 
    arguments passed to functions.
  ]
)


#let call = [
  #align(center)[== Calling functions using: `call`]
  This is a standard function call, which is somewhat similar to the C ABI.
  The biggest difference here is that return values are always passed using pointers.
  This is to avoid discrepancies between normal and closure based function calls.
  Arguments are also never passed using registers for simplicities sake.

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
    gutter: -40pt,
    [
      #align(center)[==== Stack before `call b`:]
      #stack(
        [`FXM` $->$      ], [`RVP`       ], [$+$18],
        [                ], [`RSP`       ], [$+$10],
        [                ], [`SSP`       ], [$+$08],
        [`FX` $->$       ], [`RP`        ], [$+$00],
        [                ], [`a`         ], [$-$08],
        [                ], [`b`         ], [$-$10],
        [                ], [`RV(result)`], [$-$18],
        [`SP` is here$->$], [], []
      )
    ],
    [
      #align(center)[==== Stack during `call b` start:]
      #stack(
        [`FXM` $->$      ], [`RVP`       ], [$+$ 60],
        [                ], [`RSP`       ], [$+$ 58],
        [                ], [`SSP`       ], [$+$ 50],
        [`FX` $->$       ], [`RP`        ], [$+$ 48],
        [                ], [`a`         ], [$+$ 40],
        [                ], [`b`         ], [$+$ 38],
        [                ], [`RV(result)`], [$+$ 30],
        [`FXM + 1` $->$  ], [`b`         ], [$+$ 28],
        [                ], [`a`         ], [$+$ 20],
        [                ], [`RVP`       ], [$+$ 18, $*$result],
        [                ], [`RSP`       ], [$+$ 10],
        [                ], [`SSP`       ], [$+$ 08],
        [`FX + 1`    $->$], [`RP`        ], [$+$ 00],
        [`SP` is here$->$],[], []
      )
    ],
    [
      #align(center)[==== Stack after `call b`:]
      #stack(
        [`FXM` $->$      ], [`RVP`       ], [$+$ 18],
        [                ], [`RSP`       ], [$+$ 10],
        [                ], [`SSP`       ], [$+$ 08],
        [`FX`    $->$    ], [`RP`        ], [$+$ 00],
        [                ], [`a`         ], [$-$ 08],
        [                ], [`b`         ], [$-$ 10],
        [                ], [`RV(result)`], [$-$ 18, `b` result is now here],
        [`SP` is here$->$  ],[], []
      )
    ]
  )
]


#let tailCall = [
  #align(center)[== Calling functions using `tailcall`]
  #todo[Add content here]
]

#let future = [
  #align(center)[== Allocating closures using `future` <future>]
  If closures and multiple stacks are to be used, the `future` construct is to be used.
  `future` allocates a new stack on the heap, and prepares it for later execution.

  Take this example written in our Haskell DSL for instance:

  ```haskell
  function "prepFuture" 0 \[] -> do
    a <- push . Int $ 0
    b <- push . Int $ 1
    fp <- future "someFuture" [a, b]
    pure ()
  ```
  This will interact with our stack(s) in the following ways:

  #grid(
    columns: (1fr,1fr),
    [
      #align(center)[==== The stack before preparing `fp`:]
      #stack(
        [`FXM` $->$     ],[`RVP`        ],[$+$18],
        [               ],[`RSP`        ],[$+$10],
        [               ],[`SSP`        ],[$+$08],
        [`FX` $->$      ],[`RP`         ],[$+$00],
        [               ],[`a`          ],[$-$08],
        [               ],[`b`          ],[$-$10],
        [`SP` is here $->$],[], []
      )
    ],
    [
      #align(center)[==== The stack after preparing `fp`:]
      #stack(
        [`FXM` $->$     ],[`RVP`    ],[$+$18],
        [               ],[`RSP`    ],[$+$10],
        [               ],[`SSP`    ],[$+$08],
        [`FX` $->$      ],[`RP`     ],[$+$00],
        [               ],[`a`      ],[$-$08],
        [               ],[`b`      ],[$-$10],
        [               ],[`SEP(fp)`],[$-$18],
        [`SP` is here $->$],[], []
      )
    ],
  )
  #grid(
    columns: (1fr,1fr),
    [
      #align(center)[==== The stack that was created for `fp`:]
      #stack(
        [`FYM` $->$],[`b`  ],[],
        [          ],[`a`  ],[],
        [          ],[`RVP`],[],
        [          ],[`RSP`],[],
        [          ],[`SSP`],[],
        [`FY` $->$ ],[],     [`fp` points here]
      )
    ]
  )
  The stack that was created is now prepared to be exucted whenever. Notice 
  the registers values `RSP` and `SSP` here. When a future is called 
  (using `await` or `flush`), `RSP` is set to an appropiate location
  so when a function returns, the stack pointer can be set to that location.
  `SSP` points to the start of this stack *in memory*. This allows for easy
  garbage collection, if we are for example flushing a closure.
  The reason we need `SSP` is because the stack on X86-64 grows backwards, 
  while the heap grows forward. This also means `SEP(fp)` points to somewhere
  along the end of the new stack allocation, and not the start, meaning that
  we effectively lose the pointer to the start if we are not storing it somewhere.
  We could potentially avoid copying `SSP` and `RSP` to every stack frame, and only
  store them at the once at the start of a stack, but this would complicate
  compliation as we would need to keep track of the current stack depth to find them
  when returning/`flush`ing. 
]

#let await = [
  #align(center)[== Executing closures using `await`]
  #todo[Add content here]
]

#let flush = [
  #align(center)[== Executing closures using `flush`]
  #todo[Add content here]
]

#let cCalls = [
  #align(center)[== Executing C functions<cCalls>]
  #todo[Add content here]
]

#pagebreak()
#call
#pagebreak()
#tailCall
#pagebreak()
#future
#pagebreak()
#await 
#pagebreak()
#flush 
#pagebreak()
#cCalls


#pagebreak()
#bibliography("Refs.bib")
