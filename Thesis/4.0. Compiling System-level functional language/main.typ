#import "../Prelude.typ": ln, todo

= Compiling #ln

An important aspect of a system-level language is the representation of types
and values. We want the language to be efficient, and thus, the representation
must match the computer's representation of memory. For instance, in many
functional programming languages values are boxed, i.e, placed behind pointers.
In a system-level language this would be counter-productive because the control
over memory should be in the hands of the developer. 

In this chapter we will give the memory representation for types, we provide 
a compilation scheme for values and commands, and also describe how #ln can be
translated into something that can be represented on a machine.

#include "Transformations.typ"
#include "Compilation Scheme.typ"
#include "Compilation Target.typ"
#include "Language ABI.typ"
