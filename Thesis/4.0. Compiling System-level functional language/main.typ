#import "../Prelude.typ": ln, todo

= Compiling #ln
Compiling a language is not always a straightforward path, especially so when
compiling a functional language to an inherently imperative architecture.
Even more so when the language is in question is system-level,
and control over the system is potentially needed.

In this chapter we will give the memory representation for types, we provide 
a compilation scheme for values and commands, and also describe how #ln can be
translated into something that can be represented on a machine.

#include "Transformations.typ"
#include "Compilation Scheme.typ"
#include "Compilation Target.typ"
#include "Language ABI.typ"
