#import "@preview/dashy-todo:0.0.1"

#let debug = true
#let todo = if debug {dashy-todo.todo} else {(..) => {}}

#let bigTodo(content) = box(
  fill: red, 
  inset: 30pt,
  width: 100%,
  align(
    center,
    text(fill: white, size: 30pt, [TODO: #content])
  )
)

#let indent(content) = grid(
  columns: (10pt, 1fr),
  rect(height: 100pt, fill: tiling(size: (12pt, 10pt), [
    #place(line(stroke: rgb(0,0,0,65),start: (0%, 0%), end: (100%, 100%)))
    #place(line(stroke: rgb(0,0,0,65),start: (0%, 100%), end: (100%, 0%)))
  ])),
  content,
  inset: (left: 16pt)
)

#let drawStack(..args) = {
  let ags = ();
  let count = 0;

  for (i,value) in args.pos().enumerate() {
    if count == 1 {
      ags.push([])
      ags.push([])
      ags.push([])
    }

    let container = if count == 1 {
      let a(b) = align(center, b); a
    } else if count == 0 {
      let a(b) = align(right, box(inset: (right: 4pt),b)); a
    } else {
      let a(b) = box(inset: (left: 4pt), b); a
    }
    ags.push(container(value))
    if count == 2 {
      ags.push([])
      ags.push([])
      ags.push([])
    }
    count = calc.rem-euclid(count + 1, 3);
  }

  let frame(stroke) = (x, y) => (
    left: if x == 1 { stroke } else { 0pt },
    right: if x == 1 { stroke } else { 0pt },
    top: if x == 1 and calc.rem-euclid(y, 3) == 0 { stroke } else { 0pt },
    bottom: if (x == 1 and calc.rem-euclid(y, 3) == 2) { 
      if y + 1 == args.pos().len() {
        (paint: stroke, thickness: 1pt, dash: "dashed") 
      } else {
        stroke 
      }
    } else { 
      0pt 
    },
  )
  let rows = ()
  for i in args.pos() {
    rows.push(0.7em)
  }
  table(
    stroke: frame(rgb("000")),
    columns: (1fr,1fr,1fr),
    rows: rows,
    inset: (),
    gutter: 0pt,
    ..ags
  )
}

#let options(options_list) = {
  text(size: 20pt, fill: green)[_Options_]
  linebreak()
  let i = 1
  for option in options_list {
    (
      text(fill: green, str(i) + ". ")
        + par(first-line-indent: 1em, hanging-indent: 1em)[#option]
    )
    linebreak()
    linebreak()
    i += 1
  }
}

#let red_text(txt) = text(fill: red)[#txt]

#let green_text(txt) = text(fill: rgb(0, 125, 0, 255))[#txt]

#let judge(above, below, note: "", display_note: false) = {
  if note == "" or not display_note {
    $#above / #below$
  } else {
    $#above / #below$
    $space$
    text(size: 10pt, emph(note))
  }
}

#let tack = { $space tack$ }

#let angled(t, a) = { $angle.l #t, #a angle.r$ }

#let int = { math.italic("int") }

#let sp = {math.italic("sp")}
#let ssp = {math.italic("ssp")}
#let push = {math.italic("push")}
#let pop = {math.italic("pop")}
#let jmp = {math.italic("jmp")}
#let newstack = {math.italic("newstack")}

#let meta(t) = {
  $\"#t\"$
}

#let sem(t) = {
  $bracket.l.double #t bracket.r.double$
}

#let compilation_scheme(t) = $#sem[$#t$]$

#let code_box(..t) = {
  let txt = t.pos().join($\ $)
  box(baseline: 50%, fill: rgb("EEEEEE"), stroke: none, inset: 8pt, $txt$)
}

#let code_block(lbl,..t) = {
  let txt = t.pos().join($\ $)
  $lbl$
  ": "
  box(baseline: 80%, fill: rgb("EEEEEE"), stroke: black, inset: 8pt, $txt$)
} 
