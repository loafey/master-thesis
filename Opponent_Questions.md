# Questions
- What determines the results to be "presentable" in the CLUE loop.
    - What is the exit condition for the CLUE loop

- Why is DBSCAN the reference standard? If the goal was to benchmark IP.LSH.DBSCAN 
  sure, but the goal of the project is to: 
        "The primary objective is to develop an understanding of Göteborg Energi’s diverse customer base through clustering techniques"
    - Did you consider alternative density based clustering algorithms?

- How do you determine what are good values for $k$ om K-Distance 
  Plot Analysis?

- How do you pick a good configuration in general?
  What is a systematic approach when you are working against a dataset
  where you don't know anything about the clusters.
    - How do you pick a good configuration for the domain of GBG Energi work in?

- Throughout the thesis you discuss the problems of high
  dimensionality, specifically regarding your 96-dimension vector.
  From our understand you have two dimensions: time and consumption,
  so how and when are these vectors converted to 96d space?

- What is a micro/macro benchmark?
  Google yields results about two Android app benchmarking suites.

- In the benchmarks comparing the accuracy between DBSCAN
  and IP.LSH.DBSCAN you do not specify the average
  accuracy. What was the distribution of the results?
  - Why is DBSCAN in the toolchain - it seems to be inferior to IP.LSH.DBSCAN
  - How accurate is IP.LSH.DBSCAN compared to DBSCAN?


- The accuracy benchmarks you have presented seem to have been done 
  on dataset 4. Did you test it on the other datasets,
  and if so, what were the results?

- IP.LSH.DBSCAN mentions pointers and references as an advantage. Is this not 
  possible in DBSCAN?
