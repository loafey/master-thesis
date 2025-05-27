#import "../Prelude.typ": todo

== Compilation Targets
When you are compiling your language you have to pick a target to compile it to.
Unless you are directly targeting machine code, most of the time
you want a higher level compilation target.

There are a lot of different choices for this task, 
some commons examples are: LLVM IR @lattner2004llvm, Cranelift @Cranelift and
GNU's GIMPLE @Gimple. These languages are what is known as intermediate
representations (IR), and they are all targeted by different compilers. They remove
the need for the compilers to directly target CPU specific machine code or
assembly. Most of the time these IRs are also cross platform, making portability easier to achieve.
Because the intermediate representations are higher level 
than assembly languages are, they trade-off explicit control over assembly code
in favor of abstractions.

Depending on the source language you are compiling, an IR
is not necessarily the most fitting option.
Many IRs are modeled for procedural languages, and expect
the source language to follow a traditional stack frame based calling convention,
which might not always be desired.
If this is the case, targeting an assembly language directly can prove more advantageous.

An assembly language is often as low as you can go without directly targeting
machine code, and they are almost always made to resemble CPU instructions closely.
These assembly languages are tailored after CPU specific instruction sets,
and one of these instruction sets is x86-64, which widely used in
personal computers and servers.
It is an extension that was created in 2000 based on the already popular
instruction set x86 @x86WhitePaper.

When you directly target assembly languages portability suffers as is to
be expected. You not only have to target different assembly languages
for different CPU architectures, you will also have to cater to the operating system
you are targeting. For instance, on a \*nix based operating system, you can almost
always rely on some implementation of the C Standard Library (libc), be it glibc or musl,
or system calls if more power is needed.
This does not apply to operating systems
such as Windows however,
where you instead have to depend on the provided system libraries to interact
with the rest of the system.
On Windows libc availability is not a guarantee and system calls are to be avoided, as
they do not have a stable API.
Due to reasons such as this, a simple act such as printing might look wildly different
depending on the operating system. Even though they might use the same
assembly language, they can involve extremely different calls to the operating system.
This is something you have to consider with most IRs as well, but it can
be alleviated with sufficient abstractions.
