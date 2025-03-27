#import "@preview/dashy-todo:0.0.1": todo

#let options(options_list) = {
  text(size: 20pt, fill: green)[_Options_]
  linebreak()
  let i = 1
  for option in options_list {
    text(fill: green, str(i) + ". ") + par(first-line-indent: 1em, hanging-indent: 1em)[#option]
    linebreak()
    linebreak()
    i += 1
  }
}

#let red_text(txt) = text(fill: red)[#txt]

#let green_text(txt) = text(fill: rgb(0, 125, 0, 255))[#txt]

#let judge(above, below, note: "") = {
  $#above / #below$
  $quad$
  note
}

#let tack = { $space tack$ }

#let angled(t, a) = { $angle.l #t, #a angle.r$ }

#let int = { math.italic("int") }

#let sem(t) = {
  $bracket.l.double #t bracket.r.double$
}

#let compilation_scheme(fragment, kind, t) = $""^fragment #sem[#t]^kind$

#let code_box(t) = {
    box(baseline: 100%, stroke: black, inset: 8pt, t)
}
