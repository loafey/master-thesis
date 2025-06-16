#import "../Prelude.typ": *

== Problem domain <Problem_domain>
System-level programming is the act of developing software that interacts directly with a computer's
hardware or provides foundational services to other software.
We will define system-level programming as Wikipedia @wiki:Systems_programming defines it:

#indent[
  - Programs can operate in resource-constrained environments
  - Programs can be efficient with little runtime overhead, possibly
    having either a small runtime library or none at all
  - Programs may use direct and \"raw\" control over memory access and
    control flow
  - The programmer may write parts of the program directly in assembly
    language
]

For system-level programming today developers mostly choose between procedural
programming languages, for instance: C, C++, or Rust. In C memory management
is manual, and in C++ there are options for automatic memory management, but
the compile time guarantees are few and weak. Rust has mostly solved the issue of
memory management by introducing an ownership model and a borrow checker @matsakis2014rust.

Although Rust offers many functional aspects, many are still missing, for
instance: _purity_ and _referential transparency_.
