#import "../Prelude.typ":*

#let singleStackFrame = figure(kind: image, drawStack(
    [],             [`a`    ],[`0x40`],
    [],             [`b`    ],[`0x38`],
    [spilling $->$],[ . . . ],[`0x30`],
), caption: [
    A stack frame containing the variables `a` and `b`,
    and any spilling will occur in address space `0x30` and below.
])

#let x86withTailCall = figure(
  caption: "Function call with tail call optimization", 
  kind: image,
  grid(
    columns: (1fr,1fr),
    stack(
      "Before function call:",
      spacing: 1.0%, 
      drawStack(
        [Frame 1 $->$], [...],[]
      )
    ),
    stack(
      "During function call:",
      spacing: 1.0%, 
      drawStack(
        [Frame 2 $->$], [...],[],
      ),
    )
  )
)

#let x86withoutTailCall = figure(
  caption: "Function call without tail call optimization", 
  kind: image,
  grid(
    columns: (1fr,1fr),
    stack(
      "Before function call:",
      spacing: 1.0%, 
      drawStack(
        [Frame 1 $->$], [...],[]
      )
    ),
    stack(
      "During function call:",
      spacing: 1.0%, 
      drawStack(
        [Frame 1 $->$], [...],[],
        [Frame 2 $->$], [...],[],
      ),
    )
  )
)