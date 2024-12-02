#import "@preview/slydst:0.1.3": *

#show: slides.with(
  title: "System-level Functional Programming with Linear Types",
  subtitle: none,
  date: none,
  authors: ("Sebastian Selander", "Samuel Hammersberg"),
  layout: "medium",
  ratio: 4/3,
  title-color: none,
)

#pagebreak()
#include "1. SystemLevel.typ"
#pagebreak()
#include "2. LinearTypes.typ"
#pagebreak()
#include "3. SLFL.typ"
#pagebreak()
#include "4. Related Work.typ"

#pagebreak()
== Why you?
#text(size: 200pt,[We the best])
#pagebreak()
#include "6. Risk.typ"
#pagebreak()

#bibliography("../bib.bib")
