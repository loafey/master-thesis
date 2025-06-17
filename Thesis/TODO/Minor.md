## 1 Intro

## 2 Background
- [ ] the section heading could be more informative


- [ ] It would be nice to state something about "prerequisites" (some
  familiarity with (untyped) lambda calculus?)

- [ ] Even then (after the swap) the Curry-Howard text comes a bit
  suddenly (and with an usual formulation "the direct relation").


  - [ ] If "System F" and "the polymorphic lambda calculus" are introduced
    as synonyms, then stick to one name from then on. There is a bit
    of a mix now.

  - [ ] "The identity function" is a bit short as a Fig. caption. Perhaps
    add "polymorphic" and "a type derivation for".

  - [ ] "The proof for the identity function": proof := type derivation?

  - [ ] "the meta-symbol ���� to refer to the identity function": For
    clarity, as it is so short, I suggest you inline the definition:
    "the meta-symbopl id = \A.\x:A.x ..."

  - [ ] "Note how the environments for ��1 and ��2 in App are disjoint": I
    don't think the reader can "note" that from the figure. As you
    don't present any rules for the comma in |Gamma, Delta|, they
    could in principle both list the same variable (even with
    different types).

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
  - [ ] "Formally, �� can be seen as a function �� : Γ → List(Reg).": I
    understand what you mean, but this does not "type check": Gamma is
    a context, not a type. Also the combination of "Formally" and "can
    be seen as" is odd. Perhaps: "rho : Var -> List(Reg)". Or
    "rho_Gamma : dom(Gamma) -> List(Reg)". I'm also not sure if empty
    lists are "allowed".
  - [ ] "The range of �� is a list of pseudo registers": no. The range of a
    function f : A->B is the _set_ of values of type B it can return.
    Here a set of lists (of pseudo-registers).
  - [ ] "that ��(��) is correctly loaded with values": perhaps "that the
    registers in ��(��) are correctly loaded with values"?
      - Also, what is "��" here? 
  - [ ] The boxes for "Right injection" and "Left injection" seem to be
    mixed up. (Right uses inl, Left uses inr on p24.)
  - [ ] "Static function": the text in the box talks about r_1 but the
    code uses r.
  - [ ] The long figures look impressive, but I'm a bit worried about the
    "pattern matching" on things like "��,��↦[��0]": what happens if the
    list that z maps to is not a singleton list?
