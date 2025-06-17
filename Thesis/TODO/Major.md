## Table of Contents

- [ ] 5.1.1 is a lonely subsection - I suggest you merge it into 5.1.

- [ ] 5.2, on the other hand, has parhaps too many subsections


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
- 3.3: Types & values
  - [ ] Fig. 14: strange page break (only caption on p17)
