
## Table of Contents

- [ ] 5.1.1 is a lonely subsection - I suggest you merge it into 5.1.

- [ ] 5.2, on the other hand, has perhaps too many subsections

## 1 Intro
- 1.2 Motivation
  - [ ] There are parts here which seem to be the logic version of the
    systems backgroud from 1.1.
  - [ ] Perhaps restructure to have 1.1 "Context: Functional programming
    meets system-level coding" or even "Linear logic" instead of FP.


  - [ ] The long figures look impressive, but I'm a bit worried about the
    "pattern matching" on things like "��,��↦[��0]": what happens if the
    list that z maps to is not a singleton list?

## 2 Background
- [ ] the section heading could be more informative

- [ ] Even then (after the swap) the Curry-Howard text comes a bit
  suddenly (and with an usual formulation "the direct relation").

- 2.2 Continuation-passing Style
  - [ ] "tail call": this enters a bit suddenly - perhaps introduce tail
    calls and evalution order earlier?


## 3. Lithium

- 3.2 Kinds & types

  - [ ] Using a star/asterisk as a prefix operator (instead of infix)
    causes some reading challenges for me. I think you need to help a
    bit with spacing: make sure the prefix operators are "tightly
    connected" the the only operand: instead of "∗ (�� ⊗ ∗ �� ⊗ ∼ ��)" I
    would like to see "∗(�� ⊗ ∗�� ⊗ ∼��)".

## 5
- [ ] It would be nice to see the corresponding comparison for a more
  clever fibonacci with linear run time (in all the versions). Or is
  that not possible in Lithium?
