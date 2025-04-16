#import "Prelude.typ": todo

= Conclusion
== Future Work
As with any thesis involving the creation of a language, there
are of course more things that can be added to said language.

=== Register allocation
When optimizing the generated code, one important technique is 
utilizing the physical registers for variable allocation. #todo("source")
If one were to implement this naively, it would suffice with putting the first few variables of a 
function into registers, and the rest on the system stack.
This would however not necessarily suffice for larger functions, where one might have
more variables than registers as it might be more efficient to store a variable
declared later on as opposed to one declared early. 
To combat this, an efficient compiler should move variables back onto the stack
(a process often called spilling) when they are not used, and back into registers when they are.
Doing this efficently can prove difficult as the compiler should try to minimize
the amount of spilling needed, and this has in fact been proven to be 
NP-complete #todo("source"). This was not implemented for SLFL as it was
deemed an optimization, that while interesting, not something we had the time to
implement.

=== System Calls
As SLFL is a system-level language, it might be useful to have the ability
to directly make system calls to interact with the operating system.
This allow for the possibility of not relying on, for example, LIBC,
as the behaviour one would need from LIBC could be re-implemented
in the language. This would in theory make the language more portable, 
as it would be easier to port it to systems where LIBC might not be available.
System calls are used under the hood in the language, but it is not something
that is exposed to a user of the language.

=== Foreign Function Interface
Similarly to system calls, proper support for Foreign Function Interfaces (FFI)
would permit the language to interact with software outside. 
A prime example of this would be libraries written in other languages, 
or even libraries writen in SLFL. Just like system calls, FFI is currently 
used under the hood for printing and the likes using LIBC, but this is not
exposed to a user of the language.  

=== Exponentionals
=== Extensions
==== Data Types
== Discussion
