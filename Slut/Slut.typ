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

#include "1.0 - Intro/main.typ"
#include "2.0 - Background/main.typ"
#include "3.0 - Language/main.typ"
#include "4.0 - Compilation/main.typ"
#include "5.0 - Demonstration/main.typ"
#include "6.0 - Future Work/main.typ"
#include "7.0 - Outro/main.typ"
