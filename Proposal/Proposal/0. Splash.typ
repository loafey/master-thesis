#let frontPageSize = 14pt;

#align(center, [
  #v(2cm)
  #text(size: frontPageSize, [MASTER THESIS PROJECT PROPOSAL])

  #text(size: frontPageSize + 8pt, weight: "bold", [Towards a System-Level Functional Language])

  #v(2cm)

  #text(size: frontPageSize,[
    Sebastian Selander\
    `gusselase@student.gu.se`
  
    Samuel Hammersberg\
    `gushamsak@student.gu.se`
  ])

  #v(1.8cm)

  #text(size: frontPageSize, [Suggested supervisor at CSE: Jean-Philippe Bernardy])

  #v(1.8cm)

  #text(size: frontPageSize, [Relevant completed courses:])
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 8pt,
    align(left, text(size: frontPageSize - 2pt, [
      Sebastian Selander:\
      _DIT235, Types for Programs and Proofs_\
      _DIT260, Advanced Functional Programming_\
      _DIT261, Parallel Functional Programming_\
      _DIT203, Logic in Computer Science_\
      _DIT301, Compiler Construction_
    ])), align(left, text(size: frontPageSize - 2pt, [
      Samuel Hammersberg:\
      _DIT235, Types for Programs and Proofs_\
      _DIT260, Advanced Functional Programming_\
      _DIT261, Parallel Functional Programming_\
      _DIT301, Compiler Construction_
    ]))
  )
])

#align(bottom + center, text([September 9, 1999]))
#v(2cm)

#pagebreak()