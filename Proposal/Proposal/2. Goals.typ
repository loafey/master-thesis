#import "Prelude.typ": *

= Goals and planning
In this chapter we will go into more detail about the extensions to SLFL. We will clarify what the extensions are and explain why they are wanted.
#todo[Make sure this text is accurate]

== Compilation

The first goal of the project is to compile SLFL to native machine code.
We plan on doing this by compiling to LLVM @lattner2004llvm, which in turn can be compiled to native machine code.
LLVM provide a simple and efficient abstraction layer, compared to the native machine code alternatives. 
The Rust compiler and Clang, one of the C++ compilers both compile to LLVM, and as such, LLVM is a reliable option.

//Part of the project is compiling SLFL to be runnable natively on x86 computers.
//The current plan is to compile SLFL to either LLVM @lattner2004llvm or x86 assembly.
//The compilation target is not set in stone and will be determined during the thesis work.
//While using LLVM would be preferred due to being more user friendly to work with,
//if it is not suitable for our purposes we will most likely switch to x86 assembly.
//#green_text[An important part here is that every part of the compilation chain
//should be typed and the transformations they contain documented and explained.]

== Language extensions
SLFL is currently incomplete, and this chapter will cover some of the
extensions that we consider extending the language with. SLFL will consist of
several intermedate compilation steps, each linearly typed. As such, for every
extension we make to the language, we must also create the corresponding typing
rules .

//Currently the language is somewhat simple, and the following sections cover extensions
//to the language we want to add. As SLFL follows a formal specification,
//all of these new rules have to do so as well. For each new feature new typing
//rules and new reduction rules will need to be introduced to extend the specification.

=== Exponentials
As linear types can be quite strict, there are a few rules which allows us to 
somewhat weaken the rules, called exponentials. Exponentials values can be 
reused or remain unused. Our supervisor has proposed two alternative implementations to this:

- Implement exponentials using reference counting. This would require recursive deallocation
  of any other exponentials used in the value.

- Limit exponentials to non-linear closures, where every value allocated in the closure
  allocated using reference counting. #red_text[This closure would have an input type of the value
  we are creating an exponential of.]

If neither of these solutions work out, time will be spent on creating an alternative, as 
exponentials are quite important for flexibility when writing code.

=== Recursive and contiguous data types 
When representing more complicated data types such as different types of trees or list
in functional programming, they are almost always implemented using recursive data types.
In theory this is fine, but in practice it leads to overhead such as pointer 
indirection, bad cache locality and more. Due to this we will also investigate adding 
statically or dynamically sized contiguous types, such as arrays or vectors.

=== Laziness
#red_text[A common want for functional languages is laziness.] 
Laziness, or commonly referred to as call-by-need, means that values
and expressions are evaluated only when they are used. We will explore if
this is a feasible addition for a system-level language, and how we will integrate this
with IO, where the order of execution is important.

/*
-   what to do?
  -   Translate each construction/typing rule into code
  -   if a construction cannot be translated this way: refine it
      (design a more low-level rule which serves in an intermediate
      compilation step.)
*/
