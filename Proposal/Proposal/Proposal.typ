#import "@preview/dashy-todo:0.0.1"
#set text(font: "New Computer Modern", size: 12pt)
#set page(margin: 1.4in)

#include "0. Splash.typ"
#include "1. Intro.typ"

// More features
/// Exponentials
/// Records
/// Recursive data types
/// Laziness
#include "2. More Features.typ"
 
// Compilation
/// How it differs from previous work (Nordmark)
//// Nordmarks Special Purpose VM
//// using Nordmark's VM as an intermediate language goes against Principle 1.
/// what to do?
//// Translate each construction/typing rule into code
//// if a construction cannot be translated this way: refine it
//// (design a more low-level rule which serves in an intermediate
//// compilation step.)
#include "3. Compilation.typ"


#bibliography(title: "References","../bib.bib")