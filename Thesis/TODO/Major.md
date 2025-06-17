## Table of Contents

- [ ] 5.1.1 is a lonely subsection - I suggest you merge it into 5.1.

- [ ] 5.2, on the other hand, has parhaps too many subsections

## 1 Intro
- 1.2 Motivation
  - [ ] 1st sentence is a bit hard to read: mainly a long "list".
  - [ ] There are parts here which seem to be the logic version of the
    systems backgroud from 1.1.
  - [ ] Perhaps restructure to have 1.1 "Context: Functional programming
    meets system-level coding" or even "Linear logic" instead of FP.

## 2 Background
- 2.3 Comp Target
  - [ ] It is also a bit of a shift in direction - so far in 2.n you have
    introduced different theoretical topics, but here I think you
    shift towards the "system" and "compilation" aspect and it would
    be good to remind the reader of the "overall story".

  - [ ] "most of the time you want a higher level compilation target.":
    OK, but why do you talk about what the reader wants most of the
    time, instead of what _you_, the authors, want or actually use?
    Given that the explicity aim is "not only to be used as a
    system-level level language, but also as an intermediate
    compilation target for (linear) functional programming languages."
    it is a bit hard for the reader to know why you present these
    different IRs, when you are presenting an IR yourselves?

  - [ ] You cover a lot in this subsection: different IRs, IRs for
    different paradigms, assembly language, portability (unix / libc /
    Windows, unstable API), etc. which means it has a bit of an
    unclear direction. Are you listing _alternatives_ to Lithium, or
    backends for Lithium, or just giving an overview of the design
    space? Perhaps start with something like "Since one goal of
    Lithium is to serve as a compilation target for functional
    languages, it is important to understand what properties make a
    compilation target suitable for this purpose.".

  - [ ] This carefully about what is a key message and what is a
    "distraction" (and cut be cut / reduced).

- 2.3
  - [ ] 1st paragraph: style/tone: this is the first use of "you" in the
    whole thesis. I suggest you rephrase to keep the text more
    consistent.

## 3. Lithium
- 3.2 Kinds & types

- 3.3: Types & values
  - [ ] Fig. 14: strange page break (only caption on p17)

## 4 Compiling Lithium

- 4.1 Transformations
  - [ ] "Because the type ¬�� is transformed ... the type checker should
    allow □ ∼ �� where ¬�� is expected": I don't see why this is the
    case. You should be able to think about the language before and
    after translation as two slightly different sublanguages, which
    may require different typing rules, but allowing any mix of the
    two seems "dangerous".

  - [ ] "end up being ill-kinded" - the story-line seems a bit strange:
    you say that 4.1.2 shows how to transform the types to keep them
    well-kinded. But then the closures don't "end up being ill-kinded"
    after all. Perhaps you meant to motivate why the 4.1.2
    transormation is needed?

  - [ ] 4.1.2: I don't get this part

  - [ ] 4.1.3: Same here: I find this subsection very hard to penetrate. Examples:
    - [ ] "The issue is that the only variable that is a stack is ��′, but
      it cannot be the chosen stack because bound variables are stored
      on the stack." ??
    - [ ] "Because ��′ is a stack, and a free variable in ����.��′(��),
      pairvars does not need to construct a newstack." ??
    - [ ] "⟨○, (��∗ (��, ��1 ). freestack ��1 ; foo(��), ����������������)⟩" ??     
  - [ ] How can "unpairAll" invert "this procdure" without taking Gamma as
    an argument?

## References
- [ ] "Bernardy, J.-P., Juan, V. L., & Svenningsson, J. (2016). Composable
  efficient array computations using linear types. Unpublished
  Draft.": where can the reader find it?

- [ ] "Girard, J.-Y. (1972). Interprétation fonctionnelle et élimination
  des coupures de l'arithmétique d'ordre supérieur.": Unclear what it
  is (A PhD thesis) and how to get it (university, link, etc.)

- [ ] "Laurent, O. (2002). Etude de la polarisation en logique.": how to
  get? what is it?

- [ ] "Nordmark, F. (2024). Towards a Practical Execution Model for
  Functional Languages with Linear Types.": how to get? what is it?

- [ ] "Place, O. A., & Cleveland, S. x86-64 TM Technology White Paper.":
  Strange. Assuming
  https://people.computing.clemson.edu/~mark/464/x86-64_wp.pdf is the
  reference you aim at, the first part: "Place, O. A." is the
  (stangely abbreviated) street address: "One AMD Place", not an
  author name. Cleveland is the author/editor/contact.

- [ ] "Wikipedia. (2024, ). Systems programming": strange year "(2024, )"
