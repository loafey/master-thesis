* fix the kind system. suggestion: just 2 kinds and adapt the rules (pay attention to type variables and kind variables)
    * add the "types and kinds" summary, with more commentary:

    * higher order (ok)
    * goto (see below)
    * procedural: (for ~A with omega environment) ~A is a stack frame that accepts A as a return value. Because the environment is itself omega; this means that there is a single chosen substack to continue with from that closure.

* Goto programming with *:
* f : *(A⊗*B)?
* From f you can call the *B continuation, but itself cannot have "saved" local variables in an 
  environment (its stack). It can only use the state (B)

* Procedural programming with * and ~:

* The C function signature
* B f(A x)

* corresponds to:
* f : *(A⊗~B)

* note that the type *(A⊗~B⊗~C) is ill-kinded. So with * and ~ you cannot support co-routines or higher-order programming

* Stack selection: about selecting the main thread.
* Lambda Compilation:
      as for all types, positive and negative must match. lambda and call must match.
      explain the role of the stack; that that the positive fragment compiliation pushes the argument on the stack. (call!)
      lambda: prepare the stack, and compile the body
