#import "../Prelude.typ": *

= Background

The Curry-Howard correspondence is the direct relation between logic and computer programs @howard1980formulae.
The correspondence is commonly called the proofs-as-programs and
propositions-as-types, because proofs correspond to programs and propositions
correspond to types. Where a logician may write a proposition, and a proof of
that proposition, a programmer may write a type and a (type correct) program.
We take the approach from the programmer's perspective, i.e. programs and
types.

This chapter introduces the necessary context for #ln. We start by introducing
the calculus in the form of the typed lambda calculus and linear types. We
continue by explaining continuation-passing style and its relevance in
compilers. The chapter finishes by presenting different compilation targets and
their upsides and downsides. 

// #include "Logic.typ"
#include "Lambda Calculus.typ"
#include "CPS.typ"
#include "Compilation Targets.typ"
