#import "../Prelude.typ": *

= Compiling #ln

#include "transformations.typ"

== Compilation
Lithium uses a compilation scheme, based on the negative/positive fragments in the language.

These compilation schemes compile the language into a pseudo assembly language.

This assembly language is then easily translated into x86-64, which
in turn can be compiled into machine code!


== Compilation Scheme

#table(
  columns: (1fr, 1fr),
  align: horizon,
  inset: 7pt,
  table.cell(fill: rgb("0000001f"), align: center)[*Positive Fragment*],
  table.cell(fill: rgb("0000001f"), align: center)[*Negative Fragment*],
  $#scheme_pos($(v_1,v_2)$)^known_(rho,sigma) =
  #code_box($#sem[$v_2$]^known_rho$, $#sem[$v_1$]^known_sigma$)$,
  $#scheme_neg($"let" x,y = z^known : A times.circle B; c$)_(rho, z |-> s_0 ++ s_1)
  = #code_box($#sem[c]^known_(rho, x |-> s_0, y |-> s_1)$)$,

  $#scheme_pos($lambda^* x. c$)^known_[] =
  &#code_block($l_1$, meta($"let" r = "next"([], #math.italic("ptr"))$), $r = s p$, $""^-#sem[c]_(x |-> r)$) \
  & #code_box($push_(s p)(l_1)$)$,
  $#scheme_neg($"call" z^known (v)$)_(rho, z |-> [r_0]) =
  #code_box($& #sem[$v$]^omega_(rho)$, $& jmp r_0$)$,

  table.cell(colspan: 2, align: center, [And a few more...]),
)

== Compilation Scheme Example
#let sch = (a, b, c) => {
  let bottom = if c == none { ([], []) } else {
    (
      align(right + horizon, block(inset: 10pt, [Compilation rule:])),
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
      inc : *((int ⊕ int) ⊗ ~int)
        = ...;
      ```
      ```asm
      main : *~int
        = \e -> inc((inl 42, e));
      ```
    ],
    [
      ```asm
      inc : *((int ⊕ int) ⊗ ~int)
        = ...;
      ```
      #block(
        stroke: blue,
        outset: 4pt,
        ```asm
        main : *~int
          = \e -> inc((inl 42, e));
        ```,
      )
    ],
    sch(
      block(
        stroke: blue,
        outset: 4pt,
        ```asm
        main : *~int
          = \e -> inc((inl 42, e));
        ```,
      ),
      none,
      none,
    ),
    sch(
      $#```asm
      main : *~int
      ``` \ space space #`= `
      #block(stroke: blue, outset: 4pt, ```asm
      \e -> inc ((inl 42, e))
      ```)$,
      none,
      $#scheme_pos($lambda^* x. c$)^known_[] =
      &#code_block($l_1$, meta($"let" r = "next"([], #math.italic("ptr"))$), $r = s p$, $""^-#sem[c]_(x |-> r)$) \
      & #code_box($push_(s p)(l_1)$)$,
    ),
    sch(
      $#```asm
      main : *~int
      ``` \ space space #`= `
      #block(stroke: blue, outset: 4pt, ```asm
      \e -> inc ((inl 42, e))
      ```)$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space ""^-#sem(```asm
        inc ((inl 42, e))
        ```)_("inc" -> ["inc"],e |-> r)\
        \ $
      ],

      $\ \ #scheme_pos($lambda^* x. c$)^known_[] =
      &#code_block($l_1$, meta($"let" r = "next"([], #math.italic("ptr"))$), $r = s p$, $""^-#sem[c]_(x |-> r)$) \
      & #code_box($push_(s p)(l_1)$)$,
    ),
    sch(
      $#```asm
      main : *~int
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #block(stroke: blue, outset: 4pt, ```asm
      inc ((inl 42, e))
      ```)$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space ""^-#sem(```asm
        inc ((inl 42, e))
        ```)_("inc" -> ["inc"], e |-> r)\
        \ $
      ],

      $\ \ #scheme_neg($"call" z^known (v)$)_(rho, z |-> [r_0]) =
      #code_box($& #sem[$v$]^omega_(rho)$, $& jmp r_0$)$,
    ),
    sch(
      $#```asm
      main : *~int
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #block(stroke: blue, outset: 4pt, ```asm
      inc ((inl 42, e))
      ```)$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space #```asm
        ``` ""^+#sem(```asm
        (inl 42, e)
        ```)^omega_(e -> r)\
        space space jmp "inc"\ $

      ],

      $\ \ #scheme_neg($"call" z^known (v)$)_(rho, z |-> [r_0]) =
      #code_box($& #sem[$v$]^omega_(rho)$, $& jmp r_0$)$,
    ),
    sch(
      $#```asm
      main : *~int
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
        (inl 42, e)
        ```,
      )
      #```asm
      )
      ```$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space #```asm
        ``` ""^+#sem(```asm
        (inl 42, e)
        ```)^omega_(e -> r)\
        space space jmp "inc"\ $

      ],

      $#scheme_pos($(v_1,v_2)$)^omega_(rho,sigma) =
      #code_box($#sem[$v_2$]^omega$, $#sem[$v_1$]^known_sigma$)$,
    ),
    sch(
      $#```asm
      main : *~int
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
        inl 42
        ```,
      )#`,`
      #block(
        stroke: blue,
        outset: 2pt,
        ```asm
        e
        ```,
      )#```asm
      ))
      ```$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space #```asm
        ``` ""^+#sem(```asm
        e
        ```)^omega_(e |-> r)\
        space space #```asm
        ``` ""^+#sem(```asm
        inl 42
        ```)^known_[]\
        space space jmp "inc"\ $

      ],

      $#scheme_pos($(v_1,v_2)$)^omega_(rho,sigma) =
      #code_box($#sem[$v_2$]^omega_rho$, $#sem[$v_1$]^known_sigma$)$,
    ),
    sch(
      $#```asm
      main : *~int
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #```asm
      inc((inl 42,
      ```
      #block(
        stroke: blue,
        outset: 2pt,
        ```asm
        e
        ```,
      )#```asm ))```$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp \
        space space space space ""^+#sem(```asm
        e
        ```)^omega_(e|->r) \
        space space #```asm
        ``` ""^+#sem(```asm
        inl 42
        ```)^known_[]\
        space space jmp "inc"\ $
      ],

      $""^+#sem[$x$]^omega_(x |-> [r_0]) = #code_box($sp = r_0$)$,
    ),
    sch(
      $#```asm
      main : *~int
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #```asm
      inc((inl 42,
      ```
      #block(
        stroke: blue,
        outset: 2pt,
        ```asm
        e
        ```,
      )#```asm ))```$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp \
        space space sp = r \
        space space #```asm
        ``` ""^+#sem(```asm
        inl 42
        ```)^known_[]\
        space space jmp "inc"\ $
      ],

      $""^+#sem[$x$]^omega_(x |-> [r_0]) = #code_box($sp = r_0$)$,
    ),
    sch(
      $#```asm
      main : *~int
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
        inl 42
        ```,
      )
      #```asm
      , e))
      ```$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space sp = r\
        space space #```asm
        ``` ""^+#sem(```asm
        inl 42
        ```)^known_[]\
        space space jmp "inc"\ $

      ],

      $#scheme_pos($"inl" v_1$)^alpha_rho =
      #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(0)$)$,
    ),
    sch(
      $#```asm
      main : *~int
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
        inl 42
        ```,
      )
      #```asm
      , e))
      ```$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space sp = r\
        space space #```asm
        ``` ""^+#sem(```asm
        42
        ```)^known_[]\
        space space space push_sp (0)\
        space space jmp "inc"\ $

      ],

      $#scheme_pos($"inl" v_1$)^alpha_rho =
      #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(0)$)$,
    ),
    sch(
      $#```asm
      main : *~int
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #```asm
      inc((inl
      ```
      #block(
        stroke: blue,
        outset: 2pt,
        ```asm
        42
        ```,
      )
      #```asm
      , e))
      ```$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space sp = r\
        space space space ""^+#sem[```asm 42```]_[]^known \
        space space space push_sp (0)\
        space space jmp "inc"\ $
      ],
      $#scheme_pos[$42$]^known_[] = #code_box[$"push"_(s p)(42)$]$,
    ),
    sch(
      $#```asm
      main : *~int
      ``` \ space space #`= `
      #```asm
      \e ->
      ```
      #```asm
      inc((inl
      ```
      #block(
        stroke: blue,
        outset: 2pt,
        ```asm
        42
        ```,
      )
      #```asm
      , e))
      ```$,
      [
        $"main": \ space space "global" "main_inner"$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space sp = r\
        space space space push_sp (42) \
        space space space push_sp (0)\
        space space jmp "inc"\ $
      ],
      none,
    ),
  ),
)

#let mathCode(i) = {
  set par(spacing: 13pt)
  let code = (
    $"main":$,
    $space space "global" "main_inner"$,
    $$,
    $"main_inner":$,
    $space space \""let" r = "next"([],p t r)\"$,
    $space space space r = sp$,
    $space space sp = r$,
    $space space space push_sp (\$42)$,
    $space space space push_sp (0)$,
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


== Application Binary Interface -- ABI
This defines how functions are called and how memory should be represented.

For function calls some requirements are needed:
#indent[
  - Register `R15` is set to an address which points to a valid stack.
  - All expected arguments exist on the stack.
  - The stack grows downwards.

  - And a few more ...
]

Some other requirements:

#indent[
  - Proper memory alignment.
  - How to interact with the stack.

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
  top[System-Stack], top[Stack],
  drawStack(
    ..([`%RBP` $->$], [$v_1$], [`0x30`]),
    ..([], [$v_2$], [`0x20`]),
    ..([`%RSP` $->$], [$v_3$], [`0x10`]),
  ),
  drawStack(
    ..([], [$a_2$], [`0xF0`]),
    ..([], [$a_1$], [`0xE0`]),
    ..([`%R15` $->$], [$t_1$], [`0xD0`]),
  ),

  [Used for "infinite" registers.],
  [
    Used for argument passing, capturing, and calculations.
  ],
)
Works very similarly to the setups in stack machines, such as the JVM
or a WASM interpreter!

In most other languages the system-stack would contain multiple stack frames,
but due to tail-call optimizations we only ever use one!

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
      main:
      ```,
    ),
    sch(
      1,
      ```asm
      main: .quad main_inner
      ```,
    ),
    sch(
      -1,
      ```asm
      main: .quad main_inner
      inc:  .quad inc_inner
      ```,
    ),
    sch(
      3,
      ```asm
      main: .quad main_inner
      inc:  .quad inc_inner

      main_inner:
      ```,
    ),
    sch(
      4,
      ```asm
      main: .quad main_inner
      inc:  .quad inc_inner

      main_inner:
        # r = -8(%RBP)
      ```,
    ),
    sch(
      5,
      ```asm
      main: .quad main_inner
      inc:  .quad inc_inner

      main_inner:
        # r = -8(%RBP)
        movq %R15, -8(%RBP)
      ```,
    ),
    sch(
      6,
      ```asm
      main: .quad main_inner
      inc:  .quad inc_inner

      main_inner:
        # r = -8(%RBP)
        movq %R15, -8(%RBP)

        movq -8(%RBP), %R15
      ```,
    ),
    sch(
      7,
      ```asm
      main: .quad main_inner
      inc:  .quad inc_inner

      main_inner:
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
      main: .quad main_inner
      inc:  .quad inc_inner

      main_inner:
        # r = -8(%RBP)
        movq %R15, -8(%RBP)

        movq -8(%RBP), %R15

        subq $8, %R15
        movq $42, 0(%R15)

        subq $8, %R15
        movq $0, 0(%R15)
      ```,
    ),
    sch(
      9,
      ```asm
      main: .quad main_inner
      inc:  .quad inc_inner

      main_inner:
        # r = -8(%RBP)
        movq %R15, -8(%RBP)

        movq -8(%RBP), %R15

        subq $8, %R15
        movq $42, 0(%R15)

        subq $8, %R15
        movq $0, 0(%R15)

        movq inc(%RIP), %RAX
        jmp *%RAX
      ```,
    ),
  ),
)

