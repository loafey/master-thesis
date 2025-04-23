== Continuations
A design pattern in functional programming is Continuation Passing Style.
In this design pattern, instead of functions simply returning a value, 
they must take an extra argument which is a function which will operate on the resulting value.
This means that instead of writing the program in the traditional way, where you call functions
and simply act on the result, functions are instead used to describe computation chains.

#figure(
  caption: [Fibbonacci written "traditionally" (left) and using continuation passing style (right)],
  grid(columns: (1fr,1fr),
    ```hs
  fib :: Int -> Int
  fib x = case x > 2 of
    True  -> do
      a <- fib (x - 1)
      b <- fib (x - 2)
      a + b
      False -> x
      ```,
    ```hs
  fib :: (Int -> a) -> Int -> Int
  fib k x = case x > 2 of
    True  -> do
      fib (x - 1, \a ->
      fib (x - 2, \b -> 
      fib (a + b, k)
      ))
    False -> k x
    ```,
  )
)<fibbonaci>

As can be seen in @fibbonaci 

// 
// SLFL makes heavy use of this pattern, in fact, it requires it for all functions.
// This might sound like a problem, but in fact functional programs can be easily converted
// into this design pattern #todo("source here"), and in addition, this comes with benefits, such
// as allowing for easy tail call optimization as we never need to return to a previous 
// stack frame #todo("source here").