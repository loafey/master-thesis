#import "@preview/big-todo:0.2.0": *
#import "@preview/cetz:0.3.2"
#import "@preview/cetz-plot:0.1.1": plot, chart

#let stack(..args) = {
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