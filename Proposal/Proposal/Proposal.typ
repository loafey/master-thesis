#import "Prelude.typ": *
#set heading(numbering: "1.")
#show heading: it => [
  #v(0.5cm)
  #it
  #v(0.3cm)
]
#set text(font: "New Computer Modern", size: 12pt)
#set par(justify: true)
#set page(margin: 1.4in)
#show heading: it => {
    it
    v(0.5em)
}
#set heading(numbering: "1.")

#include "0. Splash.typ"
// #outline(indent: true)#todo[remove the outline]
#include "1. Intro.typ"
#include "2. Goals.typ"
#include "3. Approach.typ"

#pagebreak()
#bibliography(title: "References","../bib.bib")
