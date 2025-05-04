// Forgot that compilation scheme exists above :)
// #let sem(t) = {
//   $bracket.l.double #t bracket.r.double$
// }
// #let judge(above, below) = {
//   $#above / #below$
// }

// == Compilation Scheme
// As can be seen in the @slflChapter chapter every aspect of SLFL
// is based upon a set of judgements, split into positive and negative fragments.

// These judgements can thankfully be translated to x86-64 assembly in a somewhat
// straightforward manner. They are first translated into pseudo instructions which can
// then be translated into x86-64.

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

// === Stankyboi
// For some $x,u$: $"push" x; #sem[u]$ might change to $#sem[u] ; "push" x$

// === Positive fragment

// ==== Case: $omega$

// #let compile_box(t) = {
//   box(baseline: 100%, stroke: black, inset: 5pt, t)
// }

// Pre-condition: $S p$ is free to use.

// Post-condition: $S p$ points to the stack which is being built.

// #judge(
//   $Gamma tack.r t: A quad Delta tack.r u: B: omega$,
//   $Gamma, Delta tack.r A times.circle B$,
// ) = $#sem[(t,u)] = #sem[u]^omega; #sem[t]^n$

// #judge($Gamma tack.r t: A$, $Gamma tack.r "inl" t: A plus.circle B$) = $#sem[t] ; "push" 0$

// #judge($Gamma tack.r t: B$, $Gamma tack.r "inr" t: A plus.circle B$) = $#sem[t] ; "push" 1$

// #judge("", $x: A tack.r x: A$) = $s p = rho(x)$

// ==== Case: $n$

// Pre-condition: $S p$ points to a valid stack.

// Post-condition: #sem[$dot$] pushes the result there.

// #judge($Gamma tack.r t: A quad Delta tack.r u: B$, $Gamma, Delta tack.r (t,u): A times.circle B$) = $#sem[u]^n; #sem[t]^n$

// #judge("", $tack.r "newstack": circle$) = $A x = "newstack"; "push" A x$

// #judge($tack.r t: A: omega$, $tack.r square A: n$) =
// #box(baseline: 100%, stroke: black, inset: 5pt)[
//   push SSP on SP \
//   SSP = SP \
//   #sem[t] \
//   SSP[1] = SP \
//   SP = SSP + 1 \
//   SSP = [SSP]
// ]

// === Negative fragment

// #sem[$"let" z, rho = rho_o; c$] = $"pop" ; #sem[c]^(quad (A times.circle tilde R): omega)$

// #sem[$"call" z(x)$] = $"push" x; "jmp" rho(z)$

// Not a stack:\
// #sem[$"case" z "of" {c_1; c_2}$] =
// #compile_box[
//   pop $rho(z)$ \
//   mov r = $[rho(z)]$\
//   jnz $l_1$ \
//   #sem[$c_1$] \
//   jmp $l_2$ \
//   $l_1$: \
//   #sem[$c_2$] \
//   $l_2$:
// ]

// Stack:
// #sem[$"case" z "of" {c_1; c_2}$] =
// #compile_box[
//   pop $rho(z)$ \
//   mov $r=[rho(z)]$ \
//   jnz $l_2$ \
//   mov $rho(x)$ = $rho(z)$ + 1 \
//   #sem[$c_1$] \
//   $l_2$: \
//   mov $rho(y)$ = $rho(z)$ + 1 \
//   #sem[$c_2$]
// ]


// === What is a (stack: $omega$)

// - Type variable (?)
// - $(A + B) "if" (A: omega) "and" (B: omega)$
// - $(A ⊗ B) "if" (B: omega)$
// - $~A$
// - EmptyStack
