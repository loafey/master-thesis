#import "../Prelude.typ": *

== Abstract

#indent[
  - Introduction
  - Background 
    - Linear types
    - Continuation-passing style
  - #ln
    - Kinds
    - Types
    - Values/commands
  - Compiling #ln
    - Transformations
    - ABI
    - Compilation Scheme
  - Demonstration
  - Future Work
    - System Calls
    - Exponentials
    - More...
]

== Introduction

- Functional programming
  - Referential transparency
  - Purity
  - Higher-order functions
  - Why Functional Programming Matters (Hughes, 1990)

- Linear types 
  - Mutability
  - Must free allocated memory
  - Must close opened files
