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

#let positive_compilation_scheme = fancyTable(
  columns: (0.8fr, 1fr),
  inset: (top: 6pt, bottom: 6pt),
  [Tuple where $v_2$ is a stack],
  [Tuple with two values],
  $#compilation_scheme($(v_1,v_2)$)^omega_(rho,sigma) =
  #code_box($#sem[$v_2$]^omega_rho$, $#sem[$v_1$]^n_sigma$)$,
  $#compilation_scheme($(v_1,v_2)$)^n_(rho,sigma) =
  #code_box($#sem[$v_2$]^n_rho$, $#sem[$v_1$]^n_sigma$)$,

  [Existental introduction (see #todo[add me])],
  [Put a stack pointer on the current stack],
  $#compilation_scheme($(@t, v_1)$)^alpha_rho = #code_box($#sem[$v_1$]^alpha_rho$)$,
  $#compilation_scheme($square v_1$)^n_rho =
  #code_box(
    $sp = sp + 1$,
    $push_(sp)(ssp)$,
    $ssp = sp$,
    $#sem[$v_1$]^omega_rho$,
    $[ssp - 1] = sp$,
    $sp = ssp - 1$,
    $ssp = [ssp]$,
  )$,

  [Sum-type left constructor],
  [Sum-type right constructor],
  $#compilation_scheme($"inl" v_1$)^alpha_rho =
  #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(0)$)$,
  $#compilation_scheme($"inr" v_1$)^alpha_rho =
  #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(1)$)$,

  [Set stack to variable],
  [Push variable on stack],
  $#compilation_scheme($x$)^omega_(x |-> {r_0}) =
  #code_box($&s p = r_0$)$,
  $#compilation_scheme($x$)^n_(x |-> r_0) =
  #code_box($push_(s p)(r_0)$)$,

  [Unit (nothing is done)],
  [Lambdas (see @lambdaLifting)],
  $#compilation_scheme($()$)^n_{} = #code_box("")$,
  $#compilation_scheme($lambda x. c$)^1_{} =
  &#code_block($l_1$, meta($"let" r_1 = "next"({}, #math.italic("ptr"))$), $r_1 = s p$, $#sem[c]_(x |-> {r_1})$) \
  & #code_box($push_(s p)(l_1)$)$,

  table.cell(colspan: 2, [Create a stack and switch to it]),
  table.cell(
    colspan: 2,
    $#compilation_scheme(newstack)^omega_{} =
    #code_box($r_1 <- newstack$, $s p = r_1$)$,
  ),
)

#let negative_compilation_scheme = fancyTable(
  [whu],
  $#compilation_scheme($"let" x,y = z^omega : A times.circle B; c$)_(rho, z |-> {r_0})
  = #code_box(meta($"let" r_1 = "next"(rho, A)$), $pop(r_1)$, $#sem[c]^omega_(rho, x |-> r_1, y |-> {r_0})$)$,
  [whu],
  $#compilation_scheme($"let" x,y = z^n : A times.circle B; c$)_(rho, z |-> {r_0, r_1})
  = #code_box($#sem[c]^n_(rho, x |-> {r_0}, y |-> {r_1})$)$,
  [Unit elimination],
  $#compilation_scheme($"let" () = z^n; c$)_(rho,z |-> {})
  = #code_box($#sem[c]_rho$)$,
  [whu],
  $#compilation_scheme($"let" @t, x = z^alpha; c$)_(rho, z |-> r_0)
  = #code_box($#sem[c]_(rho, x |-> r_0)$)$,
  [whu],
  $#compilation_scheme($"let" square x = z^1; c$)_(rho, z |-> {r_0})
  = #code_box($#sem[c]_(rho, x |-> {r_0})$)$,
  [Stack de-allocation],
  $#compilation_scheme($"let" \_ = "freestack" z^omega; c$)_(rho, z |-> {r_0})
  = #code_box($"free"(r_0)$, $#sem[c]_rho$)$,
  [Case expression],
  $#compilation_scheme($"case" z^omega "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> {r_0})
  = #code_box(
    meta($"let" r_1 = "next"(rho, "int")$),
    $pop(r_1)$,
    $"if" "iszero"(r_1)$,
    $quad "then" #sem[$c_1$]_(rho, x |-> {r_0})$,
    $quad "else" #sem[$c_2$]_(rho, y |-> {r_0})$,
  )$,
  [whu],
  [$#compilation_scheme($"case" z^n "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> r_1: r_s)
    = #box(
      code_box($"if iszero"(r_1)$, $quad "then" #sem[$c_1$]_(rho, x |-> r_s)$, $quad "else" #sem[$c_2$]_(rho, y |-> r_s)$),
    )$
    #v(10pt)
  ],

  [whu],
  $#compilation_scheme($"call" z^n (v)$)_(rho, z |-> {r_0}) =
  #code_box($&#sem[$v$]^omega_(rho)$, $&jmp r_0$)$,
)
