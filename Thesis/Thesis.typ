#import "Prelude.typ": *
#import "@preview/hydra:0.6.1": hydra

// #set text(fill: white, stroke: 0.2pt + white)
// #set page(background: rect(fill: black, width: 100%, height: 100%))

#set figure(supplement: "Figure", kind: "figure")

#let in-outline = state("in-outline", false)
#show outline: it => {
  in-outline.update(true)
  it
  in-outline.update(false)
}
#set heading(
  numbering: (..lvl) => {
    let xs = lvl.pos()
    if xs.len() == 1 { "1" } else { "1." }
  },
)

// #show ref.where(form: "normal"): set ref(
//   supplement: it => {
//     lower(it.supplement)
//   },
// )

#set page(
  margin: 1.4in,
  header: context {
    let order
    if calc.odd(here().page()) {
      order = right
    } else {
      order = left
    }
    align(order, hydra(1))
    if hydra(1) != none { line(length: 100%) }
  },
  numbering: (..n) => context {
    if in-outline.get() {
      numbering("1 / 1", ..n)
    } else {
      numbering((_, _) => { }, ..n)
    }
  },
)
#set heading(numbering: "1.")

#show heading: it => {
  it
  v(0.3cm)
}
#set text(font: "New Computer Modern", size: 12pt)
#set par(justify: true)

#import "@preview/wordometer:0.1.4": word-count, total-words
#show: word-count

In this document there are #total-words words in total.


#include "0. Splash/main.typ"

#counter(page).update(1)
#outline()
#outline(title: [Figures], target: figure)
#in-outline.update(true)
#pagebreak()

#include "1.0. Introduction/main.typ"
#pagebreak()

#include "2.0. Background/main.typ"
#pagebreak()

#include "3.0. System-level functional language/main.typ"
#pagebreak()

#include "4.0. Compiling System-level functional language/main.typ"
#pagebreak()

#include "5.0. Discussion/main.typ"
#pagebreak()

#include "6.0. Conclusion/main.typ"
#pagebreak()
<end>
#bibliography(title: "References", "bib.bib", style: "apa")
