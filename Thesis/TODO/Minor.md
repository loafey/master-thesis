## 1 Intro

## 2 Background
- [ ] the section heading could be more informative

- [ ] Even then (after the swap) the Curry-Howard text comes a bit
  suddenly (and with an usual formulation "the direct relation").


- 2.2 Continuation-passing Style
  - [ ] "tail call": this enters a bit suddenly - perhaps introduce tail
    calls and evalution order earlier?




## 3. Lithium

- 3.1
  - [ ] "sequence of commands" is not accurate, it is more like a tree
    (due to case) whose leaves all are calls.

- 3.2 Kinds & types
  - [ ] "There are four new constructs in Lithium": add "on the type
    level" somewhere, because you also have "newstack" on the value
    level.

  - [ ] "stack (��) and known size": indicate notation for "known size" as
    well.

  - [ ] Using a star/asterisk as a prefix operator (instead of infix)
    causes some reading challenges for me. I think you need to help a
    bit with spacing: make sure the prefix operators are "tightly
    connected" the the only operand: instead of "∗ (�� ⊗ ∗ �� ⊗ ∼ ��)" I
    would like to see "∗(�� ⊗ ∗�� ⊗ ∼��)".


- 3.3: Types & values
  - [ ] "Lithium programs consist of two syntactic fragments:": this start
    is a bit confusing given that you have already introduced them in
    Fig. 9 (under the syntactic categories Value, and Command). Unless
    you mean something different, just refer back and introduce your
    new synonyms (positive fragment for Value, etc.).

## 4 Compiling Lithium
- 4.1 Transformations
  - [ ] "The first three phases": I suggest you remake this paragraph into a
    numbered list with "name + explanation + forward reference" for each
    list item.

- 4.2 Compilation Scheme
  - [ ] "every aspect of Lithium is based on a set of rules": I'm not sure
    what you are trying to say here. The transformations and
    compilation is not described in the rules of section 3.3.
