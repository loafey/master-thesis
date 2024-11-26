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
