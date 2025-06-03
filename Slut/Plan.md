== Introduction
    Introduce thesis, ourselves
    Acknowledge JP, Patrik
    Justification: Functional language for system-level programming
    Problem 1: Immutability => "copy-on-write" => potentially worse performance.
    Problem 2: Closures capturing heap-allocated memory => requires copying or prohibit capturing such memory ala Rust
    Solution: Linear types/linear logic: must use variable _exactly once_, can mutate memory, can capture heap-allocated memory, 

== Lithium
    Goal: Fast, Safe (type- and kind-checked), Intermediate language for linearly typed (functional) languages
    
    1. What is assembly
        stack: known size values on it
        SP - stack pointer
        CP - code pointer
        label

    Feature 1: Continuation-passing style - what is it, what do we gain
    Types, values, kinds... 
=== Values
    ...    
=== Commands
    - let pat = command 
    - case value of 
        inl pat -> command
        inr pat -> command
    - z(v)

    NOTE: commands are only terminated by a call i.e guaranteed tail call

=== Kinds
    - ω = stack
    - ❶ = thing on stack with known size
=== Types
    - *A = label
        - goto programming
    - ◻A: ❶ == pointer to stack
    - ○: ω == empty stack
    - A ⊗ B: ❶ == unboxed tuple
    - A ⊗ B: ω == stack B with A on top
    - A ⊕ B: ❶ == tag tupled with A or B
    - A ⊕ B: ω == tag on the stack A or B
    - ∃α. A: ❶ == A
    - ∃α. A: ω == A
    - ~ A == ?? we know A : ❶ and ~ A : ω
        - procedure programming
        - procedures are not native to assembly
    - ¬A == ?? we know A : ❶ and ¬A : ❶
        - higher-order programming
        - definitely not native to assembly

=== Transformations
