## Table of Contents
- [x] How is 1.1 Background related to 2. Background? Perhaps specialise
  one (or both) to technical background, context, problem domian,
  etc.

- [x] 3.2 + 3.3: These could also be a bit more informative: I would
  guess there are also different kinds of contexts, rules, etc.

- [ ] 5.1.1 is a lonely subsection - I suggest you merge it into 5.1.

- [ ] 5.2, on the other hand, has parhaps too many subsections

## 1 Intro
- [x] I feel the intro is a bit sudden - perhaps add a sentence or two
  "zooming in" from the general audience (any CSE MSc student, for
  example) towards the topic.

- 1.2 Motivation
  - [ ] 1st sentence is a bit hard to read: mainly a long "list".
  - [ ] "Although the merits of functional programming are evident
    (Hughes, 1989), it is under represented for system-level
    programming": use "underrepresented" (one word) and replace
    "evident" by "well established".
  - [ ] There are parts here which seem to be the logic version of the
    systems backgroud from 1.1.
  - [ ] Perhaps restructure to have 1.1 "Context: Functional programming
    meets system-level coding" or even "Linear logic" instead of FP.

- 1.3: Related work
  - [ ] "A lot of research" - this sentence is too vague.
  - [ ] This whole subsection is too narrow for a "related work" section.
    Rename or beef up significantly to 5-10 references.

## 2 Background
- 2.1 Lambda calculus and linear types
  - [x] "... the set of variables in �� ...": this is not quite correct - I
    think you mean "free variables"? But even in the linear case "the
    set of variables in �� is Γ" is a "type error" as you have
    presented contexts as lists of pairs, not sets.

  - [ ] The way Duplicate is used could use some explanation: it looks as
    if something like this would be a valid typing derivation:

      (Gamma, x:!A |- f x : A o-> A)   (y :! A |- y : A)
     --------------------------------------------------- App
      Gamma, x:!A, y :!A |- f x y : A
     --------------  Duplicate
      Gamma, x:!A |- f x y : A

    But the "y" in the bottom is now "unbound"?

- 2.2 Continuation-passing Style
  - [ ] Example: "id = ����.����. ��(��)" uses unbound "n".

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

## 3. Lithium
- 3.1
  - [ ] What is "z" in "z(v)"? just a variable name (as x in Value)?
  - [ ] "where a definition is a top-level function": why restrict to
    functions when the grammar allows any values?

  - [ ] Please use the swap example more in the explanations of the
    grammar: that the lambda body is a command |k((y,x))|, that the
    "z" in the command is a variable (here the continuation k), etc.

- 3.2 Kinds & types
  - [ ] "It is forbidden to construct a pair of two stacks": I don't
    understand what this means. I see that the rules requires the
    first type in the pair type to be of kind "circle 1", but I lack
    intuition for why of what that may entail.

  - [ ] "The goto style": I don't understand what "capture state" and "the
    state that *B manipulates" means. I'm not used to read odd "state
    manipulation" from lambda terms. Perhaps you need to delay this
    explanation, or expand it with more concrete examples. I'm still
    at the "kind level" in the reading, and have a hard time imagining
    pointers, gotos, etc.

  - [ ] "a stack that accepts �� as a return value to continue with": I'm
    lost here. I know what "stack" means normally as a datastructure,
    but a datastructure does not "accept" anything as a "return
    value".

  - [ ] "the higher-order function: ∗ (�� ⊗ ¬�� ⊗ ∼ ��)": I don't know _what_
    higher order function you mean to write, or how this string of
    symbols is supposed to represent it.

- 3.3: Types & values
  - [ ] "the contexts Γ, Δ, must be disjoint" should not be a comment /
    explanation but a part of the requirements of the rule.

  - [ ] "freestack z": This is the first mention of "freestack" - it is
    not in the grammar in Fig. 9: Fix this.

  - [ ] Fig. 14: strange page break (only caption on p17)
