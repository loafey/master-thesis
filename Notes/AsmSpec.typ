#import "Prelude.typ": *

#set heading(numbering: "1.1.")
#set heading(numbering: (first, ..other) => {
  let res = str(first);
  for o in other.pos() {
    res += "." + str(o);
  }
  if other.pos().len() < 2 { return res + "." }
})
#set par(justify: true)
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

#align(center)[== Efficiency]
As will be made clear by this spec, the focus of this specification is not necessarily
efficiency memory wise. Each stack frame needs to use at least 4 bytes, which
is double than what C uses by default, but compared to other system level languages
this is not too bad. Worth to not that the minimum stack frame size is very 
platform and compiler dependant, so these are a rough estimate for X86-64 Linux.
#table(
  columns: (1fr,1fr,1fr),
  [Language], [Minimum stack frame size in bytes], [Considered system-level],
  [SLFL],     [4],                                 [#sym.checkmark],
  [C],        [2],                                 [#sym.checkmark],
  [C++],      [??],                                [#sym.checkmark],
  [Rust],     [??],                                [#sym.checkmark],
)
(extremely hard to find resources for this :( )


#pagebreak()
#align(center)[== Abbreviations]
The following document will use these abbreviations for readability.
#let abbrName(nm) = [#h(10pt) #sym.bullet #h(4pt) #nm:];
#grid(
  columns: (8em, 1fr),
  row-gutter: 1em,
  column-gutter: -0.1em,
  abbrName[`RP`], [return pointer; the pointer which points back to the caller.],
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
    stack execution pointer; where the stack pointer should be moved when executing a future.
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
  ],
  abbrName[`UNINIT(r)`], [
    uninitialized stack value; this stack value will be used in the future to insert
    a value of type `r`. For instance, a stack value with `UNINIT(RP)` designates a value
    where a return pointer will be written in the future.
  ],
  abbrName(`VAR(x)`), [
    variable stored on the stack; the relative location of the variable from the current `BP`
    is the index on the right.
  ],
  abbrName(`CP`), [
    code pointer; used to store whichever function will be executed when executing a 
    `future`.
  ]
)


#let call = [
  #align(center)[== Calling functions using: `call`]
  This is a standard function call, which is somewhat similar to the C ABI.
  The biggest difference here is that return values are always passed using pointers.
  This is to avoid discrepancies between normal and future based function calls.
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
        [                ], [`RES(a)`    ], [$-$08],
        [                ], [`RES(b)`    ], [$-$10],
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
        [                ], [`res(a)`    ], [$+$ 40],
        [                ], [`res(b)`    ], [$+$ 38],
        [                ], [`RV(result)`], [$+$ 30],
        [`FXM + 1` $->$  ], [`res(b)`    ], [$+$ 28],
        [                ], [`res(a)`    ], [$+$ 20],
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
        [                ], [`var(a)`    ], [$-$ 08],
        [                ], [`var(b)`    ], [$-$ 10],
        [                ], [`RV(result)`], [$-$ 18, `b` result is now here],
        [`SP` is here$->$  ],[], []
      )
    ]
  )
]


#let tailCall = [
  #align(center)[== Calling functions using `tailcall`]
  This is used to implement tail call elimination. Compared to the normal `call`
  construct, this replace the current stack frame. #text(fill: red)[Keep in mind that], 
  when you use this, the function calling `tailcall` will never be returned to!
  `tailcalls` can also be done optionally, as branching, normal function `call`s, 
  etc are allowed when `tailcall`ing.

  === Example
  Consider this simple example program created using our Haskell DSL:
  ```haskell
  function "tailrec" 1 \[val] -> do
    res <- add (Int 1) (StackVar B64 val)
    tailcall "tailrec" [val]
  ```
  
  #grid(
    columns: (1fr, 1fr),
    [
      #align(center)[==== Stack before `tailcall`:]
      #stack(
        [`FXM` $->$], [`val`     ], [$+$ 20],
        [          ], [`RVP`     ], [$+$ 18],
        [          ], [`RSP`     ], [$+$ 10],
        [          ], [`SSP`     ], [$+$ 08],
        [`FX`  $->$], [`RP`      ], [$+$ 00],
        [          ], [`VAR(res)`], [$-$ 08],
        [`SP`  $->$], [``        ], [$-$ 10],
      )
    ],
    [
      #align(center)[==== Stack before second `tailcall`:]
      #stack(
        [`FXM` $->$], [`val + 1` ], [$+$ 20],
        [          ], [`RVP`     ], [$+$ 18],
        [          ], [`RSP`     ], [$+$ 10],
        [          ], [`SSP`     ], [$+$ 08],
        [`FX`  $->$], [`RP`      ], [$+$ 00],
        [          ], [`VAR(res)`], [$-$ 08],
        [`SP`  $->$], [``        ], [$-$ 10],
      )
    ]
  )
  As can be seen here, the stack is the exact same as it was before. 
  The only difference here is the argument, which for this example has
  been incremented by one.

  When tailcalling `RVP`, `RSP`, `SSP` and `RP` are copied to the new frame, as
  `tailcall`s should always return to the original caller, no matter the amount of tail calls that has been done.
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
        [`FXM` $->$     ],[`RVP`   ],[$+$18],
        [               ],[`RSP`   ],[$+$10],
        [               ],[`SSP`   ],[$+$08],
        [`FX` $->$      ],[`RP`    ],[$+$00],
        [               ],[`VAR(a)`],[$-$08],
        [               ],[`VAR(b)`],[$-$10],
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
        [               ],[`VAR(a)` ],[$-$08],
        [               ],[`VAR(b)` ],[$-$10],
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
        [`FYM` $->$],[`VAR(b)`     ],[],
        [          ],[`VAR(a)`     ],[],
        [          ],[`UNINIT(RVP)`],[],
        [          ],[`UNINIT(RSP)`],[],
        [          ],[`SSP`        ],[],
        [`FY` $->$ ],[`CP`         ],[$<-$ `fp`]
      )
    ]
  )
  The stack that was created is now prepared to be exucted whenever. Notice 
  the values `RSP` and `SSP` here. When a `future` is executed, 
  `RSP` is set to an appropiate location
  so that when a function returns, the stack pointer can be set to that location.
  `SSP` points to the start of this stack in memory. This allows for easy
  deallocation.
  The reason we need `SSP` is because the stack on X86-64 grows backwards, 
  while the heap grows forward. This also means `SEP(fp)` points to somewhere
  along the end of the new stack allocation, and not the start, meaning that
  we effectively lose the pointer to the start if we are not storing it somewhere.
  We could potentially avoid copying `SSP` and `RSP` to every stack frame, and only
  store them at the once at the start of a stack, but this would complicate
  compliation as we would need to keep track of the current stack depth to find them
  when returning/`flush`ing. Also notice `CP` here, this is the function that will be 
  executed when running a future and will be replaced by a `RP` when that is done.
]

#let await = [
  #align(center)[== Executing futures using `await`]
  If a future has been created using the `future` construct, there are two ways to execute it,
  and this chapter covers `await`. 

  ==== Example
  Let us take a look at this simple example written in our Haskell DSL:
  ```haskell
  function "execfuture" 0 \[] -> do
    a <- push . Int $ 0
    b <- push . Int $ 1
    fp <- future "someFuture" [a, b]
    res <- await fp
    pure ()
  ```
  This is what our two stacks will look like before the actual `await` is called:
  #grid(
    columns: (1fr,1fr),
    [
      #align(center)[==== The stack containing `fp`:]
      #stack(
        [`FXM` $->$       ],[`RVP`    ],[$+$18],
        [                 ],[`RSP`    ],[$+$10],
        [                 ],[`SSP`    ],[$+$08],
        [`FX` $->$        ],[`RP`     ],[$+$00],
        [                 ],[`VAR(a)` ],[$-$08],
        [                 ],[`VAR(b)` ],[$-$10],
        [                 ],[`SEP(fp)`],[$-$18],
        [                 ],[`RV(res)`    ],[$-$20],
        [`SP` is here $->$],[         ],[$-$28]
      )
    ],
    [
      #align(center)[==== The new stack pointed to by `fp`:]
      #stack(
        [`FYM` $->$],[`VAR(b)`     ],[],
        [          ],[`VAR(a)`     ],[],
        [          ],[`UNINIT(RVP)`],[],
        [          ],[`UNINIT(RSP)`],[],
        [          ],[`SSP`        ],[],
        [`FY` $->$ ],[`CP`         ],[$<-$ `fp`]
      )
    ]
  ) 
  #grid(columns: (1fr,1fr), [
    After the `await` construct is called the newly modified stack will be modified 
    to look like the one on the right here.
    Observe that `RVP`, `RSP`, and `RP` have all been set. 
    `RVP` is set to to the address of `res` in the original stack, 
    `RSP` is set to where the stack pointer was before the `await`
    (-28 in the original stack), and finally 
    `CP` is moved to another location and `RP`
    is written there so we have a pointer back to the caller.

    When this stack is done executing, the return value will be written to RVP, and 
    the stack will be deallocated using `SSP`.
  ],[
    #align(center)[==== The new stack during await]
    #stack(
      [`FYM` $->$       ],[`VAR(b)`],[$+$ 30],
      [                 ],[`VAR(a)`],[$+$ 28],
      [                 ],[`RVP`   ],[$+$ 20, \*`res`],
      [                 ],[`RSP`   ],[$+$ 18],
      [                 ],[`SSP`   ],[$+$ 10],
      [`FY` $->$        ],[`RP`    ],[$+$ 08 $<-$ `fp`],
      [`SP` is here $->$],[        ],[$+$ 00]
      )
  ]);
]

#let flush = [
  #align(center)[== Executing futures using `flush`]
  This is the second option when executing `future`s.
  Conceptually speaking, if `await` is like the normal `call`, `flush` is like `tailcall`.

  Unlike `await`, when `flush` executes a `future`, it effectively "replaces" the current
  stack.
  This is done by replacing copying any relevant pointers (like `RVP` etc) in the current
  stack frame, to this `future`, moving `SP` to a fitting solution, writing
  a suitable return pointer, and jumping to the correct code location. 

  ==== Example
  Let us take a look at this simple example written in our Haskell DSL:
  ```haskell
  function "flushFuture" 0 \[] -> do
    a <- push . Int $ 0
    b <- push . Int $ 1
    fp <- future "someFuture" [a, b]
    flush fp
  ```
  This is what our two stacks will look like before the `flush`:
  #grid(
    columns: (1fr,1fr),
    [
      #align(center)[==== The stack containing `fp`:]
      #stack(
        [`FXM` $->$       ],[`RVP`    ],[$+$18],
        [                 ],[`RSP`    ],[$+$10],
        [                 ],[`SSP`    ],[$+$08],
        [`FX` $->$        ],[`RP`     ],[$+$00],
        [                 ],[`VAR(a)` ],[$-$08],
        [                 ],[`VAR(b)` ],[$-$10],
        [                 ],[`SEP(fp)`],[$-$18],
        [                 ],[`RV(res)`    ],[$-$20],
        [`SP` is here $->$],[         ],[$-$28]
      )
    ],
    [
      #align(center)[==== The new stack pointed to by `fp`:]
      #stack(
        [`FYM` $->$],[`VAR(b)`     ],[],
        [          ],[`VAR(a)`     ],[],
        [          ],[`UNINIT(RVP)`],[],
        [          ],[`UNINIT(RSP)`],[],
        [          ],[`SSP`        ],[],
        [`FY` $->$ ],[`CP`         ],[$<-$ `fp`]
      )
    ]
  ) 
  #grid(
    columns: (1fr,1fr),
    [
      When `flush` is called multiple things will happen.
      `RP`, `RSP` and `RVP` will all be copied over from stack `X`
      to stack `Y`. When `RP` is copied over, the preexisting CP is
      safely stored before.       
      Unlike `tailcall`, `SSP` should _not_ be copied over,
      as that will destroy any chance of deallocation of frame `Y`.
      This means that the normal `call` instruction in Assembly 
      can not be used to set the code pointer, as that will write
      an innacurate `RP` to stack `Y`, and instead a long jump
      needs to be used (`jmp *FP` in GNU AT&AT). After that
      `SSP` in stack `X` will need to be used to deallocate 
      stack `X`. 
    ],
    stack(
      [`FYM` $->$],[`VAR(b)`],[],
      [          ],[`VAR(a)`],[],
      [          ],[`RVP`   ],[],
      [          ],[`RSP`   ],[],
      [          ],[`SSP`   ],[],
      [`FY` $->$ ],[`RP`    ],[$<-$ `fp`],
      [`SP` $->$ ], [] ,[]
    )
  )
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
#align(center)[== Allocating values on the stack]
Writing values of different sizes to the stack can be quite the chore, and this chapter will 
cover how this should be handled by an implementor for a 64bit Linux system:
#let alignBase = 16
#let align4 = alignBase - 4;
#let align2 = alignBase - 2;
#let align1 = alignBase - 1;
#box(
  stroke: black,
  table(
    // fill: (x, y) => if x == 0 or y == 0 { rgb("#ffdfdf") },
    inset: (right: 1.5em),
    align: center,
    stroke: (x, y) => if y == 0 and x != 0 { 
      (bottom: black)
    } else if x == 0 and y != 0 {
      (right: black)
    } else {
      none
    },
    columns: (6em,1fr, 1fr),
    [Byte size], [Stack pointer `diff`], [Writing instruction:],
    [$8$],[$-0$],[Push using `pushq`],
    [$4$],[$-#align4$],[Push using `pushl`, then $#[`SP`] - #align4$],
    [$2$],[$-#align2$],[Push using `pushl`, then $#[`SP`] - #align2$],
    [$1$],[$-#align1$],[Push using `pushl`, then $#[`SP`] - #align1$],
    [$0$],[N/A ],[Pushing a value of size 0 is a `NO-OP`],
    [`x`],[$-((floor((#alignBase + x) / #alignBase) dot #alignBase) - x)$], [$#[`SP`] - #[`diff`]$, then manually write the data to the memory],
  )
)

As can be seen here, any and all modifications to the stack must result in stack pointer being aligned by a 
factor of #alignBase. This is done to keep the language compatible with the C ABI, as that requires that the stack pointer
is aligned by a factor of #alignBase on Linux systems @gcc:stackAlignment. 
If our language were to forbid any and all interactions using the C ABI this could
be avoided, but that would in term, require reinventing the wheel for any and all interactions
with an operating system.


#let alignment(x) = calc.floor((alignBase + x) / alignBase) * alignBase
#let diff(x) = alignment(x) - x
#figure(
  numbering: none,
  caption: [
    Graph 1. represents the memory needed to be allocated for 
    data of size $x$,
    while graph 2. represents how much the stack pointer should be subtracted to keep it aligned.
  ],
  cetz.canvas({
    import cetz.draw: *

    // Set-up a thin axis style
    set-style(axes: (stroke: .5pt, tick: (stroke: .5pt)),
              legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 80%))

    plot.plot(size: (14, 8),
      x-tick-step: alignBase / 2,
      y-tick-step: alignBase, 
      y-min: 0, y-max: alignBase * 8,
      legend: "inner-north",
      {
        let domain = (0,alignBase * 8)
        plot.add(alignment, domain: domain, label: [1. Allocation size: $floor((#alignBase + x) / #alignBase) dot #alignBase$],
          samples: 200,
          style: (stroke: black)
        )

        plot.add(diff, domain: domain, label: [2. Diff: $((floor((#alignBase + x) / #alignBase) dot #alignBase) - x$],
          samples: 200,
          style: (stroke: red)
        )
      })
  }
))

#pagebreak()
#align(center)[== Executing C functions<cCalls>]
#todo[Add content here]

#pagebreak()
#align(center)[== Returning from a `call`]
#todo[Add content here]


#pagebreak()
#bibliography("Refs.bib")
