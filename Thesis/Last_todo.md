## Typos:
*FIXED* - 1. general: you mix "cannot" (3 times) and "can not" (6 times). Please stick with the former.
*FIXED* - 2. p4: "Static anaysis":= "Static analysis"
*FIXED* - 3. p5: "can be traced back the use" :=
                 "can be traced back to the use"
*FIXED* - 4. p5: "a system-level level language" :=
                 "a system-level language"
*FIXED* - 5. p8: "the the polymorphic identity function." →
                 "the polymorphic identity function."
*FIXED* - 6. p10: "left-side of the turnstyle" :=
                  "left-side of the turnstile" 1. one more use on the next line
*FIXED* - 7. p10: "is show in" := "is shown in"

## More comments:

*FIXED* - 8. Fig. 5: The final term seems to lack parentheses: "/\ a. \x:a.
            x y" would be interpreted as "/\ a. \x:a. (x y)" which is a type error. I think
            you mean "(/\ a. \x:a. x) y". But I'm also not sure about the rule before that:
            are both the term and the context really unchanged when getting rid of the
            Forall in the type? Following TApp from Fig. 3 you would get "(/\ a. \x:a. x)[A]" 
            owhich I guess reduces to "\x:A. x".
*FIXED* - 10. 3.1:
*FIXED* - 11. "To clarify further, the body of the lambda 𝑘((𝑦, 𝑥)) corresponds to the command 𝑐, in this case a function call. 𝑘 corresponds to the 𝑥 in 𝑥(𝑣), and (𝑦, 𝑥) is 𝑣." :=
              "In this case, the body k((y, x)) is a function call, which corresponds to a command in Lithium. The continuation k takes the reordered pair as input."
12. 3.2 Kinds & types
  *FIXED: Reworded* - 13. "It is forbidden to construct a pair of two stacks": I don't understand
      what this means. I see that the rules requires the first type in the pair
      type to be of kind "circle 1", but I lack intuition for why of what that
      may entail.
*FIXED: Hopefully fixed. We agree that this bit should have been postponed, but JP really wanted the low level explanation here* - 14. "The goto style": I don't understand what "capture state" and "the state
      that *B manipulates" means. I'm not used to read off "state manipulation"
      from lambda terms. Perhaps you need to delay this explanation, or expand
      it with more concrete examples. I'm still at the "kind level" in the
      reading, and have a hard time imagining pointers, gotos, etc.
    1. Explain "capture state" somewhere. It is definitely not something a type
       can do, but possibly something a lambda term or closure can do. 
*FIXED: Rewrote that it is the stack shape for the type* - 
    1. You have added a Fig. 11 but that is still confusing: two boxes
       containing types is not what I would call a "stack". Perhaps you mean
       that the "shape" or the "type" of the stack is shown, and that the
       actual "stack values" would contain some data of type A on top of some
       of type *B?
      Also, the caption could perhaps be "Illustration of the stack layout for the type 𝐴 ⊗ ∗𝐵 ⊗ ○."

*FIXED* - 15. Using a star/asterisk as a prefix operator (instead of infix) causes some
          reading challenges for me. I think you need to help a bit with spacing:
          make sure the prefix operators are "tightly connected" the the only
          operand: instead of "∗ (𝐴 ⊗ ∗ 𝐵 ⊗ ∼ 𝐶)" I would like to see "∗(𝐴 ⊗ ∗𝐵
          ⊗ ∼𝐶)".

*FIXED: Rewrote using stack terminology* - 
   16. "a stack that accepts 𝐵 as a return value to continue with": I'm lost
      here. I know what "stack" means normally as a datastructure, but
      a datastructure does not "accept" anything as a "return value".
    1. Please use "stack" in a way which matches one of the traditional
       meanings: either an abstract datatype (or a value of that datatype), or
       a call stack (often represented as a region in memory).

*FIXED* - 17. "the higher-order function: ∗ (𝐴 ⊗ ¬𝐵 ⊗ ∼ 𝐶)": I don't know _what_ higher
              order function you mean to write, or how this string of symbols is
              supposed to represent it.
    1. To clarify my question further: please make sure to clearly separate the
       use of "function" (which should be an actual function) from "function
       type" or "type for the representation of a function" or so.

## 4 Compiling Lithium

18. *FIXED* - You have added more explanations of the "compilation pipeline" which is
    good. However, the remark "At this stage Lithium is still a calculus" is still
    confusing, as it soggests that the language/calculus itself will change, rather
    than the expresions being transformed. My understanding now (and what you write
    in the text) is that the Lithium languge does not change as you go through this
    section. But you also have references to "this stage" and "turn Lithium into
    ..." which clash with the rest of the explanation. I think what you transform
    are expressions in the language, not the language itself. Perhaps something
    along these lines: "What we have explained so far, is Lithium as a lambda
    calculus. We now explain how general Lithium expressions can be transformed
    into a sublanguage which can then be mapped to assembly."
19. 4.1 Transformations
  20. *UNCHANGED: Because it is only a sublanguage now this should be fine. Technically yes, you could remove ¬, but if you want to write normal higher-order programs it's nice for ergonomy* - 
      "Because the type ¬𝐴 is transformed ... the type checker should allow
      □ ∼ 𝐴 where ¬𝐴 is expected": I don't see why this is the case. You should
      be able to think about the language before and after translation as two
      slightly different sublanguages, which may require different typing
      rules, but allowing any mix of the two seems "dangerous". And if these
      two types are equal, why have both in the (type) language?

  21. *UNCHANGED: Yes the environment ends up ill-kinded and we have written exactly that* - 
      "end up being ill-kinded": the story-line seems a bit strange: you say
      that 4.1.2 shows how to transform the types to keep them well-kinded. But
      then the closures don't "end up being ill-kinded" after all. Perhaps you
      meant to motivate why the 4.1.2 transformation is needed? Also, given
      that you have just done a (somewhat strange) change to the type checker
      to treat □ ∼ 𝐴 and ¬𝐴 as equal, couldn't you also "just" add an extra
      rule to the kind-checker as well [which I don't recommend]. Please
      explain.

  22. *BUG FIX (incorrect type): I don't know what to change given the feedback. I agree that it is a bit hard to follow, but there is only one moving part: the let-bind* - 
      4.1.2 is still hard to get. You provide one example + explanatory text,
      but it is hard for at least this reader to see what the transformation is
      actually doing because of the many "moving parts" (let, box,
      continuation, types, kinds).

  23. *FIXED* - 4.1.3: is still difficult to follow:
    24. *FIXED* - In the example with Gamma, it says that unpairAll is a macro, and we
        can see that it takes rho as its only argument. Now rho is lambda
        bound, thus not statically known. So the explanation of how
        unpairAll(rho) expands into a few lets is really confusing as it
        (unpairAll) can not know what rho is. I guess you mean that unpairAll
        takes _Gamma_ as its main argument, and then a variable name (here
        rho).
    25. *FIXED* - Also in the same example, the name "x" bound together with rho will be
        shadowed by the first let. How is this supposed to work?

*26. SMALL CHANGE: If we don't allocate a stack then we have no stack to execute on, and if we don't deallocate it then we have a memory leak.*
        This example is hard for me to parse: "⟨○, (𝜆∗ (𝑥, 𝜌1 ). freestack 𝜌1
        ; foo(𝑥), 𝑛𝑒𝑤𝑠𝑡𝑎𝑐𝑘)⟩". Also the explanation is confusing: "Now the
        environment is a new empty stack, and we free it before calling the
        static function foo()": it seems a bit strange to create a stack and
        then directly(?) free it.
27. 4.2 Compilation Scheme

*28. UNCHANGED: That would be an implementation error. For instance, in the stack
      variables. We know that the list is guaranteed to be a singleton because
      a stack is represented by a singler register with the address to it.
      We can see the pattern matching as invariants that must hold.*

      28. The long figures look impressive, but I'm a bit worried about the
      "pattern matching" on things like "𝜌,𝑧↦[𝑟0]": what happens if the list
      that z maps to is not a singleton list? This occurs in at least "Stack
      variable" (what if that variable is stored in more than one register?),
      Pop top of stack, Following an indirection, Stack deallocation, case
      expression, Function call, ...
  29.       
*FIXED* 30. 4.4. Language ABI
  *FIXED* 31. Product type: "⟦𝐴⟧M 1. ∞"?? ∞ = inf is not in ℕ=Nat. And also, if you
      mean Nat1. = Nat `union` {inf}, then (forall x. x + inf = inf) which
      means that any rule involving "+ inf" should be simplified. Similarly
      with "Word + inf" later.
  *FIXED* 32. From page 35 (later on) it looks like intend to keep track of the fact
      that "n + inf" is in the interval [n,inf). If that is what you intend,
      you need to adapt your type (from Nat, or Nat1.) accordingly (to an
      interval, or an expression type in one unknown called inf, or ...).
*FIXED* 33. 5.1.1:
  *FIXED* 34. Fig. 26: there seems to be a "," above "the" in the caption.
35. 5.2.5:
  *FIXED* - 36. The second call to __eq__ should have (n,1) as input, not (n,0).
  37. (Optional: Also, the natural construct here would "split" the n into inl
      () if n==0 or inr n' if n==n' + 1. With that, there would only be two
      uses, as expected from the two recursive calls.)
  *FIXED* 38. Using "a + b = z" to mean that a = z and b = z is very confusing. Please change. Perhaps "a = b = z"?
