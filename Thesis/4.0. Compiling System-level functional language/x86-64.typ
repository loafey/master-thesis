== x86-64
When picking a compilation target there are always a lot of options, and for SLFL,
x86-64 was picked. While choices like LLVM IR provide a lot of benefits to the developer
in terms of development speed and convience, you 
ultimately sacrifice some control over the calling convention or memory allocation.
Due to SLFL's CPS nature, tail call optimization is a must and while LLVM provides 
tools and syntax for this a developer can not guarantee how the stack is handled when
functions are called nor how arguments are
passed to these functions. For this explicit need of control x86-64 was a fitting choice.

x86-64 is the instruction set that is most commonly utilized on modern desktop CPUs.
It features a rich set of instructions and gives developers a lot of control.

Utilizing the flexibity given by x86-64, SLFL gains a lot of control over how the calling 
convention works, and how the stack is utilized.

... 