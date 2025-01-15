== System-level Functional Language (SLFL)
The point of our thesis will be to create a compiler for a SLFL

We want to add several higher level concepts such as:
- Closures\
  - Allows lambas to capture variables from their environment
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
  Programs will be written in another system-level language (C etc)
  and SLFL\
  Results will be compared based on execution time and memory usage

- Binary size: \
  Small binaries are good for portability\
  Our thesis will not focus a lot on this, but it is an interesting metric nonetheless 
