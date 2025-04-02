#import "Prelude.typ": *
= Theory

- SLFL consists of two fragments; positive and negative. The positive fragment
  consists of ways to create terms, while the negative fragment consists of ways
  to destruct terms.

- Two kinds, known size ($n,m$) and stack size $omega$.
- Continuation-passing style.
  - Order of evaluation specified

=== Term-level judgements

#let positive = {
  [=== Positive fragment]
  grid(
    columns: (1fr, 1fr),
    row-gutter: 16pt,
    [
      #judge(
        $Gamma tack t: A quad Delta tack u: B$,
        $Gamma, Delta tack (t,u): A times.circle B$,
      )],
    [#judge(
        $Gamma, x: A tack c$,
        $Gamma tack lambda x. c : not A$,
      )
    ],

    [#judge(
        $Gamma, x: A tack c$,
        $Gamma tack lambda x. c : *A$,
      )
    ],
    [#judge(
        $Gamma, x: A tack c$,
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
        $Gamma tack x: A$,
        $Gamma tack x: A$,
      )
    ],
  )
}

#let negative = {
  [=== Negative fragment]
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
  )
}

#grid(
  columns: (1fr, 1fr),
  row-gutter: 16pt,
  positive, negative,
)

=== Type-level judgements

#grid(
  columns: (1fr, 1fr, 1fr),
  row-gutter: 16pt,
  [
    #judge(
      $A: n quad B:n$,
      $A times.circle B: n$,
    )
  ],
  [
    #judge(
      $A: n quad B: omega$,
      $A times.circle B: omega$,
    )
  ],
  [
    #judge(
      $A:n quad B: n$,
      $A plus.circle B: n$,
    )
  ],

  [
    #judge(
      $A: omega quad B: omega$,
      $A plus.circle B: omega$,
    )
  ],
  [
    #judge(
      $A: omega$,
      $*A: 1$,
    )
  ],
  [
    #judge(
      $A: n$,
      $~A: omega$,
    )
  ],

  [
    #judge(
      $A:n$,
      $not A: 1$,
    )
  ],
  [
    #judge(
      $A: omega$,
      $square A: 1$,
    )
  ],
  [
    #judge(
      $$,
      $circle: omega$,
    )
  ],
)

== Transformations

- Source language $->$ Linear closure conversion $->$ Stack selection $->$ Pointer closure conversion

We will consider the following program to explain each step: $lambda a. "let" f,k = a; k(lambda y. space f(y))$
with type $not (not int times.circle not not int)$. We use $int$ to avoid considering existential types for now.

=== Linear closure converison

$(lambda^not x. c): not A => square (lambda^~ x. c): square (~A)$

$not$ is a source language construct only

After linear closure conversion we end up with:
$
  square lambda a. & "let" f,k = a; \
  &"let" square k' = k; \
  & k'(square lambda y. "let" square f' = f; f'(y))
$

And the type is now: $square ~(square ~ int times.circle square~square~int)$

//The astute reader will now realize that $not$ is a source language construct only. There is no compilation scheme that corresponds to it.


=== Stack Selection

In the final closure conversion step we make environments explicit and make
sure that each closure contains a stack to execute on. However, because of how
the linear closure conversion step works closures will never contain a stack.
Since all closures are boxed there are no stacks, remember #judge($A:omega$, $square A: 1$).
This can be observed in the example where we see that $f$ is unboxed inside the
closure. The solution is to move the unboxing of $f$ outside the inner closure:
$
  square lambda a. & "let" f,k = a; \
  &"let" square k' = k; \
  &"let" square f' = f; \
  & k'(square lambda y. f'(y))
$

Now the inner closure contains a stack.

//We need to make sure each term consists of zero or one stack for the pointer
//closure conversion step. If it contains zero stacks, then the environment of
//the closure will create one using the _newstack_ primitive.

=== Pointer Closure Conversion

The goal of this phase is to make the structure of stacks explicit, replacing
a stack closure by an explicit pair of static function pointer and environment.

== Compilation Scheme

$rho : Gamma -> "List"("Reg")$ \
$rho$ is a mapping from variables to a list of memory addresses.

$#sem($dot$)^A_rho$ reads as; the semantics of $dot$ in context $rho$, with kind $A$

=== Positive fragment

$#compilation_scheme($omega$,$(v_1,v_2)$)_rho =
  #code_box[$
    & r_2 <- #sem[$v_2$]^omega_rho \
    & r_1 <- #sem[$v_1$]^n_rho \
    & "push"(r_1)
    $
  ]$

$#compilation_scheme($n$,$(v_1,v_2)$) =
  #code_box[$
      r_2 <- #sem[$v_2$]^n_rho \
      r_1 <- #sem[$v_1$]^n_rho$]$

$#compilation_scheme("",$(@t, v_1)$)_rho = #code_box($#sem[$v_1$]_rho$)$

$#compilation_scheme($1$,$square v_1$)_rho = #code_box($#sem[$v_1$]^omega_rho$)$ // FIXME: should this be omega?

$#compilation_scheme($n$,$"inl" v_1$)_rho =
  #code_box($r_2 <- #sem[$v_1$]_rho$,
            $r_1 <- 0$
          )$

$#compilation_scheme($omega$,$"inl" v_1$)_rho =
  #code_box($& r_1 <- #sem[$v_1$]^omega_rho$,
            $&"push"(0)$
          )$

$#compilation_scheme($n$,$"inr" v_1$)_rho =
  #code_box($& r_2 <- #sem[$v_1$]^n_rho$,
            $&r_1 <- 1 $
          )$

$#compilation_scheme($omega$,$"inr" v_1$)_rho =
  #code_box($&r_0 <- #sem[$v_1$]^omega_rho$,
            $&"push"(1)$
          )$

$#compilation_scheme($omega$,$x$)_(rho, x |-> {r_0}) =
  #code_box($&r_0$)$

$#compilation_scheme($n$,$x$)_(rho, x |-> {r_0}) =
  #code_box($&r_0$)$

$#compilation_scheme($n$,$()$)_rho =
  #code_box($&"let" r_0 = "next"(rho,int)$,
            $&r_0 <- 0$
          )$

$#compilation_scheme($omega$,$lambda x. c$)_rho =
  #code_box($#sem[c]^omega_(rho, x |-> r_arg)$)$

$#compilation_scheme($omega$,math.italic("newstack"))_rho =
  #code_box($r_1 <- #math.italic("newstack")$, $"push" r_1$)$

=== Negative fragment

$#compilation_scheme($omega$,$"let" x,y = z : A times.circle B; c$)_(rho, z |-> {r_0})
    = #code_box($
        "let" r_1 = "next"(rho, A)$,
        $"pop"(r_1)$,
        $#sem[c]^omega_(rho, x |-> {r_1}, y |-> {r_0})$,
        )$

$#compilation_scheme($n$,$"let" x,y = z : A times.circle B; c$)_(rho, z |-> {r_0, r_1})
    = #code_box($#sem[c]^n_(rho, x |-> {r_0}, y |-> {r_1})$)$

$#compilation_scheme($n$,$"let" () = z; c$)_(rho,z |-> {r_0})
  = #code_box($#sem[c]_rho$)$

$#compilation_scheme("",$"let" @t, x = z; c$)_(rho, z |-> {r_0})
  = #code_box($#sem[c]_(rho, x |-> {r_0})$)$

$#compilation_scheme($n$,$"let" square x = z; c$)_(rho, z |-> {r_0})
  = #todo("Implement")$ //#code_box[$#sem[c]_(rho, x |-> {r_0})$]$

$#compilation_scheme("",$"let" \_ = "FreeStack" z; c$)_(rho, z |-> {r_0})
  = #code_box($"libc::free"(r_0)$, $#sem[c]_rho$)$

$#compilation_scheme($omega$,$"case" z "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> {r_0})
  = #code_box($& "let" r_1 = "next"(rho, "int")$,
              $& "pop"(r_1)$,
              $& "if" "iszero"(r_1) "then" #sem[$c_1$]_(rho, x |-> {r_0}) "else" #sem[$c_2$]_(rho, y |-> {r_0})$
            )$

$#compilation_scheme($n$,$"case" z "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> {r_0, r_1})
  = #code_box($"if" "iszero"(r_0) "then" #sem[$c_1$]_(rho, x |-> {r_1}) "else" #sem[$c_2$]_(rho, y |-> {r_2})$)$

$#compilation_scheme($omega$,$"call" z(x)$)_(rho, z |-> {r_0}) =
  #code_box($&r_arg <- #sem[$x$]^omega_(rho)$, $&"jmp" r_0$)$
