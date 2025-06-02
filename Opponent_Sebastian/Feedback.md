IM ON PAGE 45

# Questions
- Figure 4.2: What determines the results to be "presentable"
    - What is the exit condition for the CLUE loop
- No Pre-specified Cluster Count: Is this computationally feasible? K-means is NP-hard already
- Why is DBSCAN the reference standard?
- How accurate is IP.LSH.DBSCAN compared to DBSCAN?
- How do you determine what are good values for $k$? (page 31)
- Is the number of clusters "generated" determined by the algorithm or a pre-determined value?
- Why is DBSCAN in the toolchain - it seems to be inferior to IP.LSH.DBSCAN
- Why must you copy data in DBSCAN?

- Examiner and supervisor same person??

# Thoughts
- There a lot of defintions to digest in 2.0. After finishing this section I definitely hope everything is relevant
- 3.6 very good section to include, nicely done!
- Remove quotations around: "elbow point" and "red flag"
- Graphs on page 47 are somewhat broken

# Text nitpicking
- The parameter selection is critical, as inappropriate ... >> The parameter selection is critical, because inappropriate ...
- Indentation in Pseudocode 2.1 is a bit confusing. I assume it is used to denote "blocks", but then the indentation under the If is strange
- Since this algorithm is guaranteed >> Because this algorithm is guaranteed
- lose effectiveness [39], as even ... >>  lose effectiveness [39], because even ... 
- while the exact measurement at 02.00 >> while the same measurement at 02.00 
- Text under 4.2 Core Components could perhaps spoil the sub-chapter a bit, so that I (the reader) know what to expect.
- page 32: "For each parameter combination, the framework executes clustering through IP.LSH.DBSCAN calculates quality metrics, which will be explained in greater detail in the coming section, to evaluate the results"
- as it utilizes minimum and maximum distances >> because it utilizes minimum and maximum distance
- as it can handle arbitrary >> because it can handle arbitrary
