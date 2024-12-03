== System-level Functional Language (SLFL)
The point of our thesis will be to create a compiler for a SLFL

While the language is a system-level language, we want to add 
several higher level concepts such as:
- Closures\
  - Allows lambads to capture variables from their environment
      ```hs
      fun :: Int -> (Int -> Int)
      fun x = \y -> x + y -- x is captured here
      ```

- Records\
  - Data types with named fields. Pretty simple

- Recursive & Contiguous Data Types \
  - Trees, linked lists etc and Vectors/Arrays

- Laziness

== How will the language be evaluated?
Objectively evaluating languages is hard, but some things can be done!

- Performance: \
  Simple programs will be written in another system-level language (C etc)
  and SLFL\
  Programs will be compared based on execution time and memory usage

- Binary size: \
  A system-level language should ideally produce small binaries for portability\
  Our thesis will not focus a lot on this, but it is an interesting metric nonetheless 
