== Logic
This section will introduce the reader to logic and its connection to computation in the form of functional programming through the Curry-Howard correspondence.

Logic is a formal system that uses reason to deduce truths. There are several proof systems where logic can be expressed. To prove $A$ and $B$, one has to prove $A$ and independently prove $B$. In natural deduction, this can be expressed with the following proof tree. 
$ (A quad B)/(A and B) $

This reads as: given a proof of $A$ and a proof of $B$, we can prove $A$ and $B$.
The deductions above the line lead to the conclusion below the line.
The relation with computation comes from the Curry-Howard correspondence where Curry observed that the types of combinators could be seen as axiom-schemes in intuitionistic logic @curry1934functionality. Many years later Howard made the observation that intuitionistic logic in natural deduction could be interpreted as a typed variant of the lambda calculus. The Curry-Howard correspondence is also aptly known as the proofs-as-programs and propositions-as-types interpretation.

=== Natural deduction

=== Sequent calculus

=== Linear logic