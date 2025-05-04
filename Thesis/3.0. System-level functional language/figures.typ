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

#let positive(toggle) = {
  grid(
    align: left,
    columns: (1fr, 1fr),
    row-gutter: 16pt,
    [
      #judge(
        $Gamma tack t: A quad Delta tack u: B$,
        $Gamma, Delta tack (t,u): A times.circle B$,
        display_note: toggle,
        note: "pair",
      )],
    [#judge(
        $dot, x: A tack c$,
        $dot tack lambda x. c : not A$,
        display_note: toggle,
        note: "linear closure",
      )
    ],

    [#judge(
        $dot, x: A tack c$,
        $dot tack lambda x. c : *A$,
        display_note: toggle,
        note: "static closure",
      )
    ],
    [#judge(
        $dot, x: A tack c$,
        $dot tack lambda^~x. c: ~A$,
        display_note: toggle,
        note: "stack closure",
      )],

    [#judge(
        $Gamma tack t: A$,
        $Gamma tack square t: square A$,
        display_note: toggle,
        note: "linear pointer",
      )
    ],
    [#judge(
        $x: A in Gamma$,
        $Gamma tack x: A$,
        display_note: toggle,
        note: "var",
      )
    ],

    [
      #judge(
        $$,
        $tack "newstack": circle$,
        display_note: toggle,
        note: "newstack",
      )
    ],
    [
      #judge(
        $Gamma tack t: A$,
        $Gamma tack "inl" t: A plus.circle B$,
        display_note: toggle,
        note: "inj",
      )
    ],

    [
      #judge(
        $Gamma tack t: B$,
        $Gamma tack "inr" t: A plus.circle B$,
        display_note: toggle,
        note: "inj",
      )
    ],
    [
      #judge(
        $Gamma, alpha tack t: A$,
        $Gamma tack angled(A, t): exists alpha. A$,
        display_note: toggle,
        note: $exists #math.italic[intro]$,
      )
    ],

    [
      #judge(
        "",
        $dot tack () : top$,
        display_note: toggle,
        note: "unit",
      )
    ],
  )
}

#let negative(toggle) = {
  grid(
    align: left,
    columns: (1fr, 1fr),
    row-gutter: 16pt,
    [
      #judge(
        $Gamma tack t: A$,
        $Gamma, z: ~A tack "call"^~ z(t)$,
        note: $#math.italic[call]^~$,
        display_note: toggle,
      )
    ],
    [
      #judge(
        $Gamma tack t: A$,
        $Gamma, z: *A tack "call"^* z(t)$,
        note: $#math.italic[call]^*$,
        display_note: toggle,
      )
    ],

    [
      #judge(
        $Gamma tack t: A$,
        $Gamma, z: not A tack "call"^not z(t)$,
        note: $#math.italic[call]^not$,
        display_note: toggle,
      )
    ],
    [
      #judge(
        $Gamma tack c$,
        $Gamma, z: circle tack "freestack" z; c$,
        note: "freestack",
        display_note: toggle,
      )
    ],

    [
      #judge(
        $Gamma, a: A, b: B tack c$,
        $Gamma, z: A times.circle B tack "let" a,b = z; c$,
        note: "pair",
        display_note: toggle,
      )
    ],
    [
      #judge(
        $Gamma, alpha, x: A tack c$,
        $Gamma, z: exists alpha. A tack "let" angled(alpha, x) = z; c$,
        note: $exists #math.italic[elim]$,
        display_note: toggle,
      )
    ],

    [
      #judge(
        $Gamma, x: A tack c$,
        $Gamma, z: square A tack "let" square x = z; c$,
        note: "follow",
        display_note: toggle,
      )
    ],
    [
      #judge(
        $Gamma tack c$,
        $Gamma, z: top tack "let" () = z; c$,
        note: "discard",
        display_note: toggle,
      )
    ],

    [
      #judge(
        $Gamma, x: A_i tack c_i$,
        $Gamma, z: A_1 plus.circle A_2 tack "case" z "of" "inj"_i x_i |-> c_i$,
        note: "case",
        display_note: toggle,
      )
    ],
  )
}

#let type_judgements(show_note) = {
  positive(show_note)
  linebreak()
  negative(show_note)
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
