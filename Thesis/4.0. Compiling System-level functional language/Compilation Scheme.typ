#import "figures.typ": *
#import "../Prelude.typ": *


== Compilation Scheme
As can be seen in @TypesAndValues, every aspect of #ln
is based on a set of rules, split into positive and negative fragments.

These rules can by design be translated to x86-64 assembly in a
straightforward manner. They are first translated into \"pseudo\" instructions which can
then be translated into x86-64.

The compilation scheme consists of three functions:
- $#scheme_pos($\_$)^known_rho : "Value" -> "Pseudo instruction"$

- $#scheme_pos($\_$)^omega_rho : "Value" -> "Pseudo instruction"$

- $#scheme_neg($\_$)_rho : "Command" -> "Pseudo instruction"$

We prefix the functions with $""^+$ and $""^-$ to refer to the respective fragments.
If we use $alpha$ in-place of $omega$ and $known$, then the definition
exists for both kinds.
The symbol $rho$ represents a mapping from variables to a list of pseudo registers.
The syntax $rho, (x |-> s_n)$ means $rho$ is extended with $x$ mapping to the list $s_n$.
If we instead write $rho, (x |-> [r_0, ..., r_n])$ then $x$ maps to the list containing $r_0, ..., r_n$.
Additionally, we will use $r_0 : r s$ to mean the non-empty list with $r_0$ as the head and $r s$ as the tail, and
$s_0 ++ s_1$ means the concatenation of the lists $s_0$ and $s_1$.
Lastly, the number of registers $rho$ maps the variable $x$ to must be exactly
$#sem[$Gamma(x)$]^("R")$, i.e $|rho(x)| = #sem[$Gamma(x)$]^"R"$.

The function $#sem[$A$]^("R")$ is a mapping from a type $A$ to the number of registers needed to store a value $v$ with type $A$.
The definition for it can be found in
@mappingMemToType.

We annotate a variable $z^omega$ or $z^known$ in the negative fragment
to indicate the kind of the type of the variable.

A pseudo register is a physical register, or a location on the
stack. Formally, $rho$ can be seen as a function $rho : Gamma -> "List"("Reg")$.
The range of $rho$ is a list of pseudo registers because not all values
can be stored in one physical register.

In the compilation scheme, two explicit physical registers are used: the stack pointer (SP)
and the stack save pointer (SSP). SP points to a stack on which
we can pop and push, and SSP is used to temporarily back up SP.

The scheme also contains the meta instruction: $\""let" r = "next"(rho, t)\"$,
where $"next"$ has the type $"List"("Reg") -> "Type" -> "List"("Reg")$,
which allocates the list $r$ of fresh pseudo-registers.
The pseudo-registers chosen depends on which pseudo registers are used in $rho$,
and the size of the type $t$. The meta instruction exists only at compile time.


To ensure correctness and consistency of the compilation scheme, we specify
pre- and post-conditions for each compilation function:

Before calling $#scheme_pos($v$)^omega$, SP can be used
freely. After the call, SP points to $v$.
$#scheme_pos($v$)^known$ (note the change in kind) requires
that SP points to a valid stack before being called. After being called, $v$ is
pushed on the stack pointed to by SP. Finally, we have $#scheme_neg($v$)$. It
has no additional pre-conditions, only the post-condition that the program is terminated.
All three functions require that $rho(x)$ is correctly loaded with values.

The translation between pseudo instructions and x86-64 assembly can be seen in @translation_table,
and in @operand_table we explain the operands used in the compilation scheme.

#[
  #let frame(stroke) = (x, y) => (
    left: stroke,
    right: stroke,
    top: if (y == 0) { stroke } else { rgb("00000040") },
    bottom: stroke,
  )
  #set table(
    fill: (x, y) => if (y == 0) { rgb("#00000010") } else { white },
    stroke: frame(rgb("21222C")),
    align: (x, y) => if (y == 0) { center } else { left },
  )
  #figure(
    caption: [
      Translations between pseudo and x86-64 instructions and operands.
      Observe that the x86-64 instructions may differ in the compiler due to
      optimizations or the memory size of a variable.
    ],
    table(
      stroke: 0.1pt,
      columns: (1fr, 1fr),
      [*Pseudo instruction*], [*x86-64 instructions*],
      $push_R ("OP"_n)$,
      ```asm
      subq $n, R
      movq OP₁, 0(R)
      ...
      movq OPₙ, n(R)
      ```,

      $"OP1" = "OP2"$,
      ```asm
      movq OP2, OP1
      ```,

      $pop_R ("OP"_n)$,
      ```asm
      movq n(R), OPₙ
      ...
      movq 0(R), OP₁
      addq $n, R
      ```,

      ```
      if izero(OP₁)
        then C1
        else C2
      ```,
      ```asm
      movq OP₁, %R10
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

      $"OP1"_1 <- "malloc"("OP2"_1)$,
      ```asm
      movq OP2₁, %RDI
      call malloc
      movqq %RAX, OP1₁
      ```,

      $"free"("OP"_1)$,
      ```asm
      movq $0, %RAX
      movq OP₁, %RDI
      call free
      ```,
    ),
  ) <translation_table>

  #figure(
    table(
      columns: (1fr, 1.4fr),
      stroke: 0.1pt,
      [*Operand*], [*x86-64 Operand*],
      [Numerical literal, e.g. `42`], [Numerical literal prefixed with `$`, e.g. `$42`],
      $#sym.rho\(x)$, [Appropriate list of pseudo registers for type of $x$],
      `SP`, [`%R15`],
      `SSP`, [`%R14`],
      `[VAL]`, [`0(VAL)`],
    ),
    caption: [
      Translations between pseudo and x86 operands.
      `%R14` and `%R15` are physical x86-64 registers,
      and `0(VAL)` means that we are interacting with the memory address stored in `VAL`.
    ],
  ) <operand_table>
]

#show figure: set block(breakable: true)

#figure(
  caption: [Compilation scheme for the positive fragment of #ln.],
  positive_compilation_scheme,
) <compscheme_positive>
#figure(
  caption: [Compilation scheme for the negative fragment of #ln.],
  negative_compilation_scheme,
) <compscheme_negative>

// The astute reader might observe that matching positive and negative
// fragments "cancel" each other out. Linearity enforces that a positive fragment
// that creates a value,
// must be matched with a negative fragment at some point, which consumes said value.

// === Lambda Compilation <lambdaLifting>
// Lambdas are still in the language even in the the last step before compilation,
// as shown in the positive fragments.
//
// A common tactic when compiling lambdas is to use a process such as
// lambda lifting #t odo[source] or closure conversion #t odo[source].
// As can be seen in the tables above lambdas are still
// part of the language in the compilation scheme at this late stage.
// Commonly lambdas are removed entirely in earlier steps of the compilation process
// of a language, but in #ln
// we remove them at almost the last step; when compiling to x86-64.
// The method used is very close in principle to
// lambda lifting, in that lambdas are lifted to the top,
// but unlike lambda lifting or closure conversion, the function are never modified.
// The parameters are not touched, unlike in the two other methods, where
// free variables are added as parameters or in an environment parameter.
// Free variables in #ln are instead pushed to appropriate stacks so that they
// can be popped when needed.
//
// In the expressions where these lambdas occur, the lambda is simply pushed
// to the stack, which can be seen in its positive fragment,
// which can then be destroyed the negative call fragment.
//
