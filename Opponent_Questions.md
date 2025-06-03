# Questions
- Figure 4.2: What determines the results to be "presentable"
    - What is the exit condition for the CLUE loop
- No Pre-specified Cluster Count: Is this computationally feasible? K-means is NP-hard already
- Why is DBSCAN the reference standard?
- How accurate is IP.LSH.DBSCAN compared to DBSCAN?
    - Why is DBSCAN baseline?
- How do you determine what are good values for $k$? (page 31)
- Is the number of clusters "generated" determined by the algorithm or a pre-determined value?
- Why is DBSCAN in the toolchain - it seems to be inferior to IP.LSH.DBSCAN
- Why must you copy data in DBSCAN?
- How is the curse of dimensionality not a huge problem? Expand please...

- Throughout the thesis you discuss the problems of high 
  dimensionality, specifically regarding your 96-dimension vector.
  From our understand you have two dimensions: time and consumption,
  so how and when are these vectors converted to 96d space?

- Examiner and supervisor same person??

# More nitpick questions
- What is a micro/macro benchmark?
  Google yields results about two Android app benchmarking suites.