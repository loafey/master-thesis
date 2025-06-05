#import "../Prelude.typ": *

#let singleStackFrame = figure(
  grid(
    columns: (0.5fr, 1fr, 0.5fr),
    [],
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
  ),
  caption: [
    A stack frame containing the variables `a` and `b`,
    and any register spilling will occur in address space `0x30` and below.
  ],
)

#let x86withTailCall = figure(
  caption: "Function call with tail call optimization",
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

#let cell(title, desc, content) = block(
  breakable: false,
  table(
    columns: (0.7fr, 1fr),
    stroke: 0.1pt,
    table.cell(rowspan: 1, title),
    table.cell(rowspan: 2, align(horizon, block(inset: 4pt, content))),
    table.cell(rowspan: 1, desc),
  ),
)

#let cell2(title, desc, content) = block(
  breakable: false,
  table(
    columns: 100%,
    stroke: 0.1pt,
    table.cell(rowspan: 1, title),
    table.cell(rowspan: 1, inset: 10pt, content),
    table.cell(rowspan: 1, desc),
  ),
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
  grid(
    cell(
      [Stack tuple],
      [
        Compile $v_2$ first to ensure that SP points to a valid stack, then compile $v_1$.
      ],
      $#scheme_pos($(v_1,v_2)$)^omega_(rho,sigma) =
      #code_box($#sem[$v_2$]^omega_rho$, $#sem[$v_1$]^known_sigma$)$,
    ),
    cell(
      [Tuple],
      [Compile $v_2$ first, to ensure conformity with the stack tuple.],
      $#scheme_pos($(v_1,v_2)$)^known_(rho,sigma) =
      #code_box($#sem[$v_2$]^known_rho$, $#sem[$v_1$]^known_sigma$)$,
    ),

    cell(
      [Existential introduction],
      [Compile the value $v_1$. Because types do not exist at runtime it is
        just a recursive call.],
      $#scheme_pos($(@t, v_1)$)^alpha_rho = #code_box($#sem[$v_1$]^alpha_rho$)$,
    ),
    cell(
      [Indirection to a stack],
      [Create space on the stack for the stack pointer to $v_1$. Backup SSP and
        SP. Compile $v_1$, setting SP to the stack $v_1$. Write SP to the space
        created, then restore SP and SSP to their previous states.],
      $#scheme_pos($square v_1$)^known_rho =
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

    cell(
      [Right injection],
      [Compile $v_1$ and push the tag $0$ on the stack. The tag must be pushed
        after the compilation of $v_1$ because when $alpha = omega$, SP might not
        be a valid stack.],
      $#scheme_pos($"inl" v_1$)^alpha_rho =
      #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(0)$)$,
    ),
    cell(
      [Left injection],
      [Compile $v_1$ and push the tag $1$ on the stack.],
      $#scheme_pos($"inr" v_1$)^alpha_rho =
      #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(1)$)$,
    ),

    cell(
      [Stack variable],
      [Set SP to $r_0$, essentially switching stack.],
      $#scheme_pos($x$)^omega_(x |-> [r_0]) =
      #code_box($&s p = r_0$)$,
    ),
    cell(
      [Variable],
      [Push the variable on the stack.],
      $#scheme_pos($x$)^known_(x |-> s_n) =
      #code_box($push_(s p)(s_n)$)$,
    ),

    cell(
      [Unit],
      [$()$ does not exist at runtime. \ \
      ],
      $#scheme_pos($()$)^known_[] = #code_box("")$,
    ),
    cell(
      [Static function],
      [Generate a unique label $l_1$. Under $l_1$, let $r_1$ be the next
        available pseudo register, then set it to $sp$ and compile the command
        $c$. Finally, push $l_1$ on the stack. $l_1$ and the block can be thought
        of as creating a procedure in a C-like language, and thus, we must be
        careful about nesting.],
      $#scheme_pos($lambda^* x. c$)^known_[] =
      &#code_block($l_1$, meta($"let" r_1 = "next"([], #math.italic("ptr"))$), $r_1 = s p$, $""^-#sem[c]_(x |-> r_1)$) \
      & #code_box($push_(s p)(l_1)$)$,
    ),

    cell(
      [Newstack],
      [
        Allocates a new stack and switches to it.
        $S$ is the size of the stack to be allocated.

        Some implementation specific details are omitted. @MemoryAlignment goes
        into more detail how a stack is allocated in #ln.
        // The start pointer is stored at the bottom of the stack.
      ],
      $#scheme_pos(newstack)^omega_[] =
      #code_box($r_1 <- "malloc"(S)$, $s p = r_1$)$,
      // #code_box($r_1 <- "malloc"(S)$, $r_2 = r_1$, $r_1 = r_1 + S$, $r_1 = r_1 - 8$, $s p = r_1$, $push_sp (r_2)$)$,
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
  grid(
    cell2(
      [Pop top of stack],
      [
        Pops the top value of the stack $z$
        and stores it in $r_1$. $y$ is
        the rest of the stack.
      ],
      $#scheme_neg($"let" x,y = z^omega : A times.circle B; c$)_(rho, z |-> [r_0])
      =
      #code_box(meta($"let" r_1 = "next"(rho, A)$), $pop_(r_0)(r_1)$, $#sem[c]^omega_(rho, x |-> r_1, y |-> [r_0])$)$,
    ),

    cell2(
      [Destruct tuple],
      [
        Split the environment into two disjoint lists of pseudo registers. The
        environment $x$ is the environment $s_0$ and $y$ is $s_1$. The invariant states that the size of $s_0$ and $s_1$ are determined by the size of the types $A$ and $B$],
      $#scheme_neg($"let" x,y = z^known : A times.circle B; c$)_(rho, z |-> s_0 ++ s_1)
      = #code_box($#sem[c]^known_(rho, x |-> s_0, y |-> s_1)$) \ quad #math.italic[such that:] |s_0| = "sizeof"(A); |s_1| = "sizeof"(B)$,
    ),

    cell2(
      [Unit elimination],
      [Because the unit value does not exist at runtime, the matching is a no-op.],
      $#scheme_neg($"let" () = z^known; c$)_(rho,z |-> [])
      = #code_box($#sem[c]_rho$)$,
    ),

    cell2(
      [Existential elimination],
      [Types have no runtime representation.],
      $#scheme_neg($"let" @t, x = z^alpha; c$)_(rho, z |-> s_n)
      = #code_box($#sem[c]_(rho, x |-> s_n)$)$,
    ),

    cell2(
      [Following an indirection],
      [Because $r_0$ is the pointer to the stack already, we just need to update the environment.],
      $#scheme_neg($"let" square x = z^known; c$)_(rho, z |-> [r_0])
      = #code_box($#sem[c]_(rho, x |-> [r_0])$)$,
    ),

    cell2(
      [Stack deallocation],
      [
        Deallocate the stack $r_0$, then compile the command $c$.],
      $#scheme_neg($"freestack" z^omega; c$)_(rho, z |-> [r_0])
      = #code_box($"free"(r_0)$, $#sem[c]_rho$)$,
    ),

    cell2(
      [Case expression with variable which is a stack],
      [Pop the tag from the stack $r_0$. Generate the appropriate branching
        instructions using `iszero`. Because the tag has been popped from $r_0$,
        the value under the injection is at the top of the stack.],
      $#scheme_neg($"case" & z^omega "of" { \ & "inl" x |-> c_1; \ & "inr" y |-> c_2;}$)_(rho, z |-> [r_0])
      = #code_box(
        meta($"let" r_1 = "next"(rho, "int")$),
        $pop_(r_0)(r_1)$,
        $"if" "iszero"(r_1)$,
        $quad "then" #sem[$c_1$]_(rho, x |-> [r_0])$,
        $quad "else" #sem[$c_2$]_(rho, y |-> [r_0])$,
      )$,
    ),

    cell2(
      [Case expression with variable],
      [Because $z$ is not a stack, it corresponds to a non-empty list of pseudo
        registers where the head is the tag, and the remaining pseudo registers
        correspond to the value under the injection.],
      [$#scheme_neg($"case" z^known "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> r_1: s_n)
        = #code_box(
          $"if" & "iszero"(r_1)\
          & "then" #sem[$c_1$]_(rho, x |-> s_n)\
          & "else" #sem[$c_2$]_(rho, y |-> s_n)$,
        )$
      ],
    ),

    cell2(
      [Function call],
      [Compile $v$, preparing the stack, and then jump to the label $r_0$.],
      $#scheme_neg($"call" z^known (v)$)_(rho, z |-> [r_0]) =
      #code_box($&#sem[$v$]^omega_(rho)$, $&jmp r_0$)$,
    ),
  )
}
