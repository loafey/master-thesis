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


#let positive_compilation_scheme = {
  $#compilation_scheme($(v_1,v_2)$)^omega_(rho,sigma) =
  #code_box($#sem[$v_2$]^omega_rho$, $#sem[$v_1$]^n_sigma$)$

  linebreak()
  linebreak()

  $#compilation_scheme($(v_1,v_2)$)^n_(rho,sigma) =
  #code_box($#sem[$v_2$]^n_rho$, $#sem[$v_1$]^n_sigma$)$

  linebreak()
  linebreak()

  $#compilation_scheme($(@t, v_1)$)^alpha_rho = #code_box($#sem[$v_1$]^alpha_rho$)$

  linebreak()
  linebreak()

  $#compilation_scheme($square v_1$)^n_rho =
  #code_box(
    $sp = sp + 1$,
    $push_(sp)(ssp)$,
    $ssp = sp$,
    $#sem[$v_1$]^omega_rho$,
    $[ssp - 1] = sp$,
    $sp = ssp - 1$,
    $ssp = [ssp]$,
  )$

  linebreak()
  linebreak()

  $#compilation_scheme($"inl" v_1$)^alpha_rho =
  #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(0)$)$

  linebreak()
  linebreak()

  $#compilation_scheme($"inr" v_1$)^alpha_rho =
  #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(1)$)$

  linebreak()
  linebreak()

  $#compilation_scheme($x$)^omega_(x |-> {r_0}) =
  #code_box($&s p = r_0$)$

  linebreak()
  linebreak()

  $#compilation_scheme($x$)^n_(x |-> r_0) =
  #code_box($push_(s p)(r_0)$)$

  linebreak()
  linebreak()

  $#compilation_scheme($()$)^n_{} = #code_box("")$

  linebreak()
  linebreak()

  $#compilation_scheme($lambda x. c$)^1_{} =
  &#code_block(
    $l_1$,
    meta($"let" r_1 = "next"({}, #math.italic("ptr"))$),
    $r_1 = s p$,
    $#sem[c]_(x |-> {r_1})$,
  ) \ & #code_box($push_(s p)(l_1)$)$

  linebreak()
  linebreak()

  $#compilation_scheme(newstack)^omega_{} =
  #code_box($r_1 <- newstack$, $s p = r_1$)$
}
#let negative_compilation_scheme = {
  $#compilation_scheme($"let" x,y = z^omega : A times.circle B; c$)_(rho, z |-> {r_0})
  = #code_box(meta($"let" r_1 = "next"(rho, A)$), $pop(r_1)$, $#sem[c]^omega_(rho, x |-> r_1, y |-> {r_0})$)$

  linebreak()
  linebreak()

  $#compilation_scheme($"let" x,y = z^n : A times.circle B; c$)_(rho, z |-> {r_0, r_1})
  = #code_box($#sem[c]^n_(rho, x |-> {r_0}, y |-> {r_1})$)$

  linebreak()
  linebreak()

  $#compilation_scheme($"let" () = z^n; c$)_(rho,z |-> {})
  = #code_box($#sem[c]_rho$)$

  linebreak()
  linebreak()

  $#compilation_scheme($"let" @t, x = z^alpha; c$)_(rho, z |-> r_0)
  = #code_box($#sem[c]_(rho, x |-> r_0)$)$

  linebreak()
  linebreak()

  $#compilation_scheme($"let" square x = z^1; c$)_(rho, z |-> {r_0})
  = #code_box($#sem[c]_(rho, x |-> {r_0})$)$

  linebreak()
  linebreak()

  $#compilation_scheme($"let" \_ = "freestack" z^omega; c$)_(rho, z |-> {r_0})
  = #code_box($"free"(r_0)$, $#sem[c]_rho$)$

  linebreak()
  linebreak()

  $#compilation_scheme($"case" z^omega "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> {r_0})
  = #code_box(
    meta($"let" r_1 = "next"(rho, "int")$),
    $pop(r_1)$,
    $"if" "iszero"(r_1)$,
    $quad "then" #sem[$c_1$]_(rho, x |-> {r_0})$,
    $quad "else" #sem[$c_2$]_(rho, y |-> {r_0})$,
  )$

  linebreak()
  linebreak()

  $#compilation_scheme($"case" z^n "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> r_1: r_s)
  = #code_box($"if iszero"(r_1) "then" #sem[$c_1$]_(rho, x |-> r_s) "else" #sem[$c_2$]_(rho, y |-> r_s)$)$

  linebreak()
  linebreak()

  $#compilation_scheme($"call" z^n (v)$)_(rho, z |-> {r_0}) =
  #code_box($&#sem[$v$]^omega_(rho)$, $&jmp r_0$)$
}
