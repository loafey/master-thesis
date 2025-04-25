#import "../Prelude.typ": *

#let grammar(section, named, ..rules) = {
  let arr = rules.pos()
  section
  linebreak()
  named
  $space := space$
  [#arr.join(" | ")]
}
#let values = grammar(
  [_Values_],
  $v,v'$,
  $x$,
  $()$,
  "newstack",
  $lambda p. space c$,
  $#math.italic("inl") v$,
  $#math.italic("inr") v$,
  $square v$,
  $(v, v')$,
  $(@t, v)$,
)
#let commands = grammar(
  [_Commands_],
  [$c, c'$],
  $z(v)$,
  $"case" v "of" { "inl" x -> c; "inr" y -> c'}$,
  $"let" p = v; c$,
)
#let pat = grammar(
  [_Patterns_],
  $p$,
  $()$,
  $p, p'$,
  $@t, y$,
  $p, p'$,
  $square p$,
)
#let type = grammar(
  [_Types_],
  $t, t'$,
  $top$,
  $bot$,
  $circle$,
  $x$,
  $not t$,
  $* t$,
  $~ t$,
  $square t$,
  $t times.circle t'$,
  $t plus.circle t'$,
  $exists x. t$,
)
#let def = grammar([_Definition_], $d$, $x : t = v$)
#let module = grammar([_Module_], $m$, $epsilon$, $d ; m$)

#let dbl_linkbreak() = {
  linebreak()
  linebreak()
}

#let complete_grammar = box(
  inset: 7pt,
  stroke: black,
  [
    #values
    #dbl_linkbreak()
    #commands
    #dbl_linkbreak()
    #pat
    #dbl_linkbreak()
    #type
    #dbl_linkbreak()
    #def
    #dbl_linkbreak()
    #module
  ],
)

#let positive = block(breakable: false, {
  [*Positive fragment*]
  grid(
    columns: (1fr, 1fr),
    row-gutter: 16pt,
    [
      #judge(
        $Gamma tack t: A quad Delta tack u: B$,
        $Gamma, Delta tack (t,u): A times.circle B$,
      )],
    [#judge(
        $dot, x: A tack c$,
        $dot tack lambda x. c : not A$,
      )
    ],

    [#judge(
        $dot, x: A tack c$,
        $dot tack lambda x. c : *A$,
      )
    ],
    [#judge(
        $dot, x: A tack c$,
        $Gamma tack lambda^~x. c: ~A$,
      )],

    [#judge(
        $Gamma tack t: A$,
        $Gamma tack square t: square A$,
      )
    ],
    [#judge(
        $Gamma tack x: A$,
        $Gamma tack x: A$,
      )
    ],

    [
      #judge($$, $tack "newstack": circle$)
    ],
    [
      #judge(
        $Gamma tack t: A$,
        $Gamma tack "inl" t: A plus.circle B$,
      )
    ],

    [
      #judge(
        $Gamma tack t: B$,
        $Gamma tack "inr" t: A plus.circle B$,
      )
    ],
    [
      #judge(
        $Gamma, alpha tack t: A$,
        $Gamma tack angled(A, t): exists alpha. A$,
      )
    ],

    [
      #judge("", $dot tack () : top$)
    ],
  )
})

#let negative = block(breakable: false, {
  [*Negative fragment*]
  grid(
    columns: (1fr, 1fr),
    row-gutter: 16pt,
    [
      #judge(
        $Gamma tack t: A$,
        $Gamma, z: ~A tack "call"^~ z(t)$,
      )
    ],
    [
      #judge(
        $Gamma tack t: A$,
        $Gamma, z: *A tack "call"^* z(t)$,
      )
    ],

    [
      #judge(
        $Gamma tack c$,
        $Gamma, z: circle tack "freestack" z; c$,
      )
    ],
    [
      #judge(
        $Gamma, a: A, b: B tack c$,
        $Gamma, z: A times.circle B tack "let" a,b = z; c$,
      )
    ],

    [
      #judge(
        $Gamma, alpha, x: A tack c$,
        $Gamma, z: exists alpha. A tack "let" angled(alpha, x) = z; c$,
      )
    ],
    [
      #judge(
        $Gamma, x: A tack c$,
        $Gamma, z: square A tack "let" square x = z; c$,
      )
    ],

    [
      #judge(
        $Gamma tack c$,
        $Gamma, z: top tack "let" () = z; c$,
      )
    ],
    [
      #judge(
        $Gamma, x: A_i tack c_i$,
        $Gamma, z: A_1 plus.circle A_2 tack "case" z "of" "inj"_i x_i |-> c_i$,
      )
    ],
  )
})

#let type_judgements = {
  positive 
  linebreak()
  negative
}

#let product_dynamic = {
  judge(
    $A: n quad B: omega$,
    $A times.circle B: omega$,
  )
}

#let product_constant = {
  judge(
    $A: n quad B:m$,
    $A times.circle B: n + m$,
  )
}

#let sum_dynamic = {
  judge(
    $A: omega quad B: omega$,
    $A plus.circle B: omega$,
  )
}

#let sum_constant = {
  judge(
    $A:n quad B: m$,
    $A plus.circle B: max(n, m)$,
  )
}
#let static_closure = {
  judge(
    $A: omega$,
    $*A: n$,
  )
}
#let linear_closure = {
  judge(
    $A:n$,
    $not A: n$,
  )
}

#let dynamic_closure = {
  judge(
    $A: n$,
    $~A: omega$,
  )
}

#let linear_ptr = {
  judge(
    $A: omega$,
    $square A: n$,
  )
}

#let emptystack = {
  judge(
    $$,
    $circle: omega$,
  )
}

#let kind_judgements = grid(
  columns: (1fr, 1fr, 1fr),
  row-gutter: 16pt,
  product_dynamic, sum_dynamic, static_closure,
  product_constant, sum_constant, dynamic_closure,
  emptystack, linear_ptr, linear_closure,
)

#let positive_compilation_scheme = {
  $#compilation_scheme($(v_1,v_2)$)^omega_(rho,sigma) =
  #code_box($#sem[$v_2$]^omega_rho$, $#sem[$v_1$]^n_sigma$)$

  linebreak()

  $#compilation_scheme($(v_1,v_2)$)^n_(rho,sigma) =
  #code_box($#sem[$v_2$]^n_rho$, $#sem[$v_1$]^n_sigma$)$

  linebreak()

  $#compilation_scheme($(@t, v_1)$)^alpha_rho = #code_box($#sem[$v_1$]^alpha_rho$)$

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

  $#compilation_scheme($"inl" v_1$)^alpha_rho =
  #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(0)$)$

  linebreak()

  $#compilation_scheme($"inr" v_1$)^alpha_rho =
  #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(1)$)$

  linebreak()

  $#compilation_scheme($x$)^omega_(x |-> {r_0}) =
  #code_box($&s p = r_0$)$

  linebreak()

  $#compilation_scheme($x$)^n_(x |-> r_0) =
  #code_box($push_(s p)(r_0)$)$

  linebreak()

  $#compilation_scheme($()$)^n_{} = #code_box("")$

  linebreak()

  $#compilation_scheme($lambda x. c$)^1_{} =
  &#code_block(
    $l_1$,
    meta($"let" r_1 = "next"({}, #math.italic("ptr"))$),
    $r_1 = s p$,
    $#sem[c]_(x |-> {r_1})$,
  ) \ & #code_box($push_(s p)(l_1)$)$

  linebreak()

  $#compilation_scheme(newstack)^omega_{} =
  #code_box($r_1 <- newstack$, $s p = r_1$)$
}
#let negative_compilation_scheme = {
  $#compilation_scheme($"let" x,y = z^omega : A times.circle B; c$)_(rho, z |-> {r_0})
  = #code_box(
    meta($"let" r_1 = "next"(rho, A)$),
    $pop(r_1)$,
    $#sem[c]^omega_(rho, x |-> r_1, y |-> {r_0})$,
  )$

  linebreak()

  $#compilation_scheme($"let" x,y = z^n : A times.circle B; c$)_(rho, z |-> {r_0, r_1})
  = #code_box($#sem[c]^n_(rho, x |-> {r_0}, y |-> {r_1})$)$

  linebreak()

  $#compilation_scheme($"let" () = z^n; c$)_(rho,z |-> {})
  = #code_box($#sem[c]_rho$)$

  linebreak()

  $#compilation_scheme($"let" @t, x = z^alpha; c$)_(rho, z |-> r_0)
  = #code_box($#sem[c]_(rho, x |-> r_0)$)$

  linebreak()

  $#compilation_scheme($"let" square x = z^1; c$)_(rho, z |-> {r_0})
  = #code_box($#sem[c]_(rho, x |-> {r_0})$)$

  linebreak()

  $#compilation_scheme($"let" \_ = "freestack" z^omega; c$)_(rho, z |-> {r_0})
  = #code_box($"free"(r_0)$, $#sem[c]_rho$)$

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

  $#compilation_scheme($"case" z^n "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> r_1: r_s)
  = #code_box($"if iszero"(r_1) "then" #sem[$c_1$]_(rho, x |-> r_s) "else" #sem[$c_2$]_(rho, y |-> r_s)$)$

  linebreak()

  $#compilation_scheme($"call" z^n (v)$)_(rho, z |-> {r_0}) =
  #code_box($&#sem[$v$]^omega_(rho)$, $&jmp r_0$)$
}
