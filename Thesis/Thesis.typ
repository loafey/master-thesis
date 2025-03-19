#import "Prelude.typ": *

#let in-outline = state("in-outline", false)
#show outline: it => {
  in-outline.update(true)
  it
  in-outline.update(false)
}
#set heading(numbering: "1.")

#set page(margin: 1.4in, numbering: (..n) => context {
  if in-outline.get() {
    numbering("1 / 1", ..n)
  } else {
    numbering((_,_) => {} , ..n)
  }
})

#show heading: it => [
  #it
  #v(0.3cm)
]
#set text(font: "New Computer Modern", size: 12pt)
#set par(justify: true)

#include "0. Splash.typ"
#pagebreak()
#pagebreak()
#include "0.1. Fancy Splash.typ"
#pagebreak()
#include "0.2. Licence.typ"
#pagebreak()
#include "0.3. Abstract.typ"
#pagebreak()

#counter(page).update(1)
#outline()
#in-outline.update(true)
#pagebreak()

#include "1.0. Introduction.typ"
#pagebreak()

#include "2.0. Theory.typ"
#pagebreak()

#include "3.0. Language.typ"
#pagebreak()

#include "4.0. Implementation.typ"
#pagebreak()

#include "5.0. Demonstration.typ"
#pagebreak()

#include "6.0. Discussion.typ"
#pagebreak()

#include "7.0. Conclusion.typ"
#pagebreak()

#pagebreak()
<end>
#bibliography(title: "References","bib.bib")
