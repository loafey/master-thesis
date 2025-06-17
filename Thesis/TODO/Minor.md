## 1 Intro

## 2 Background
- [ ] the section heading could be more informative

- [ ] Even then (after the swap) the Curry-Howard text comes a bit
  suddenly (and with an usual formulation "the direct relation").


- 2.2 Continuation-passing Style
  - [ ] "tail call": this enters a bit suddenly - perhaps introduce tail
    calls and evalution order earlier?

  - [ ] "Only a single ... can been seen in the grammar of commands in
    Lithium (see Section 3.1).": A bit hard to know (for the reader)
    if "only a single" is a general property of CPS, or an additional
    requirement that you impose in the grammar of Lithium.



## 3. Lithium
- [ ] "This is achieved by departing from the lambda calculus and its
  natural deduction root": the word "depart" has (at least) two
  meanings: "start" or "deviate". Please rephrase to make the meaning
  more clear.

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
  - [ ] The long figures look impressive, but I'm a bit worried about the
    "pattern matching" on things like "��,��↦[��0]": what happens if the
    list that z maps to is not a singleton list?
