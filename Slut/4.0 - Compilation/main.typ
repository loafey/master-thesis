#import "../Prelude.typ": *

= Compiling #ln

#include "transformations.typ"

== Compilation
#ln uses a compilation scheme for the fragments!

This turns the language into a pseudo assembly language, which
can then be translated into x86-64 assembly!

== Application Binary Interface -- ABI
This defines how functions are called and how memory should be represented.

For function calls some requirements are needed:
#indent[
  - Register `%R15` (SP) is set to a pointer to a valid stack.
  - All expected arguments exist on the stack.
  - The stack grows downwards.

  - ...
]

Some other requirements:

#indent[
  - Proper memory alignment.

  - How top-level functions work\
    (they are actually constants that contain the actual function pointer
    #emoji.face.flush
    #emoji.excl
    )
]

== Application Binary Interface -- System Stack
The language has two different concepts of stacks!
#let top(a) = table.cell(align: center, fill: rgb("0000001F"), a)
#table(
  columns: (1fr, 1fr),
  top[System-Stack], top[Dynamic Stack],
  drawStack(
    ..([`%RBP` $->$], [$v_1$], [`0x30`]),
    ..([], [$v_2$], [`0x20`]),
    ..([`%RSP` $->$], [$v_3$], [`0x10`]),
  ),
  drawStack(
    ..([], [$a_2$], [`0xF0`]),
    ..([], [$a_1$], [`0xE0`]),
    ..([`%R15` $->$\ This is SP!!], [$t_1$], [`0xD0`]),
  ),

  [Used for "infinite" registers.],
  [
    Used for argument passing, capturing, and calculations.
  ],
)
Works very similarly to JVM/WASM!



== Compilation Scheme

#{
  set text(size: 1.4em)
  align(
    center + horizon,
    $#scheme_pos($(v_1,v_2)$)^known_(rho,sigma) =
    #code_box($#sem[$v_2$]^known_rho$, $#sem[$v_1$]^known_sigma$)$,
  )
}
#align(
  bottom,
  [
    $rho, sigma$ = environment of mapping from variable to register\
    $omega, known$ = kind
  ],
)


== Compilation Scheme Example
#let sch = (a, b, c) => {
  let bottom = if c == none { ([], []) } else {
    (
      align(right + horizon, block(inset: 10pt, [Compilation scheme:])),
      align(left + horizon, c),
    )
  }
  grid(
    columns: (1fr, 1fr),
    rows: (1fr, 0.6fr),
    row-gutter: 10pt,
    a, b,
    ..bottom,
  )
}
#(pre.anim)(
  [],
  (
    [```asm
      inc : *(int ⊗ ~int)
        = ...;
      ```

      ```asm
      func : *~int
        = \e -> inc((42, e));
      ```
    ],
    [```asm
      inc : *(int ⊗ (∃γ. (int ⊗ γ) ⊗ γ))
        = ...;
      ```

      ```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
        = \e -> inc((42, e));
      ```
    ],
    [
      ```asm
      inc : *(int ⊗ (∃γ. (int ⊗ γ) ⊗ γ))
        = ...;
      ```
      #block(
        stroke: blue,
        outset: 4pt,
        ```asm
        func : *(∃γ. (int ⊗ γ) ⊗ γ)
          = \e -> inc((42, e));
        ```,
      )
    ],
    sch(
      block(
        stroke: blue,
        outset: 4pt,
        ```asm
        func : *(∃γ. (int ⊗ γ) ⊗ γ)
          = \e -> inc((42, e));
        ```,
      ),
      none,
      none,
    ),
    sch(
      $#```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
      ``` \ space space #`= `
      #block(stroke: blue, outset: 4pt, ```asm
      \e -> inc ((42, e));
      ```)$,
      none,
      $& #code_box($l_1 : "global" l_2$)\
      #scheme_pos($lambda^* x. c$)^known_[] =
      & #code_block($l_2$, meta($"let" r = "next"([], #math.italic("ptr"))$), $r = s p$, $""^-#sem[c]_(x |-> r)$)$,
    ),
    sch(
      $#```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
      ``` \ space space #`= `
      #block(stroke: blue, outset: 4pt, ```asm
      \e -> inc ((42, e));
      ```)$,
      [
        $"func": \ space space "global" "func_inner"$
        #linebreak()
        #linebreak()
        $"func_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space ""^-#sem(```asm
        inc ((42, e))
        ```)_("inc" -> ["inc"],e |-> r)\
        \ $
      ],

      $& #code_box($l_1 : "global" l_2$)\
      #scheme_pos($lambda^* x. c$)^known_[] =
      & #code_block($l_2$, meta($"let" r = "next"([], #math.italic("ptr"))$), $r = s p$, $""^-#sem[c]_(x |-> r)$)$,
    ),
    sch(
      $#```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #block(stroke: blue, outset: 4pt, ```asm
      inc ((42, e))
      ```)#`;`$,
      [
        $"func": \ space space "global" "func_inner"$
        #linebreak()
        #linebreak()
        $"func_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space ""^-#sem(```asm
        inc ((42, e))
        ```)_("inc" -> ["inc"], e |-> r)\
        \ $
      ],

      $\ \ #scheme_neg($"call" z^known (v)$)_(rho, z |-> [r_0]) =
      #code_box($& #sem[$v$]^omega_(rho)$, $& jmp r_0$)$,
    ),
    sch(
      $#```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #block(stroke: blue, outset: 4pt, ```asm
      inc ((42, e))
      ```)#`;`$,
      [
        $"func": \ space space "global" "func_inner"$
        #linebreak()
        #linebreak()
        $"func_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space #```asm
        ``` ""^+#sem(```asm
        (42, e)
        ```)^omega_(e -> r)\
        space space jmp "inc"\ $

      ],

      $\ \ #scheme_neg($"call" z^known (v)$)_(rho, z |-> [r_0]) =
      #code_box($& #sem[$v$]^omega_(rho)$, $& jmp r_0$)$,
    ),
    sch(
      $#```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #```asm
      inc(
      ```
      #block(
        stroke: blue,
        outset: 4pt,
        ```asm
        (42, e)
        ```,
      )
      #```asm
      );
      ```$,
      [
        $"func": \ space space "global" "func_inner"$
        #linebreak()
        #linebreak()
        $"func_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space #```asm
        ``` ""^+#sem(```asm
        (42, e)
        ```)^omega_(e -> r)\
        space space jmp "inc"\ $

      ],

      $#scheme_pos($(v_1,v_2)$)^omega_(rho,sigma) =
      #code_box($#sem[$v_2$]^omega_rho$, $#sem[$v_1$]^known_sigma$)$,
    ),
    sch(
      $#```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #```asm
      inc((
      ```
      #block(
        stroke: blue,
        outset: 2pt,
        ```asm
        42
        ```,
      )#`,`
      #block(
        stroke: blue,
        outset: 2pt,
        ```asm
        e
        ```,
      )#```asm
      ));
      ```$,
      [
        $"func": \ space space "global" "func_inner"$
        #linebreak()
        #linebreak()
        $"func_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space #```asm
        ``` ""^+#sem(```asm
        e
        ```)^omega_(e |-> r)\
        space space #```asm
        ``` ""^+#sem(```asm
        42
        ```)^known_[]\
        space space jmp "inc"\ $

      ],

      $#scheme_pos($(v_1,v_2)$)^omega_(rho,sigma) =
      #code_box($#sem[$v_2$]^omega_rho$, $#sem[$v_1$]^known_sigma$)$,
    ),
    sch(
      $#```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #```asm
      inc((42,
      ```
      #block(
        stroke: blue,
        outset: 2pt,
        ```asm
        e
        ```,
      )#```asm ));```$,
      [
        $"func": \ space space "global" "func_inner"$
        #linebreak()
        #linebreak()
        $"func_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp \
        space space space space ""^+#sem(```asm
        e
        ```)^omega_(e|->r) \
        space space #```asm
        ``` ""^+#sem(```asm
        42
        ```)^known_[]\
        space space jmp "inc"\ $
      ],

      $""^+#sem[$x$]^omega_(x |-> [r_0]) = #code_box($sp = r_0$)$,
    ),
    sch(
      $#```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #```asm
      inc((42,
      ```
      #block(
        stroke: blue,
        outset: 2pt,
        ```asm
        e
        ```,
      )#```asm ));```$,
      [
        $"func": \ space space "global" "func_inner"$
        #linebreak()
        #linebreak()
        $"func_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp \
        space space sp = r \
        space space #```asm
        ``` ""^+#sem(```asm
        42
        ```)^known_[]\
        space space jmp "inc"\ $
      ],

      $""^+#sem[$x$]^omega_(x |-> [r_0]) = #code_box($sp = r_0$)$,
    ),
    sch(
      $#```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #```asm
      inc((
      ```
      #block(
        stroke: blue,
        outset: 2pt,
        ```asm
        42
        ```,
      )
      #```asm
      , e));
      ```$,
      [
        $"func": \ space space "global" "func_inner"$
        #linebreak()
        #linebreak()
        $"func_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space sp = r\
        space space space space ""^+#sem[```asm 42```]_[]^known \
        space space jmp "inc"\ $
      ],
      $#scheme_pos[$42$]^known_[] = #code_box[$"push"_(s p)(42)$]$,
    ),
    sch(
      $#```asm
      func : *(∃γ. (int ⊗ γ) ⊗ γ)
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #```asm
      inc((42, e));
      ```$,
      [
        $"func": \ space space "global" "func_inner"$
        #linebreak()
        #linebreak()
        $"func_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space sp = r\
        space space space push_sp (42) \
        space space jmp "inc"\ $
      ],
      none,
    ),
  ),
)

#let mathCode(i) = {
  set par(spacing: 13pt)
  let code = (
    $"func":$,
    $space space "global" "func_inner"$,
    $$,
    $"func_inner":$,
    $space space \""let" r = "next"([],p t r)\"$,
    $space space space r = sp$,
    $space space sp = r$,
    $space space space push_sp (\$42)$,
    $space space jmp "inc"$,
  )
  if i == -1 {
    for l in code {
      l
      v(-1pt)
    }
  } else {
    let ind = 0
    for l in code {
      if ind == i { block(stroke: blue, outset: 4pt, l) } else { l }
      v(-1pt)
      ind += 1
    }
  }
}

== Pseudo $->$ x86-64
#let sch(i, c) = grid(
  columns: (1fr, 1fr),
  mathCode(i), c,
)
#(pre.anim)(
  [],
  (
    sch(
      -1,
      ```asm
      ```,
    ),
    sch(
      0,
      ```asm
      func:
      ```,
    ),
    sch(
      1,
      ```asm
      func: .quad func_inner
      ```,
    ),
    sch(
      -1,
      ```asm
      func: .quad func_inner
      inc:  .quad inc_inner
      ```,
    ),
    sch(
      3,
      ```asm
      func: .quad func_inner
      inc:  .quad inc_inner

      func_inner:
      ```,
    ),
    sch(
      4,
      ```asm
      func: .quad func_inner
      inc:  .quad inc_inner

      func_inner:
        # r = -8(%RBP)
      ```,
    ),
    sch(
      5,
      ```asm
      func: .quad func_inner
      inc:  .quad inc_inner

      func_inner:
        # r = -8(%RBP)
        movq %R15, -8(%RBP)
      ```,
    ),
    sch(
      6,
      ```asm
      func: .quad func_inner
      inc:  .quad inc_inner

      func_inner:
        # r = -8(%RBP)
        movq %R15, -8(%RBP)

        movq -8(%RBP), %R15
      ```,
    ),
    sch(
      7,
      ```asm
      func: .quad func_inner
      inc:  .quad inc_inner

      func_inner:
        # r = -8(%RBP)
        movq %R15, -8(%RBP)

        movq -8(%RBP), %R15

        subq $8, %R15
        movq $42, 0(%R15)
      ```,
    ),
    sch(
      8,
      ```asm
      func: .quad func_inner
      inc:  .quad inc_inner

      func_inner:
        # r = -8(%RBP)
        movq %R15, -8(%RBP)

        movq -8(%RBP), %R15

        subq $8, %R15
        movq $42, 0(%R15)

        movq inc(%RIP), %RAX
        jmp *%RAX
      ```,
    ),
  ),
)

