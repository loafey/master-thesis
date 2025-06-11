#import "Prelude.typ": *

#let grammar(named, ..rules) = {
  let arr = rules.pos()
  linebreak()
  named
  $space := space$
  [#arr.join(" | ")]
}
#let values = grammar(
  $v,v'$,
  $x$,
  $()$,
  "newstack",
  $lambda x. space c$,
  $#math.italic("inl") v$,
  $#math.italic("inr") v$,
  $square v$,
  $(v, v')$,
  $(@t, v)$,
)
#let commands = grammar(
  [$c, c'$],
  $z(v)$,
  $"case" v "of" { "inl" x -> c; "inr" y -> c'}$,
  $"let" p = v; c$,
)
#let pat = grammar($p$, $()$, $x$, $@t, y$, $p, p'$, $square p$)
#let type = grammar(
  $A, B$,
  $fatzero$,
  $fatone$,
  $circle$,
  $alpha$,
  $not A$,
  $* A$,
  $~ A$,
  $square A$,
  $A times.circle B$,
  $A plus.circle B$,
  $exists alpha. A$,
)
#let def = grammar($d$, $x : t = v$)
#let module = grammar($m$, $epsilon$, $d ; m$)

#let dbl_linkbreak() = {
  linebreak()
  linebreak()
}

#let complete_grammar = box(inset: 7pt, stroke: black + 0.1pt, [
  _Value_
  #values
  #dbl_linkbreak()
  _Command_
  #commands
  #dbl_linkbreak()
  _Pattern_
  #pat
  #dbl_linkbreak()
  _Type_
  #type
  #dbl_linkbreak()
  _Definition_
  #def
  #dbl_linkbreak()
  _Module_
  #module
])

#let pair_value = judge(
  $Gamma tack t: A quad Delta tack u: B$,
  $Gamma, Delta tack (t,u): A times.circle B$,
  note: "pair",
)

#let linear_closure_value = judge(
  $(Gamma , x: A) : known tack c$,
  $Gamma tack lambda^not x. c : not A$,
  note: "linear closure",
)

#let static_function_value = judge(
  $dot, x: A tack c$,
  $dot tack lambda^* x. c : *A$,
  note: "static function",
)
#let stack_closure_value = judge(
  $(Gamma , x: A) : omega tack c$,
  $Gamma tack lambda^~x. c: ~A$,
  note: "stack closure",
)
#let linear_pointer_value = judge(
  $Gamma tack t: A$,
  $Gamma tack square t: square A$,
  note: "linear pointer",
)
#let var_value = judge($$, $dot, x : A tack x: A$, note: "var")
#let newstack_value = judge($$, $tack "newstack": circle$, note: "newstack")
#let inj_left_value = judge(
  $Gamma tack t: A$,
  $Gamma tack "inl" t: A plus.circle B$,
  note: "inj left",
)
#let inj_right_value = judge(
  $Gamma tack t: B$,
  $Gamma tack "inr" t: A plus.circle B$,
  note: "inj right",
)
#let exists_intro_value = judge(
  $Gamma, alpha tack t: A$,
  $Gamma tack angled(A, t): exists alpha. A$,
  note: $exists #math.italic[intro]$,
)
#let unit_value = judge("", $dot tack () : fatone$, note: "unit")

#let positive(toggle) = {
  grid(
    align: left,
    columns: (1fr, 1fr),
    row-gutter: 16pt,
    pair_value, linear_closure_value,
    static_function_value, stack_closure_value,
    linear_pointer_value, var_value,
    newstack_value, inj_left_value,
    inj_right_value, exists_intro_value,
    unit_value,
  )
}

#let stack_call_command = judge(
  $Gamma tack t: A$,
  $Gamma, z: ~A tack "call"^~ z(t)$,
  note: $#math.italic[call]^~$,
)

#let static_call_command = judge(
  $Gamma tack t: A$,
  $Gamma, z: *A tack "call"^* z(t)$,
  note: $#math.italic[call]^*$,
)

#let linear_call_command = judge(
  $Gamma tack t: A$,
  $Gamma, z: not A tack "call"^not z(t)$,
  note: $#math.italic[call]^not$,
)

#let freestack_command = judge(
  $Gamma tack c$,
  $Gamma, z: circle tack "freestack" z; c$,
  note: "freestack",
)

#let pair_command = judge(
  $Gamma, a: A, b: B tack c$,
  $Gamma, z: A times.circle B tack "let" a,b = z; c$,
  note: "pair",
)
#let exists_elim_command = judge(
  $Gamma, alpha, x: A tack c$,
  $Gamma, z: exists alpha. A tack "let" angled(alpha, x) = z; c$,
  note: $exists #math.italic[elim]$,
)
#let follow_command = judge(
  $Gamma, x: A tack c$,
  $Gamma, z: square A tack "let" square x = z; c$,
  note: "follow",
)

#let discard_command = judge(
  $Gamma tack c$,
  $Gamma, z: fatone tack "let" () = z; c$,
  note: "discard",
)

#let case_command = judge(
  $Gamma, x_i: A_i tack c_i$,
  $Gamma, z: A_1 plus.circle A_2 tack "case" z "of" "inj"_i x_i |-> c_i$,
  note: "case",
)

#let negative(toggle) = {
  grid(
    align: left,
    columns: (1fr, 1fr),
    row-gutter: 16pt,
    stack_call_command, static_call_command,
    linear_call_command, freestack_command,
    pair_command, exists_elim_command,
    follow_command, discard_command,
    case_command,
  )
}

#let type_judgements(show_note) = {
  positive(show_note)
  linebreak()
  negative(show_note)
}

#let product_dynamic = {
  judge($A: known quad B: omega$, $A times.circle B: omega$)
}

#let product_constant = {
  judge($A: known quad B:known$, $A times.circle B: known$)
}

#let sum_dynamic = {
  judge($A: omega quad B: omega$, $A plus.circle B: omega$)
}

#let sum_constant = {
  judge($A:known quad B: known$, $A plus.circle B: known$)
}

#let static_closure = {
  judge($A: omega$, $*A: known$)
}
#let linear_closure = {
  judge($A:known$, $not A: known$)
}

#let dynamic_closure = {
  judge($A: known$, $~A: omega$)
}

#let linear_ptr = {
  judge($A: omega$, $square A: known$)
}

#let emptystack = {
  judge($$, $circle: omega$)
}

#let unit = {
  judge($$, $fatone: known$)
}

#let existential_constant = {
  judge($A : known$, $exists alpha. A : known$)
}
#let existential_dynamic = {
  judge($A : omega$, $exists alpha. A : omega$)
}

#let type_variable = {
  judge($$, $alpha : omega$)
}

#let empty_known = { judge($$, $#math.bold[0] : known$) }

#let empty_omega = { judge($$, $#math.bold[0] : omega$) }

#let kind_judgements = {
  grid(
    columns: (1fr, 1fr, 1fr),
    row-gutter: 16pt,
    existential_constant, existential_dynamic, emptystack,
    product_dynamic, product_constant, linear_ptr,
    static_closure, dynamic_closure, linear_closure,
    type_variable,
  )
}
