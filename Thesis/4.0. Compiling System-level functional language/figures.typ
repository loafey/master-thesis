#import "../Prelude.typ": *

#let singleStackFrame = figure(
  kind: image,
  drawStack(
    [],
    [`a` ],
    [`0x40`],
    [],
    [`b` ],
    [`0x38`],
    [spilling $->$],
    [ . . . ],
    [`0x30`],
  ),
  caption: [
    A stack frame containing the variables `a` and `b`,
    and any spilling will occur in address space `0x30` and below.
  ],
)

#let x86withTailCall = figure(
  caption: "Function call with tail call optimization",
  kind: image,
  grid(
    columns: (1fr, 1fr),
    stack(
      "Before function call:",
      spacing: 1.0%,
      drawStack(
        [Frame 1 $->$],
        [...],
        [],
      ),
    ),
    stack(
      "During function call:",
      spacing: 1.0%,
      drawStack(
        [Frame 2 $->$],
        [...],
        [],
      ),
    ),
  ),
)

#let x86withoutTailCall = figure(
  caption: "Function call without tail call optimization",
  kind: image,
  grid(
    columns: (1fr, 1fr),
    stack(
      "Before function call:",
      spacing: 1.0%,
      drawStack(
        [Frame 1 $->$],
        [...],
        [],
      ),
    ),
    stack(
      "During function call:",
      spacing: 1.0%,
      drawStack(
        [Frame 1 $->$],
        [...],
        [],
        [Frame 2 $->$],
        [...],
        [],
      ),
    ),
  ),
)

// #{
//   let frame(stroke) = (x, y) => (
//     left: stroke,
//     right: stroke,
//     top: if y < 2 { stroke } else { rgb("00000040") },
//     bottom: stroke,
//   )
//   set table(
//     fill: (rgb("#f3f7f8"), none),
//     stroke: frame(rgb("21222C")),
//   )
//   figure(
//     caption: [Translations between pseudo and x86-64 values and instructions.],
//     grid(
//       row-gutter: 10pt,
//       table(
//         columns: (1fr, 1fr),
//         [*Pseudo instruction*], [*x86-64 instructions*],
//         `push VAL`, [],
//         `push VAL_1 on VAL_2`, [],
//         `VAL_1 = VAL_2`, [],
//         `pop VAL`, [],
//         `jnz L`, [],
//         `jmp L`, [],
//         `L:`, [],
//         `mov VAL_1 = VAL_2`, [],
//       ),
//       table(
//         columns: (1fr, 1fr),
//         [*VAL*], [*x86-64 val*],
//         `[0-9]+`, [`$[0-9]+`],
//         $#sym.rho\(x)$, [Fitting register or location on the system stack (`x(%RBP)`)],
//         `SP`, [`%R15`],
//         `SSP`, [`%R14`],
//         `VAL_1[VAL_2]`, [`VAL_2(%VAL_1)`],
//         `[VAL]`, [`0(%VAL_1)`],
//       )
//     ),
//   )
// }
//

#let cell(title, desc, content) = (
  table.cell(rowspan: 1, title),
  table.cell(rowspan: 2, content),
  table.cell(rowspan: 1, desc),
)

#let cell2(title, desc, content) = (
  table.cell(rowspan: 1, title),
  table.cell(rowspan: 1, inset: 10pt, content),
  table.cell(rowspan: 1, desc),
)

#let positive_compilation_scheme = {
  let frame(stroke) = (x, y) => (
    left: stroke,
    right: stroke,
    top: if (calc.rem(y, 2) == 0) { stroke } else { rgb("00000040") },
    bottom: stroke,
  )
  set table(
    fill: (x, y) => if (x == 0 and calc.rem(y, 2) == 0) { rgb("#00000010") } else { white },
    stroke: frame(rgb("21222C")),
    align: (x, y) => if (calc.rem(y, 2) == 0 and x == 0) { center } else { left },
  )
  table(
    columns: (0.84fr, 1fr),
    inset: (top: 6pt, bottom: 6pt),

    ..cell(
      [Tuple where $v_2$ is a stack],
      [
        Compile the right value, which is a stack, then compile the left value
        and then push that on the stack.
      ],
      $#compilation_scheme($(v_1,v_2)$)^omega_(rho,sigma) =
      #code_box($#sem[$v_2$]^omega_rho$, $#sem[$v_1$]^known_sigma$)$,
    ),
    ..cell(
      [Tuple with no stack],
      [Compile the values right to left.],
      $#compilation_scheme($(v_1,v_2)$)^known_(rho,sigma) =
      #code_box($#sem[$v_2$]^known_rho$, $#sem[$v_1$]^known_sigma$)$,
    ),
    ..cell(
      [Existental introduction],
      [desc],
      $#compilation_scheme($(@t, v_1)$)^alpha_rho = #code_box($#sem[$v_1$]^alpha_rho$)$,
    ),
    ..cell(
      [Put a stack pointer on the current stack],
      [desc],
      $#compilation_scheme($square v_1$)^known_rho =
      #code_box(
        $sp = sp + 1$,
        $push_(sp)(ssp)$,
        $ssp = sp$,
        $#sem[$v_1$]^omega_rho$,
        $[ssp - 1] = sp$,
        $sp = ssp - 1$,
        $ssp = [ssp]$,
      )$,
    ),
    ..cell(
      [Sum-type left constructor],
      [Wrap a value in the left sym-type constructor.],
      $#compilation_scheme($"inl" v_1$)^alpha_rho =
      #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(0)$)$,
    ),
    ..cell(
      [Sum-type right constructor],
      [Wrap a value in the right sym-type constructor.],
      $#compilation_scheme($"inr" v_1$)^alpha_rho =
      #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(1)$)$,
    ),
    ..cell(
      [Set stack to variable],
      [Switches the stack to one stored in a variable.],
      $#compilation_scheme($x$)^omega_(x |-> {r_0}) =
      #code_box($&s p = r_0$)$,
    ),
    ..cell(
      [Push variable on stack],
      [Simply pushes the a variable on the current stack.],
      $#compilation_scheme($x$)^known_(x |-> r_0) =
      #code_box($push_(s p)(r_0)$)$,
    ),
    ..cell(
      [Unit],
      [Nothing is done when compiling this.],
      $#compilation_scheme($()$)^known_{} = #code_box("")$,
    ),
    ..cell(
      [Lambdas],
      [See @lambdaLifting for more details.],
      $#compilation_scheme($lambda x. c$)^known_{} =
      &#code_block($l_1$, meta($"let" r_1 = "next"({}, #math.italic("ptr"))$), $r_1 = s p$, $#sem[c]_(x |-> {r_1})$) \
      & #code_box($push_(s p)(l_1)$)$,
    ),
    ..cell(
      [Newstack],
      [Allocates a new stack and switches to it.],
      $#compilation_scheme(newstack)^omega_{} =
      #code_box($r_1 <- newstack$, $s p = r_1$)$,
    ),
  )
}

#let negative_compilation_scheme = {
  let frame(stroke) = (x, y) => (
    left: stroke,
    right: stroke,
    top: if (calc.rem(y, 3) == 0) { stroke } else { rgb("00000040") },
    bottom: stroke,
  )
  set table(
    fill: (x, y) => if (x == 0 and calc.rem(y, 3) == 0) { rgb("#00000010") } else { white },
    stroke: frame(rgb("21222C")),
    align: (x, y) => if (calc.rem(y, 3) == 0) { center } else { left },
  )
  table(
    columns: 1fr,
    ..cell2(
      [Pop top of stack],
      [
        Pops the top value of the stack ($x$ here)
        and stores it in $r_1$. $y$ represents
        the rest of the stack.
      ],
      $#compilation_scheme($"let" x,y = z^omega : A times.circle B; c$)_(rho, z |-> {r_0})
      =
      #code_box(meta($"let" r_1 = "next"(rho, A)$), $pop_(r_0)(r_1)$, $#sem[c]^omega_(rho, x |-> r_1, y |-> {r_0})$)$,
    ),


    ..cell2(
      [Destruct tuple],
      [
        Breaks a tuple into its two values.
        Does nothing except mapping the two
        values to pseudo registers, and compile the next command.
      ],
      $#compilation_scheme($"let" x,y = z^known : A times.circle B; c$)_(rho, z |-> s_0 ++ s_1)
      = #code_box($#sem[c]^known_(rho, x |-> s_0, y |-> s_1)$) \ quad #math.italic[invariant:] |s_0| = "size" A; |s_1| = "size" B$,
    ),

    ..cell2(
      [Unit elimination],
      [
        Similary like it's positive fragment variant,
        this does nothing except compile the next command.],
      $#compilation_scheme($"let" () = z^known; c$)_(rho,z |-> {})
      = #code_box($#sem[c]_rho$)$,
    ),

    ..cell2(
      [whu],
      [waaa],
      $#compilation_scheme($"let" @t, x = z^alpha; c$)_(rho, z |-> r_0)
      = #code_box($#sem[c]_(rho, x |-> r_0)$)$,
    ),

    ..cell2(
      [whu],
      [waaa],
      $#compilation_scheme($"let" square x = z^known; c$)_(rho, z |-> {r_0})
      = #code_box($#sem[c]_(rho, x |-> {r_0})$)$,
    ),

    ..cell2(
      [Stack de-allocation],
      [
        Deallocates the current stack. This is currently implemented
        using GLIBC's `free`.
      ],
      $#compilation_scheme($"let" \_ = "freestack" z^omega; c$)_(rho, z |-> {r_0})
      = #code_box($"free"(r_0)$, $#sem[c]_rho$)$,
    ),

    ..cell2(
      [Case expression with variable which is a stack],
      [waaa],
      $#compilation_scheme($"case" & z^omega "of" { \ & "inl" x |-> c_1; \ & "inr" y |-> c_2;}$)_(rho, z |-> {r_0})
      = #code_box(
        meta($"let" r_1 = "next"(rho, "int")$),
        $pop_(r_0)(r_1)$,
        $"if" "iszero"(r_1)$,
        $quad "then" #sem[$c_1$]_(rho, x |-> {r_0})$,
        $quad "else" #sem[$c_2$]_(rho, y |-> {r_0})$,
      )$,
    ),

    ..cell2(
      [Case expression with variable],
      [Cases on the top of the stack,],
      [$#compilation_scheme($"case" z^known "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> r_1: r_s)
        = #code_box(
          $"if" & "iszero"(r_1)\
          & "then" #sem[$c_1$]_(rho, x |-> r_s)\
          & "else" #sem[$c_2$]_(rho, y |-> r_s)$,
        )$
      ],
    ),

    ..cell2(
      [Function call],
      [wooo],
      $#compilation_scheme($"call" z^known (v)$)_(rho, z |-> {r_0}) =
      #code_box($&#sem[$v$]^omega_(rho)$, $&jmp r_0$)$,
    ),
  )
}
