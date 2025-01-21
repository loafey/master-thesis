#import "Prelude.typ": *
#set heading(numbering: "1.")
#show heading: it => [
  #it
  #v(0.3cm)
]
#set text(font: "New Computer Modern", size: 12pt)
#set par(justify: true)
#set page(margin: 1.4in, numbering: "1. ")
#set heading(numbering: "1.")


#set page(numbering: none)
#include "0. Splash.typ"
#pagebreak()
#pagebreak()
fancy splash
#pagebreak()
licence
#pagebreak()
#set page(
  numbering: (n, _) => [
    // #n of #context numbering("1", ..counter(page).at(<end>))
    #n
  ]
)
#counter(page).update(1)

abstract

#pagebreak()

<end>
#bibliography(title: "References","bib.bib")
