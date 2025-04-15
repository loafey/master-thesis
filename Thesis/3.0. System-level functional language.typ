#import "Prelude.typ": *

= System-level Functional Language

SLFL consists of two fragments; positive and negative. The positive fragment describes how terms are created, while the negative fragment describes how terms are consumed.
Two kinds, known size ($n,m$) and stack size $omega$.
Continuation-passing style.

=== Term-level judgements

#let positive = {
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

=== Transformations

SLFL consists of three intermediate languages.

- Source language $->$ Linear closure conversion $->$ Stack selection $->$ Pointer closure conversion

We will consider the following program to explain each step: $lambda a. "let" f,k = a; k(lambda y. space f(y))$
with type $not (not int times.circle not not int)$. We use $int$ to avoid considering existential types for now.

==== Linear closure converison

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


==== Stack Selection

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

==== Pointer Closure Conversion

The goal of this phase is to make the structure of stacks explicit, replacing
a stack closure by an explicit pair of static function pointer and environment.

=== Compilation Scheme

$rho : Gamma -> "List"("Reg")$ \
$rho$ is a mapping from variables to a list of memory addresses.

The reason the range of $rho$ is a list of memory addresses is because some values
require more space than one memory address can fit.

$#sem($t$)^alpha_rho = #code_box($c$)$ reads as follows: The compilation scheme
for $t$ with kind $alpha$ and variable environment $rho$ is $c$. We use $alpha$
to represent either $n$ or $omega$.

The scheme uses a mix of meta syntax, i.e, instructions that does not generate
any code, and instructions that generate code. We differentiate meta syntax
with instructions using double quotes.

$"newstack"$

==== Positive fragment

$#compilation_scheme($(v_1,v_2)$)^omega_(rho,sigma) =
  #code_box($#sem[$v_2$]^omega_rho$, $#sem[$v_1$]^n_sigma$)$

$#compilation_scheme($(v_1,v_2)$)^n_(rho,sigma) =
  #code_box($#sem[$v_2$]^n_rho$, $#sem[$v_1$]^n_sigma$)$

$#compilation_scheme($(@t, v_1)$)^alpha_rho = #code_box($#sem[$v_1$]^alpha_rho$)$

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

$#compilation_scheme($"inl" v_1$)^alpha_rho =
  #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(0)$)$

$#compilation_scheme($"inr" v_1$)^alpha_rho =
  #code_box($#sem[$v_1$]^alpha_rho$, $push_(s p)(1)$)$

$#compilation_scheme($x$)^omega_(x |-> {r_0}) =
  #code_box($&s p = r_0$)$

$#compilation_scheme($x$)^n_(x |-> r_0) =
  #code_box($push_(s p)(r_0)$)$

$#compilation_scheme($()$)^n_{} = #code_box("")$

$#compilation_scheme($lambda x. c$)^1_{} =
  &#code_block(
    $l_1$,
    meta($"let" r_1 = "next"({}, #math.italic("ptr"))$),
    $r_1 = s p$,
    $#sem[c]_(x |-> {r_1})$,
  ) \ & #code_box($push_(s p)(l_1)$)$

$#compilation_scheme(newstack)^omega_{} =
  #code_box($r_1 <- newstack$, $s p = r_1$)$

==== Negative fragment

$#compilation_scheme($"let" x,y = z^omega : A times.circle B; c$)_(rho, z |-> {r_0})
  = #code_box(
    meta($"let" r_1 = "next"(rho, A)$),
    $pop(r_1)$,
    $#sem[c]^omega_(rho, x |-> r_1, y |-> {r_0})$,
  )$

$#compilation_scheme($"let" x,y = z^n : A times.circle B; c$)_(rho, z |-> {r_0, r_1})
  = #code_box($#sem[c]^n_(rho, x |-> {r_0}, y |-> {r_1})$)$

$#compilation_scheme($"let" () = z^n; c$)_(rho,z |-> {})
  = #code_box($#sem[c]_rho$)$

$#compilation_scheme($"let" @t, x = z^alpha; c$)_(rho, z |-> r_0)
  = #code_box($#sem[c]_(rho, x |-> r_0)$)$

$#compilation_scheme($"let" square x = z^1; c$)_(rho, z |-> {r_0})
  = #code_box($#sem[c]_(rho, x |-> {r_0})$)$

$#compilation_scheme($"let" \_ = "freestack" z^omega; c$)_(rho, z |-> {r_0})
  = #code_box($"free"(r_0)$, $#sem[c]_rho$)$

$#compilation_scheme($"case" z^omega "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> {r_0})
  = #code_box(
    meta($"let" r_1 = "next"(rho, "int")$),
    $pop(r_1)$,
    $"if" "iszero"(r_1)$,
    $quad "then" #sem[$c_1$]_(rho, x |-> {r_0})$,
    $quad "else" #sem[$c_2$]_(rho, y |-> {r_0})$,
  )$

$#compilation_scheme($"case" z^n "of" { "inl" x |-> c_1; "inr" y |-> c_2;}$)_(rho, z |-> r_1: r_s)
  = #code_box($"if iszero"(r_1) "then" #sem[$c_1$]_(rho, x |-> r_s) "else" #sem[$c_2$]_(rho, y |-> r_s)$)$

$#compilation_scheme($"call" z^n (v)$)_(rho, z |-> {r_0}) =
  #code_box($&#sem[$v$]^omega_(rho)$, $&jmp r_0$)$
