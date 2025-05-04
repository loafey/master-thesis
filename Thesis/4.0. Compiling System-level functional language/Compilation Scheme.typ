#import "figures.typ": *

== Compilation Scheme
As can be seen in the @slflChapter chapter every aspect of SLFL
is based upon a set of judgements, split into positive and negative fragments.

These judgements can thankfully be translated to x86-64 assembly in a
straightforward manner. They are first translated into "pseudo" instructions which can
then be translated into x86-64.

=== Syntax
To help understanding the compilation scheme the reader should keep the following operators in mind:

- $rho : Gamma -> "List"("Reg")$ \
  $rho$ is a mapping from variables to a list of memory addresses.

  The reason the range of $rho$ is a list of memory addresses is because some values
  consist of multiple values, leading to more than one memory address.

- $#sem($t$)^alpha_rho = #code_box($c$)$ reads as follows: The compilation scheme
  for $t$ with kind $alpha$ and variable environment $rho$ is $c$. We use $alpha$
  to represent either $n$ or $omega$.

- The scheme uses a mix of meta syntax, i.e, instructions that does not generate
  any code, and instructions that generate code. We differentiate meta syntax
  with instructions using double quotes.

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

=== Positive fragment
As specified in @TypesAndValues these fragments are used to create values.
#positive_compilation_scheme

=== Negative fragment
Once again as specified in @TypesAndValues these fragments are used to destroy values.
#negative_compilation_scheme


