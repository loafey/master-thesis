#import "figures.typ": *

== Compilation Scheme
As can be seen in the @SlflChapter chapter every aspect of #ln
is based upon a set of judgements, split into positive and negative fragments.

These judgements can thankfully be translated to x86-64 assembly in a
straightforward manner. They are first translated into "pseudo" instructions which can
then be translated into x86-64.

=== Syntax
To help understanding the compilation scheme the reader should keep the
following operators and syntax in mind:

- $rho : Gamma -> "List"("Reg")$ \
  $rho$ is a mapping from variables to a list of psuedo register.
  A psuedo register can either be a physical register or a location on the
  system stack.

  The reason the range of $rho$ is a list of psuedo registers is because some values
  consist of multiple values, leading to more than one psuedo registers.

- $#sem($t$)^alpha_rho = #code_box($c$)$ reads as follows: The compilation scheme
  for $t$ with kind $alpha$ and variable environment $rho$ is $c$. We use $alpha$
  to represent either $known$ or $omega$.

- The scheme uses a mix of meta syntax, i.e, instructions that does not generate
  any code, and instructions that generate code. We differentiate meta syntax
  with instructions using double quotes.

The instructions that do generate code, such as $push x$, work
similary to their assembly counterparts.

#{
  let frame(stroke) = (x, y) => (
    left: stroke,
    right: stroke,
    top: if (y == 0) { stroke } else { rgb("00000040") },
    bottom: stroke,
  )
  set table(
    fill: (x, y) => if (y == 0) { rgb("#00000010") } else { white },
    stroke: frame(rgb("21222C")),
    align: (x, y) => if (y == 0) { center } else { left },
  )
  figure(
    caption: [
      Translations between pseudo and x86-64 instructions and operands.
      Observe that the x86-64 instructions might differ in the compiler due to
      optimizations or the memory size of a variable.
    ],
    table(
      columns: (1fr, 1fr),
      [*Pseudo instruction*], [*x86-64 instructions*],
      $push "OP"$,
      ```asm
      subq $sizeof(OP), %R15
      mov  OP,          0(%R15)
      ```,

      $"OP_1" = "OP_2"$,
      ```asm
      mov OP_2, OP_1
      ```,

      $pop "OP"$,
      ```asm
      mov 0(%R15),     OP
      addq sizeof(OP), %R15
      ```,

      ```
      if izero(OP)
        then C1
        else C2
      ```,
      ```asm
      mov OP, %R10
      cmp $0, %R10
      jnz lbl
      C1 # codeblock
      lbl:
      C2 # codeblock
      ```,

      $jmp L$,
      ```asm
      jmp L
      ```,

      $L:$,
      ```asm
      L: # a label
      ```,

      $newstack$,
      ```asm
      mov STACKSIZE, %RDI
      call malloc

      # push to the stack
      subq $8,  %R15
      movq %RAX, 0(%R15)
      ```,

      $"free"("OP")$,
      ```asm
      mov $0, %RAX
      mov OP, %RDI
      call free
      ```,
    ),
  )

  figure(
    table(
      columns: (1fr, 1.4fr),
      [*Operand*], [*x86-64 Operand*],
      [Numerical literal, e.g. `42`], [Numerical literal prefixed with `$`, e.g. `$42`],
      $#sym.rho\(x)$, [Appropiate list of psuedo registers for type of $x$],
      `SP`, [`%R15`],
      `SSP`, [`%R14`],
      `VAL_1[VAL_2]`, [`VAL_2(%VAL_1)`],
      `[VAL]`, [`0(%VAL)`],
    ),
    caption: [
      Translations between pseudo operands and x86 operands.
    ],
  )
}

=== Positive fragment
As specified in @TypesAndValues these fragments are used to create values.
#positive_compilation_scheme

=== Negative fragment
Once again as specified in @TypesAndValues these fragments are used to destroy values.
#negative_compilation_scheme

=== Lambda Compilation <lambdaLifting>
As can be seen in the compilation scheme for positive fragmets, lambdas are
still in the language even in the the last step before compilation.

A common tactic when compiling lambdas is to use a process such as
lambda lifting #todo[source] or closure conversion#todo[source].
As can be seen in the tables above lambdas are still
part of the language in the compilation scheme at this late stage.
Commonly lambdas are removed entierly somewhat early in a language, but in #ln
we remove them when compiling to x86-64. The method used is very close in principle in
lambda lifting, in that lambdas are lifted to the top,
but unlike lambda lifting or closure conversion, the function are never modified.
The parameters are not touched, unlike in the two other methods, where
free variables are added as parameters or in an enviornment parameter.

In the expressions where these lambdas occur, they are simply replaced with a
function pointer to said lambda, which can then be called.
