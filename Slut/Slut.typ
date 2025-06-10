#import "@preview/slydst:0.1.4": *
#import "./Prelude.typ": *

#set text(font: "FreeSans")
#show: slides.with(
  title: [Towards a System-Level Functional Language: #ln],
  subtitle: none,
  date: none,
  authors: ("Sebastian Selander", "Samuel Hammersberg"),
  layout: "large",
  ratio: 4 / 3,
  title-color: none,
)

== 
#align(center + horizon)[
  We would like to thank our supervisor Jean-Philippe Bernardy for his
  thesis idea as well as his enthusiastic involvement, support, and guidance throughout the project.
]

#include "Intro/main.typ"
#include "Background/main.typ"
#include "Language/main.typ"
#include "Compilation/main.typ"
#include "Demonstration/main.typ"
