#import "../Prelude.typ": *
#import "../Figures.typ": *

= #ln

== Kinds

#ln has two kinds

$#math.italic[Kind] : : = omega | known$

- $omega$ is called Stack

- $known$ is called Known Size

#let frame(stroke) = (x, y) => (
  left: stroke,
  right: stroke,
  top: if y == 0 { (dash: "dashed") } else { stroke },
  bottom: if y == 3 { (dash: "dashed") } else { stroke },
)

#align(center, stack(
  dir: ltr,
  spacing: 0.5em,
  $omega space lr(\{ #v(9em))$,
  table(
    stroke: frame(rgb("000")), columns: 10em, rows: (
      2em,
      2em,
      2em,
    ), inset: 0pt, gutter: 0pt,
    [#align(center + horizon, $known$)],
    [#align(center + horizon, $known$)],
    [#align(center + horizon, $known$)],
    [#align(center + horizon, $known$)],
  ),
))


== Types

$A,B & ::= fatzero              &           #[empty] \
    & space | fatone           &            #[unit] \
    & space | circle           &     #[empty stack] \
    & space | alpha            &   #[type variable] \
    & space | not A            &  #[linear closure] \
    & space | ~ A              &   #[stack closure] \
    & space | * A              & #[static function] \
    & space | square A         &  #[linear pointer] \
    & space | A times.circle B &         #[product] \
    & space | A plus.circle B  &             #[sum] \
    & space | exists alpha. A  &          #[exists] \ $

== Types

\

#align(
  center,
  $A,B & ::= fatzero | fatone
        | circle
        | alpha
        | not A
        | ~ A
        | * A
        | square A
        | A times.circle B
        | A plus.circle B
        | exists alpha. A$,
)

=== Kind rules for types
#align(center + horizon, kind_judgements)
