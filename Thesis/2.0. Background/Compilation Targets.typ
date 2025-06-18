// #import "../Prelude.typ": *

// == Compilation Targets
// When compiling a language, compiler commonly targets what is known as
// an intermediate representation (IR).
// The main purpose of an IR is to remove the need for a compiler to directly
// target an assembly language or machine code, meaning that compiler does not have cater
// too much towards any specific CPU and/or operating system.
// The job of actually compiling the resulting code to machine code or assembly code
// is then left to the compiler of the IR.

// There are already a lot of choices when it comes to selecting an IR for a language,
// some examples including: LLVM IR @lattner2004llvm, Cranelift @Cranelift and
// GNU's GIMPLE @Gimple. Most of these
// tend to cater toward procedural languages,
// following a traditional stack-frame based calling convention, meaning that languages
// that do not necessarily fit this mold, such as functional languages,
// can potentially suffer.


// One of the the goals of #ln is to serve as an IR, but one specifically
// caters to linear functional programming languages.

// // == Compilation Targets
// // One of the goals of #ln is to serve as a compilation target, or in other terms,
// // an intermediate representation (IR) for another linear functional programming language.

// // There are already a lot of choices when it comes to selecting an IR for a language,
// // some of which include: LLVM IR @lattner2004llvm, Cranelift @Cranelift and
// // GNU's GIMPLE @Gimple.
// // The main purpose of these IRs is to remove the need for a compiler to directly
// // target an assembly language or machine code, meaning that compiler does not have cater
// // too much towards any specific CPU and/or operating system.
// // The job of actually compiling the resulting code to machine code or assembly code
// // is then left to the compiler of the IR.

// /// OLD


// // When you are compiling your language you have to pick a target to compile it to.
// // Unless you are directly targeting machine code, most of the time
// // you want a higher level compilation target.

// // There are a lot of different choices for this task,
// // some common examples are: LLVM IR @lattner2004llvm, Cranelift @Cranelift and
// // GNU's GIMPLE @Gimple. These languages are what is known as intermediate
// // representations (IR), and they are all targeted by different compilers. They remove
// // the need for the compilers to directly target CPU specific machine code or
// // assembly. Most of the time these IRs are also cross platform, making portability easier to achieve.
// // Because the intermediate representations are higher level
// // than assembly languages are, they trade-off explicit control
// // in favor of abstractions.

// // Depending on the source language you are compiling, an IR
// // is not necessarily the most fitting option.
// // Many IRs are modeled for procedural languages, and expect
// // the source language to follow a traditional stack frame based calling convention,
// // which might not always be desired.
// // If this is the case, targeting an assembly language directly can prove more advantageous.

// // An assembly language is often as low as you can go without directly targeting
// // machine code. They are usually made to resemble machine code in text form, and
// // are tailored after CPU specific instruction sets. Personal computers and servers
// // commonly use the instruction set x86-64, which is an extension that was created
// // in 2000 based on the already popular instruction set x86 @x86WhitePaper.

// // When you directly target assembly languages, portability suffers. You not only
// // have to target different assembly languages for different CPU architectures,
// // you will also have to cater to the operating system you are targeting. For
// // instance, on a unix-like operating system, you can almost always rely on an
// // implementation of the C Standard Library (libc), or system calls if direct
// // communication with the operating system is needed. This does not apply to
// // operating systems such as Windows however, where you instead have to depend on
// // the provided system libraries to interact with the rest of the system.

// // On Windows libc availability is not a guarantee, and because they do not have
// // a stable API, it is _strongly_ recommended to avoid using system calls
// // directly. Due to reasons such as this, the simple act of printing to stdout may look
// // wildly different depending on the operating system, even though they may use
// // the same assembly language. This is something you have to consider with most
// // IRs as well, but it can be alleviated with sufficient abstractions.
