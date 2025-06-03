# Questions
- Figure 4.2: What determines the results to be "presentable"
    - What is the exit condition for the CLUE loop
- Why is DBSCAN the reference standard? If the goal was to benchmark IP.LSH.DBSCAN sure, but the goal of the project is to: 
        "The primary objective is to develop an understanding of Göteborg Energi’s diverse customer base through clustering techniques"
    - Did you consider alternative density based clustering algorithms?
- How accurate is IP.LSH.DBSCAN compared to DBSCAN?
    - Why is DBSCAN baseline?
- How do you determine what are good values for $k$? (page 31)
- Is the number of clusters "generated" determined by the algorithm or a pre-determined value?
- Why is DBSCAN in the toolchain - it seems to be inferior to IP.LSH.DBSCAN
- IP.LSH.DBSCAN mentions pointers and references as an advantage. Is this not possible in DBSCAN?
- Why does IP.LSH.DBSCAN process high dimensional data much better?
- What is the "red flag" heuristics

- Throughout the thesis you discuss the problems of high
  dimensionality, specifically regarding your 96-dimension vector.
  From our understand you have two dimensions: time and consumption,
  so how and when are these vectors converted to 96d space?

- What is a micro/macro benchmark?
  Google yields results about two Android app benchmarking suites.

- In the benchmarks comparing the accuracy between DBSCAN
  and IP.LSH.DBSCAN you do not specify the average
  accuracy. What was the distribution of the results?

