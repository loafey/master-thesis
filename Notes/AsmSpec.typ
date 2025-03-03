#import "Prelude.typ": *
#set page(numbering: "1")
#set heading(numbering: "1.1.")
#set heading(numbering: (first, ..other) => {
  let res = str(first);
  for o in other.pos() {
    res += "." + str(o);
  }
  if other.pos().len() < 3 { return res + "." }
})
#set par(justify: true)
#set text(font: "New Computer Modern")

#align(center,text(size: 4em,font: "DejaVu Sans Mono", [SLFL ABI\ Specification]))
This is a rough specification, nothing is set in stone, and changes are to be expected.

#outline(indent: true, depth: 3)

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
#pagebreak()

#align(center)[= Calling Convention]
As stated before the language does not have a stable ABI, nor does it promise that
it will have one in the future. This is to allow innovation and redesign if need be. 
A small shim is added when calling functions using the C ABI @wiki:X86_calling_conventions_cdecl, 
as to allow for FFI. See @cCalls for more details about this.

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
#align(center)[== Executing C functions<cCalls>]
#todo[Add content here]

#pagebreak()
#align(center)[== Returning from a `call`]
#todo[Add content here]

#pagebreak()
#align(center)[= Memory Conventions]

#align(center)[== About registers]
The X86-64 registers are only to be used as temporary storage for variables.
Outside of using C ABI functions, variables should always be stored on the stack,
and variables passed to other functions are done by copying them to the suitable stack.
If registers need to be kept inbetween function calls, temporarily push and pop them  
from the stack! The ABI make no promises about which registers functions may or may not
interact with. 

#align(center)[== Minimum stack frame size]
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



#align(center)[== Allocating values]
#let alignBase = 8
// #let align4 = alignBase - 4;
// #let align2 = alignBase - 2;
// #let align1 = alignBase - 1;
// #box(
//   stroke: black,
//   table(
//     // fill: (x, y) => if x == 0 or y == 0 { rgb("#ffdfdf") },
//     inset: (right: 1.5em),
//     align: center,
//     stroke: (x, y) => if y == 0 and x != 0 { 
//       (bottom: black)
//     } else if x == 0 and y != 0 {
//       (right: black)
//     } else {
//       none
//     },
//     columns: (6em,1fr, 1fr),
//     [Byte size], [Stack pointer `diff`], [Writing instruction(s):],
//     [$8$],[$-0$],[Push using `pushq`],
//     [$4$],[$-#align4$],[Push using `pushl`, then $#[`SP`] - #align4$],
//     [$2$],[$-#align2$],[Push using `pushl`, then $#[`SP`] - #align2$],
//     [$1$],[$-#align1$],[Push using `pushl`, then $#[`SP`] - #align1$],
//     [$0$],[N/A ],[Pushing a value of size 0 is a `NO-OP`],
//     [`x`],[$-((floor((#alignBase + x) / #alignBase) dot #alignBase) - x)$], [$#[`SP`] - #[`diff`]$, then manually write the data to the memory.\ See @dataTypes for details.],
//   )
// )

// As can be seen here, any and all modifications to the stack must result 
// in stack pointer being aligned by a factor of #alignBase. 
// This stack alignment is not necessarily needed on x86-64, but it is a good practice as 
// accessing aligned addresses is faster, and is sometimes expected when utilizing FFI.
// While this project won't focus on non x86-64 Linux systems, stack alignment is still 
// a good idea for future proofing as some CPUs forbid non-aligned memory access.

// All of this also comes at the cost of wasting more stack memory, but seeing as any
// realistically written program will most likely not allocate, say, 50000 single byte values on the 
// stack at once (which would need #(50000 * 8) bytes with alignment), this is negligible.
// If, for whatever reason, that is needed, consider bit fields and similar solutions. 

// Calculating the needed stack pointer difference when allocating stack values can be done using the following formula: $diff(x) = (floor((#alignBase + x) / #alignBase) dot #alignBase) - x$.

// #let alignment(x) = calc.floor((alignBase + x) / alignBase) * alignBase
// #let diff(x) = alignment(x) - x
// #figure(
//   numbering: none,
//   caption: [
//     Graph 1. represents the memory needed to be allocated for 
//     data of size $x$,
//     while graph 2. represents how much the stack pointer should be subtracted to keep it aligned.
//   ],
//   cetz.canvas({
//     import cetz.draw: *

//     // Set-up a thin axis style
//     set-style(axes: (stroke: .5pt, tick: (stroke: .5pt)),
//               legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 80%))

//     plot.plot(size: (14, 7),
//       x-tick-step: alignBase / 2,
//       y-tick-step: alignBase, 
//       y-min: 0, y-max: alignBase * 8,
//       legend: "inner-north",
//       {
//         let domain = (0,alignBase * 8)
//         plot.add(alignment, domain: domain, label: [1. Allocation size: $floor((#alignBase + x) / #alignBase) dot #alignBase$],
//           samples: 200,
//           style: (stroke: black)
//         )

//         plot.add(diff, domain: domain, label: [2. $#sym.diff (x) = ((floor((#alignBase + x) / #alignBase) dot #alignBase) - x$],
//           samples: 200,
//           style: (stroke: red)
//         )
//       })
//   }
// ))

// These numbers and this formula is based on a stack alignment of 8 bytes, and if 
// one were to compile this to a 32bit system etc, the stack alignment should 
// be modified to reflect that ($"bit units" / 8$).

=== Allocating data types<dataTypes>
For data types, allocation is done using a strategy that mimics the way C allocates
structs. This means that, the language does not use packed structures nor 
any other more optimized strategy, instead opting 
for an allocation strategy which is C compatible, as to make FFI easier. 
Much of what is written here is based on a blog post by Andreas Heck @c:structures.

The fields of a data type must be stored on an address which is a multiple of
the individual field's byte size. This means that 2 byte field must be stored on
an address divisible by 2 for example. 
To account for this, padding between fields will be added if needed as to keep them aligned.
Padding will also be added to the end of the allocation to keep it aligned with #alignBase bytes.
Along with this, a 1 byte tag will be added to designate which constructor has been used 
to create the value.#pagebreak()

Consider a data type such as this:  `data Cool = Cons I16 I8 I8 I8 I32` (`IX` = integer of X bits),
and a value allocated created with `Cons 1 2 3 4 5`

#let f(type: "normal", size, body) = table.cell(
  fill: if type == "pad" {
    rgb("#edf064")
  } else if type == "tag" {
    lime
  } else {
    none
  },
  colspan: size, 
  body
)

#{
  [When allocating this using a packed strategy (with additional #alignBase byte aligned end padding), it would look like this:]
  table(
    columns: (5em, 1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),
    align: center,
    f(18)[A total size of 16 bytes],
    [Value],  f(type: "tag", 1)[0],   f(2)[1], f(1)[2],    f(1)[3],  f(1)[4],  f(4)[5],   f(type: "pad", 7)[...],
    [Type],   f(type: "tag", 1)[Tag], f(2)[I16], f(1)[I8], f(1)[I8], f(1)[I8], f(4)[I32], f(type: "pad", 7)[End pad],
    [Bytes],  f(type: "tag", 1)[1],   f(2)[2], f(1)[1],    f(1)[1],  f(1)[1],  f(4)[4],   f(type: "pad", 7)[6],
    [Offset], f(type: "tag", 1)[0],   f(2)[1], f(1)[3],    f(1)[4],  f(1)[5],  f(4)[6],   f(type: "pad", 7)[10],
    // [Total],  f(1)[1],   f(1)[2],  f(2)[4],   f(1)[5],  f(1)[6],  f(4)[10],  f(7)[16],
  )

  [And instead, if we allocate the data type using C style allocation it will look like this:]
  
  table(
    columns: (5em, 1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),
    align: center,
    f(20)[A total size of 16 bytes],
    [Value],  f(type: "tag", 1)[0],   f(type: "pad", 1)[...], f(2)[1],   f(1)[2],  f(1)[3],  f(1)[4],  f(type: "pad", 1)[...], f(4)[5],   f(type: "pad", 7)[...],
    [Type],   f(type: "tag", 1)[Tag], f(type: "pad", 1)[Pad], f(2)[I16], f(1)[I8], f(1)[I8], f(1)[I8], f(type: "pad", 1)[Pad], f(4)[I32], f(type: "pad", 7)[End pad],
    [Bytes],  f(type: "tag", 1)[1],   f(type: "pad", 1)[1],   f(2)[2],   f(1)[1],  f(1)[1],  f(1)[1],  f(type: "pad", 1)[1],   f(4)[4],   f(type: "pad", 7)[4],
    [Offset], f(type: "tag", 1)[0],   f(type: "pad", 1)[1],   f(2)[2],   f(1)[4],  f(1)[5],  f(1)[6],  f(type: "pad", 1)[7],   f(4)[8],   f(type: "pad", 7)[12],
    // [Total],  f(1)[1],   f(1)[2],  f(2)[4],   f(1)[5],  f(1)[6],  f(4)[10],  f(7)[16],
  )
}

In this case we can see that the C style allocation is equally memory efficient, but this is not 
always the case. For larger structs it is smart to organize fields in an memory efficient order as to 
remove the need for padding. When in doubt; putting fields in an increasing order based
on their size is a valid strategy.

When using other data types inside your data type, say, data type B is a field inside 
data type A, B has to be allocated either directly or on the heap using pointer indirection. 
For any recrusive or mutually recursive data types, heap allocation is a must.
If field B is declared using pointers,
it is represented using a #alignBase byte pointer which points to the instance of B.
If one instead opts to directly the field has to be aligned to an #alignBase multiple address.
As data types are always end-aligned to 8 bytes on their own, no end padding for this field is needed here.

Take these data types as en example: `data B = B I64; data A = A B I8`
and the instances\ `b = B 32; a = A b 16`
On it's own `b` looks like this:

#table(
  columns: (5em,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),
  align: center,
  f(17)[A total size of 16 bytes],
  [Value],  f(type: "tag",1)[0],   f(type: "pad",7)[...], f(8)[16],
  [Type],   f(type: "tag",1)[Tag], f(type: "pad",7)[Pad], f(8)[I64],
  [Bytes],  f(type: "tag",1)[1],   f(type: "pad",7)[...], f(8)[8],
  [Offset], f(type: "tag",1)[1],   f(type: "pad",7)[0],   f(8)[8],
)
And `A` will look like this if pointer indirection is used:

#table(
  columns: (4em,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),
  align: center,
  f(25)[A total size of 24 bytes],
  [Value],  f(type: "tag",1)[0],   f(type:"pad",7)[...], f(8)[`b`],  f(1)[16], f(type: "pad",7)[...],
  [Type],   f(type: "tag",1)[Tag], f(type:"pad",7)[Pad], f(8)[`*B`], f(1)[I8], f(type: "pad",7)[End pad],
  [Bytes],  f(type: "tag",1)[1],   f(type:"pad",7)[7],   f(8)[8],    f(1)[1],  f(type: "pad",7)[7],
  [Offset], f(type: "tag",1)[0],   f(type:"pad",7)[1],   f(8)[8],    f(1)[9],  f(type: "pad",7)[10],
)

And here is what `A` will look like if we do not use pointer indirection:
#table(
  columns: (4em,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),
  align: center,
  f(33)[A total size of 32 bytes],
  [Value], f(type: "tag",1)[0],f(type:"pad",7)[...],f(1, type: "tag")[`0`],f(7,type: "pad")[...],f(8)[32], f(1)[16],f(type: "pad",7)[...],
  [Type],  f(type: "tag",1)[T],f(type:"pad",7)[Pad],f(1, type: "tag")[`T`],f(7,type: "pad")[Pad],f(8)[I64],f(1)[I8],f(type: "pad",7)[End pad],
  [Bytes], f(type: "tag",1)[1],f(type:"pad",7)[7],  f(1, type: "tag")[1],  f(7,type: "pad")[7],    f(8)[8],    f(1)[1], f(type: "pad",7)[7],
  [Offset],f(type: "tag",1)[0],f(type:"pad",7)[1],  f(1, type: "tag")[8],  f(7,type: "pad")[9],    f(8)[16],   f(1)[24], f(type: "pad",7)[25],
)
As can be seen here, no optimization is done in regards to the inner `b`.
Theoretically, the second padding could be removed, the second tag moved to the second byte,
and the first padding modified to be 6 bytes, starting at offset 2. 
This would reduce the overall size 
by 8 bytes. This is not done however, as `b` needs to be allocated in the same
way as any other instance of `B`. Special treatment can not be done, as a function which recieves a 
`B` should assume that `B` is always allocated the same way. If this type of memory 
optimization is needed, manual inlining should be done. 

When allocating for data types that contain multiple constructors (`data Cooler = C1 I8 | C2 I64` for example),
all allocations will be of the size of the largest constructor. The smaller constructors will simply 
increase their end padding to make up for the required space.

For structs (i.e data types without multiple constructors), the allocation
works the exact same way, but the first byte is not used for a tag and that space
can be freely used for fields.


=== Allocating values on the stack
Similary to data types, all variables  are allocated in the same way.
Non-data type variables i.e intetegers and booleans etc, are allocated
and alligned to addresses based on their size.
If a 4 byte integer is allocated on the stack, padding might have to be added to align it to an
address which is a multiple of 4. After all variables are allocated, padding will be added
to align the stack pointer to a multiple of 8.

#pagebreak()
#bibliography("Refs.bib")
