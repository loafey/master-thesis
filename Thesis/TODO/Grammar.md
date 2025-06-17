## Abstract:
- [x] "studied" := "well-documented?"

- [x] "By leveraging the restrictions linear types impose" sounds a bit
  confusing: try to formulate in a positive direction: the
  "restrictions" lead to better / stronger guarantees, etc. -
  perhaps "By leveraging the guarantees provided by ..."

- [x] "based a variant" := "based on a variant"    

- [x] "The purpose of Lithium as an intermediate compilation target." ??
  fragment. Perhaps "Lithium is design to be an ..."?

## 2 Background
- 2.1 Lambda calculus and linear types
  - [x] "We will introduce the simply typed lambda calculus, then
    extending it with polymorphic types, and end by introducing linear
    types.": grammar suggestion: "... introduce the simply typed
    lambda calculus, extend it with polymorphic types, and introduce
    linear types."
  - [x] "Linear types does" := "Linear types do"

- 2.2 Continuation-passing Style
  - [x] "A natural question that comes to mind is why we want
    continuation-passing style?": perhaps "A natural question is: what
    are the advantages of using continuation-passing style?"

- 2.3
  - [ ] 1st paragraph: style/tone: this is the first use of "you" in the
    whole thesis. I suggest you rephrase to keep the text more
    consistent.
  - [ ] "some commons examples" typo

## 3. Lithium
- 3.3: Types & values
  - [x] "aforementioned" := "" (not needed) or "typing"

  - [x] "typing proof" := "typing derivation"

  - [x] Fig. 15: "identity function" := "identity function on A"

## 4 Compiling Lithium
- [ ] "something that can be": be more specific - perhaps "an intermediate
  representations ..."

- [ ] "application binary Interface" := "application binary interface"

- 4.1 Transformations
  - [ ] "It is important not to forget": I suggest you rephrase/shorten:
    perhaps "The corresponding transformation of the negative fragment
    ..."
  - [ ] "can not" := "cannot"
  - [ ] "… ⊗ ���� If Γ" := "… ⊗ ����. If Γ" (sentence-ending period missing)
  - [ ] "pairvars" (one use) or "pairsvars" (two uses)?- 4.2 Compilation Scheme
  - [ ] "The syntax ��, (�� ↦ ���� )" := "The notation ��, (�� ↦ ���� )"

- 4.2 Compilation Scheme
  - [ ] It is a bit confusing to introduce "The function ��", then say "the
    context ��" in the next sentence.
  - [ ] "��0 + +��1" := "��0 ++ ��1" - probably should be \mathbin{{+}{+}} or
    something like that.

- 4.3 Compilation target
  - [ ] style: "a developer can not guarantee", "gives us the ability", "a
    lot of": too informal / different in style from the rest.
  - [ ] "like LLVM IR, provide" := "like LLVM IR provide"

- 4.4. Language ABI
  - [ ] "jump(" := "jump ("
  - [ ] 4.4.2: "following chapter": "subsection" or "table"
  - [ ] "⟦��⟧�� = ℕ": ? do you mean "⟦��⟧�� : ℕ"?
  - [ ] "⟦��⟧M + ∞"?? ∞ is not in ℕ.
  - [ ] (I had to start skimming here, after too many hours on reading.)