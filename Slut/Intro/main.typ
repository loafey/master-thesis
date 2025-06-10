#import "../Prelude.typ": *

== Abstract

#indent[
  - Linear types
  - Continuation-passing style
  - #ln
    - Kinds
    - Types
    - Values/commands
  - Compiling #ln
    - Transformations
    - Compilation Scheme
    - ABI
  - Future Work
    - Exponentials
    - Data types
    - Register Allocation
    - Many more...
]

// == What is #ln
//
// #ln is a new programming language developed by us and our supervisor.
//
// Can be summarized with:\
// #indent[
//   - System-level
//
//   - Functional
//
//   - Linearly typed
//
//   - Continuation-passing style
// ]
//
// == What should it be used for?
// The use cases we hope to aim for are:\
// #indent[
//   - A compilation target for other (linear) functional languages
//
//   - System level programming (if you want :) ) #todo[]
// ]
//
//
// == Why use it as a compilation target?
// #(pre.bullets)(
//   [
//     If you as a compiler developer desire:
//
//   ],
//   first: true,
//   (
//     [Type safety],
//     [Enforced linearity],
//     [Continuation-passing style],
//     [Closures and higher-level programming],
//   ),
// )

// There are already so many choices for compilation targets!
//
// Some examples include:
//
// - LLVM IR
//
// - x86-64
//
// - And probably many more...
//
// #pagebreak()
//
// #(pre.anim)(
// [
// So why not use these as compilation targets?
// #linebreak()
// ],
// (
// [],
// [
// #text(size: 1.2em, weight: "bold")[x86-64]
//
// Very powerful but...
//
// - Very complicated
//
// - Hard to debug
//
// - Does not enforce type safety
//
// - Does not enforce linearity
// ],
// [
// #text(size: 1.2em, weight: "bold")[LLVM IR]
//
// Also very powerful but...
//
// - Tailored for procedural programming
//
// - Does not enforce linearity
//
// - Only enforces type safety to a degree
// ],
// ),
// )
//
