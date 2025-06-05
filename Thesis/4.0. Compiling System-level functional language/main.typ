#import "../Prelude.typ": ln, todo

= Compiling #ln

In this chapter we describe how #ln can be translated to something that can be
represented in an assembly language. We continue by giving a compilation scheme
for the language, and describe how the output of the scheme translates to
assembly. We then give a mapping of types to memory, and specify the
application binary Interface (ABI).

#include "Transformations.typ"
#include "Compilation Scheme.typ"
#include "Compilation Target.typ"
#include "Language ABI.typ"
