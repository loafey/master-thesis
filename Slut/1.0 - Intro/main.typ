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
]

== Introduction

- Functional programming
  - Referential transparency
  - Purity
  - Higher-order functions
  - More...
  - Why Functional Programming Matters (Hughes, 1990)

- Linear types 
  - Mutation
  - Must free allocated memory
  - Must close opened files
  - More...

- Goal: 
  - Intermediate representation for linear functional languages
  - Ability to write #ln directly
