#import "../Prelude.typ": *

= Compilation
== Compilation
Lithium uses a compilation scheme, based on the negative/positive fragments in the language.

These compilation schemes compile the language into a pseudo assembly language.

This assembly language is then easily translated into x86-64
== Compilation scheme
#bigTodo[lägg till saker här]

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
    ..bottom
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
      #```asm
      \e ->
      ```
      #block(stroke: blue, outset: 4pt, ```asm
      inc ((inl 42, e))
      ```)$,
      [
        $"main": \ space space push_sp ("main_inner")$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space ""^-#sem(```asm
        inc ((inl 42, e))
        ```)_(x |-> r)\
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
        $"main": \ space space push_sp ("main_inner")$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space ""^-#sem(```asm
        inc ((inl 42, e))
        ```)_(x |-> r)\
        \ $
      ],

      $\ \ #scheme_neg($"call" z^known (v)$)_(rho, z |-> [r_0]) =
      #code_box($&#sem[$v$]^omega_(rho)$, $&jmp r_0$)$,
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
        $"main": \ space space push_sp ("main_inner")$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space #```asm
        ``` #sem(```asm
        (inl 42, e)
        ```)_(z |-> [r_0])\
        space space jmp r_0\ $

      ],

      $\ \ #scheme_neg($"call" z^known (v)$)_(rho, z |-> [r_0]) =
      #code_box($&#sem[$v$]^omega_(rho)$, $&jmp r_0$)$,
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
      )#```asm
      )
      ```$,
      [
        $"main": \ space space push_sp ("main_inner")$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space #```asm
        ``` #sem(```asm
        (inl 42, e)
        ```)_(z |-> [r_0])\
        space space jmp r_0\ $

      ],

      $#scheme_pos($(v_1,v_2)$)^known_(rho,sigma) =
      #code_box($#sem[$v_2$]^known_rho$, $#sem[$v_1$]^known_sigma$)$,
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
        $"main": \ space space push_sp ("main_inner")$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space #```asm
        ``` #sem(```asm
        e
        ```)_(e |-> r)\
        space space #```asm
        ``` #sem(```asm
        inl 42
        ```)_sigma\
        space space jmp r_0\ $

      ],

      $#scheme_pos($(v_1,v_2)$)^known_(rho,sigma) =
      #code_box($#sem[$v_2$]^known_rho$, $#sem[$v_1$]^known_sigma$)$,
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
        $"main": \ space space push_sp ("main_inner")$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space sp = r\
        space space #```asm
        ``` #sem(```asm
        inl 42
        ```)_sigma\
        space space jmp r_0\ $
      ],

      none,
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
        $"main": \ space space push_sp ("main_inner")$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space sp = r\
        space space #```asm
        ``` #sem(```asm
        inl 42
        ```)_sigma\
        space space jmp r_0\ $

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
        $"main": \ space space push_sp ("main_inner")$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space sp = r\
        space space #```asm
        ``` #sem(```asm
        42
        ```)_sigma\
        space space space push_sp (\$0)\
        space space jmp r_0\ $

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
      inc((inl 42, e))
      ```$,
      [
        $"main": \ space space push_sp ("main_inner")$
        #linebreak()
        #linebreak()
        $"main_inner": \
        space space \""let" r = "next"([],p t r)\"\
        space space space r = sp\
        space space sp = r\
        space space space push_sp (\$42) \
        space space space push_sp (\$0)\
        space space jmp r_0\ $
      ],
      none,
    ),
  ),
)

#let mathCode(i) = {
  set par(spacing: 13pt)
  let code = (
    $"main":$,
    $space space push_sp ("main_inner")$,
    $$,
    $"main_inner":$,
    $space space \""let" r = "next"([],p t r)\"$,
    $space space space r = sp$,
    $space space sp = r$,
    $space space space push_sp (\$42)$,
    $space space space push_sp (0)$,
    $space space jmp r_0$,
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
      main:
      ```,
    ),
    sch(
      1,
      ```asm
      main:
        .quad main_inner
      ```,
    ),
    sch(
      3,
      ```asm
      main:
        .quad main_inner

      main_inner:
      ```,
    ),
    sch(
      4,
      ```asm
      main:
        .quad main_inner

      main_inner:
      ```,
    ),
    sch(
      5,
      ```asm
      main:
        .quad main_inner

      main_inner:
        movq %RSP, -8(%RBP)
      ```,
    ),
    sch(
      6,
      ```asm
      main:
        .quad main_inner

      main_inner:
        movq %RSP, -8(%RBP)
        movq -8(%RBP), %RSP
      ```,
    ),
    sch(
      7,
      ```asm
      main:
        .quad main_inner

      main_inner:
        movq %RSP, -8(%RBP)
        movq -8(%RBP), %RSP
        subq 8, %RSP
        movq $42, 0(%RSP)
      ```,
    ),
    sch(
      8,
      ```asm
      main:
        .quad main_inner

      main_inner:
        movq %RSP, -8(%RBP)
        movq -8(%RBP), %RSP
        subq 8, %RSP
        movq $42, 0(%RSP)
        subq 8, %RSP
        movq $0, 0(%RSP)
      ```,
    ),
    sch(
      9,
      ```asm
      main:
        .quad main_inner

      main_inner:
        movq %RSP, -8(%RBP)
        movq -8(%RBP), %RSP
        subq 8, %RSP
        movq $42, 0(%RSP)
        subq 8, %RSP
        movq $0, 0(%RSP)
        movq inc(%RIP), %RAX
        jmp *%RAX
      ```,
    ),
  ),
)
