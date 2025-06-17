## 1 Intro

## 2 Background
- [ ] the section heading could be more informative

- [ ] Even then (after the swap) the Curry-Howard text comes a bit
  suddenly (and with an usual formulation "the direct relation").

- 2.2 Continuation-passing Style
  - [ ] "tail call": this enters a bit suddenly - perhaps introduce tail
    calls and evalution order earlier?


## 3. Lithium


- 3.2 Kinds & types
  - [ ] "There are four new constructs in Lithium": add "on the type
    level" somewhere, because you also have "newstack" on the value
    level.

  - [ ] Using a star/asterisk as a prefix operator (instead of infix)
    causes some reading challenges for me. I think you need to help a
    bit with spacing: make sure the prefix operators are "tightly
    connected" the the only operand: instead of "∗ (�� ⊗ ∗ �� ⊗ ∼ ��)" I
    would like to see "∗(�� ⊗ ∗�� ⊗ ∼��)".

## 4 Compiling Lithium
- 4.2 Compilation Scheme
  - [ ] "every aspect of Lithium is based on a set of rules": I'm not sure
    what you are trying to say here. The transformations and
    compilation is not described in the rules of section 3.3.
