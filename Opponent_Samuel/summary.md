# 1 Introduction
Utilizing clustering to summarize and categorize behavior 
of electrical consumers.

## 1.1 Motivation
Göteborg Energi wants to be able to better understand the data
they collect, as to enhance customer segmentation, improving demand forecasting and identifying opportunities for grid optimization.

## 1.2 Clustering as Exploratory Analysis
Clustering = Exploratory analytical approach\
Clustering can be used to find relationships that were not 
predefined nor even suspected.

This can reveal customer segments that reach across traditional classification schemes based on industry or contracts.

## 1.3 Contributions
The thesis presents CLUE, a framework for data analytics
with a focus on flexibility and interchangeability.
Supposed to work over different domains (?).

The thesis also presents a new (?) density-based algorithm 
which has performance improvements over traditional clustering
algorithms.

Toolchain converts raw temporal data into meaningful attributes.
It enables enhanced customer segmentation, peak demand analysis, and
informed decision-making.

## 1.4 Overview
It is an overview :).

# 2 Background
## 2.1 Clustering in Data Mining
Clustering = organize objects into groups where the
objects have high similarity to each other
but low similarity to other object clusters.

This is an unsupervised approach, making it effective
for large sets of unlabaded data.

### 2.1.1 Overview of Clustering Approaches
_Partitioning methods_: put objects into non-overlapping subsets.
K-means and k-medoids are classic implementations of this.
Requires that you specify the amount of clusters.

_Density-Based Methods_: define clusters as dense regions of 
objects separated by areas of lower density.
DBSCAN is one such example (and is used in the thesis).
Does not require that you specify a number of clusters and it can
identify outliers.


### 2.1.2 Challenges in Modern Clustering Applications
_High-Dimensional Data_: data with a lot of elements
in data points (i.e large vectors)
leads to less distance measures between values becoming less
descriptive.

_Time Series Data_: Time series vectors produce difficulties
due to variable lengths (?), presence of noise, and potential
shifts in time and amplitude. This is hard for 
traditional clustering algorithms to capture.

_Scalability Issues_: a lot of data sets are massive 
(emergence of big data (?)) and a lot of cluster algorithms have
quadratic or higher computational complexity making them
impractical for large sets.

This problem is amplified for time series vectors which 
tend to be high-dimensional.

## 2.2 Density-Based Clustering Approaches
Goes into more detail about density-based clustering.

### 2.2.1 Concepts of Density-Based Clustering
_Core Points, Border Points and Noise_: A core point
contains a minimum number of points 
within a specified radius (ε, MinPts).
A border point falls in the neighborhood of a core point
but lacks enough neighbors (MinPts).
Points that fall outside these two classes are noise.

_Density Connectivity and Reachability_:
Two points are directly density-reachable if one
is a core point and the other lies within its neighborhood.
Density Connectivity and Reachability extends this concept
with chains of directly density-reachable points.

### 2.2.2 Density-Based Spatial Clustering of Applications with Noise (DBSCAN)
Defines clusters as dense regions of 
objects separated by areas of lower density.

(once again explains ε and MinPts)

The Parameter selection (of ε and MinPts?) is critical as 
otherwise you can get bad results. 

Time complexity is O(n²) where in is the number of data points.

### 2.2.3 Integrated Parallel Density-Based Clustering through Locality-Sensitive Hashing (IP.LSH.DBSCAN)
An improvement upon DBSCAN.
Combines indexing and clustering into one process, which is two
in DBSCAN, and it is parallel. 

_Locality-Sensitive Hashing (LSH)_: normally
hash functions aim to spread data evenly across buckets,
but this is designed to place similar items into the same bucket.
The more similar two data points are, the higher probability
they will has to the same value.

LSH can do this with two different methods:
- For Euclidean distances: functions project data onto random directions
  and divide the resulting line into segments.
- For Angular distance: functions create random hyperplanes
  and determine which side of the hyperplane the points fall on.

_Core principles and Innovations_:
1. Fusion and indexing and clustering.
2. Core point representation: each bucket contains at least MinPts
   elements that identify a candidate core-point, which is the closest point
   to the centroid of all points in the bucket.
3. Neighborhood queries operate on buckets which reduce computational
   complexity.

_Algorithm Structure and Phases_:
Four phases:
- Hashing and bucketing using LSH.
- Find a representative points, selects the point closes to the centroid of 
  all points.
- For each bucket identify pairs of core points and merge them in the core 
  forest (?).
- Labeling phase. Points that fall outside a core point neighborhood is marked 
  as noise.

_Parallelization Strategy_:
The algorithm is parallelized.

## 2.3 Partitioning-Based Clustering (K-Means)
K-means is a classic clustering problem, where you find k clusters.

## 2.4 Time Series Data Analysis
### 2.4.1 Representation Methods for Time Series Data
Can be represented using a Feature-based representation and
a Raw-data-based representation.
### 2.4.2 Raw-data-based
Data is not transformed, and original information
is preserved. This can lead to high dimensionality which
in turn leads to increased computational costs.

This is good for when the exact shape and timing of
time series are crucial for clustering.
Shape-based distance measures such as Dynamic Time Warping (DTW)
work well with this. 

### 2.4.3 Feature-based
Here you extract features on the raw data and create feature vectors to
do the clustering on. Features correlate with the raw data
but can take different forms. This can be used to reduce dimensionality,
leading to less computational usage. This can however lead to a loss 
of quality.

### 2.4.4 Dimensionality Challenges in Time Series
There are several ways to reduce the dimensionality in data.

_Principal Component Analysis (PCA)_:
PCA transforms time series data into
a new coordinate system where the most significant
variances are captured by the first coordinates.

_t-Distributed Stochastic Neighbor Embedding (t-SNE)_:
t-SNE, introduced
by van der Maaten et al., transforms high-dimensional data to lower dimensions
while preserving local neighborhood structures. Unlike linear models 
such as PCA, 
t-SNE eﬀectively preserves cluster structures in complex datasets. 

_Uniform Manifold Approximation and Projection (UMAP)_:
UMAP, developed by McInnes et al., 
addresses many of t-SNE's limitations while maintaining
similar visualization quality. UMAP's construction involves building a 
weighted k-neighbor graph as a fuzzy topological representation of the 
high-dimensional data,
then optimizing a low-dimensional layout that best preserves this topological 
structure through stochastic gradient descent.

## 2.5 Evaluation Methodology
### 2.5.1 Internal Validation Measures
### 2.5.2 External Validation Measures

# 3 Problem Definition
## 3.1 Case Study: Göteborg Energi AB
Göteborg Energi wants to improve the analytics and management for the following:
- Grid Capacity, as they see an upcoming rise in demand
- Peak Demand Management, as they want to see which customers contribute to peaks
  and the behavioral patterns.
- Customer Behavior Knowledge, as similar behaviors can be seen across different
  business types, while variations can exist within the same types.

The primary objective of the thesis is to understand Göteborg Energi's
customer base through clustering.

This segmentation would enable Göteborg Energi to:
- Identify customer groups with similar consumption that span industry boundaries
- Recognize emerging consumption trends that might indicate shifts in business
  operations or energy usage
- Establish baseline behavioral profile, against which future consumption patterns 
  can be compared
- Understand the diversity of consumption patterns within traditional customer
  categories
- Utilize specialized communication with their customers on a large scale by the
  use of cluster statistics

## 3.2 High-Dimensional Time Series Clustering Challenges
Repeat: about how time series is hard to work with due to high dimensionality.
### 3.2.1 Dimensionality Effects on Distance Metrics and Computation
Repeat: about why high dimensionality is hard to work with.
Their data is very high dimensional.

### 3.2.2 Temporal Dependencies and Structure
Repeat: why temporal data is hard to work with.

## 3.3 The Parameterization Problem
Repeat: why parameter choice is important to work with.

## 3.4 Feature Engineering vs Raw Data Approaches
Repeat: about this.

## 3.5 Computational Efficiency vs Accuracy
IP.LSH.DBSCAN is faster than DBSCAN but results in 
less accurate results.

## 3.6 Domain Knowledge
If you are technical you might not know what you are analyzing but you how to analyze it,
but if you know what you are analyzing you might not know how to analyze it :).

## 3.7 Refined Problem Statement
How can we develop a flexible, computationally efficient approach for clustering high-dimensional time series data that balances analytical accuracy
with practical interpretability, while accommodating domain-speciﬁc requirements 
and the expertise gap between data scientists and domain experts?

This problem statement can be broken down into four distinct sub-problems:
- Efficient High-Dimensional Clustering: Implementing clustering approaches
  that scale eﬀectively with the quantity and dimensionality of time series data.

- Automated Parameter Optimization: Developing strategies to identify
  appropriate clustering parameters without requiring extensive manual tuning.

- Usage Flexibility: Allowing selections and combinations of algorithms and
  features to fit a variety of uses.

- Interactive Exploration: Enabling rapid exploration of clustering results
  to support iterative refinement and insight generation.
  In the following chapters, we present our CLUE toolchain as a solution to these
  problems, demonstrating its application to electricity consumption data while 
  highlighting its flexibility for other time series analysis tasks.

# 4 CLUE Toolchain Architecture
This chapter could be heavily shortened down.
It is a lot of repeated theory.

## 4.1 Overview and Design Goals
CLUE is a framework that lets you temporal vector data.
It tries to address the following: 
- The computational complexity of high-dimensional clustering
- The difficulties in parameter selection
- The need to bridge the gap between algorithmic capabilities and domain expertise


The toolchain consists of three primary components that can be independently 
configured and interchanged:
1. Clustering Algorithms
2. Distance/Similarity Metrics
3. (Optional) Parameter Optimization / Feature Standardization

In the pipeline clue is looped (?) until we are finished using
different clustering algorithms and distance similarities 
(I guess this is cluster strategies?).

## 4.2 Core Components
### 4.2.1 Clustering Algorithms
While CLUE offers many different clustering algorithms it primarily
uses density-based methods for several reasons (this is a repeat):
- Arbitrary Cluster Shapes: density-based approaches can identify arbitrary shapes
  as opposed to K-means.

- Automatic Noise Detection: Density-based methods are good at removing outliers and noise.

- No Pre-specific Cluster Count: we don't need to specify the amount of clusters.

Repeat: info about DBSCAN, IP.LSH.DBSCAN and K-means.

### 4.2.2 Distance/Similarity Metrics
Explains Euclidean/Angular Distance and distance in a better way
than done in theory?

DTW is new.

### 4.2.3 Parameter Optimization
Using IP.LSH.DBSCAN you can do parameter analysis faster :)
Crucially this can only be done due to examinator's algorithms exceptional speed.
- K-Distance Plot Analysis
- Grid Search Framework
- Internal Cluster Quality Metrics

### 4.2.4 Feature Standardization
CLUE separates feature engineering to clustering.
Data is normalized as to avoid large numbers dominating the clustering process.

# 5 Evaluation
## 5.1 Evaluation Methodology
Evaluates performance metrics and quality assessment techniques and application-specific
validation methods.
### 5.1.1 Technical Performance Metrics
To test performance and latency the following tests are done:
- _Component-level microbenchmarks_: The performance of individual  
  Clustering components and distance calculations is isolated for 
  comparative evaluation

- _End-to-end CLUE macrobenchmarks_: Total execution time, including
  data preparation, clustering, and output writing, is recorded to 
  evaluate overall workflow latency.

- _Speedup factor_: Execution time ratios between baseline (DBSCAN) and
  optimized implementations (IP.LSH.DBSCAN) across various   
  parallelization settings are computed.

Macro/micro benchmarks is not a commonly used term, and
these names are used for two Android app benchmark suites.

To test the accuracy of the clustering the following things are done:
- _External validation_: When ground truth labels are available, the 
  Adjusted Rand Index measures clustering accuracy. This is done by 
  comparing resulting clustering labels with the true labels provided 
  by the ground truth.

- _Comparative accuracy_: Clustering outcomes from IP.LSH.DBSCAN is 
  compared against DBSCAN, highlighting the tradeoff between 
  execution time and accuracy.

- _Parameter sensitivity_: The sensitivity of clustering outcomes to 
  variations in parameters is assessed, serving to validate the robustness of the parameter finding strategy.

The scalability of CLUE is also measured:
- _Dataset size scaling_: Performance changes are measured
  as data points increase.

- _Dimensionality scaling_: Vector dimensionality varies from
  24 to 96 to observe performance shifts.

- _Resource scaling_: Sequential and parallel performance is compared 
  across a range of thread counts.

### 5.1.2 Application Specific Validation of CLUE
The practical value of a clustering approach is evaluated
through the method _Pattern Discovery Assessment_.

## 5.2 Experimental Setup
Tests are ran on a powerful server-grade PC.
Tests used four datasets:
- _Dataset 1_: Hourly consumption data from 7500 s-m business customers.
  24 dimension data points.
- _Dataset 2_: Same customers as Dataset 1 but 15-minute intervals 
  instead. 96 dimension data points.
- _Dataset 3_: Synthetic 50,000 data point dataset.
  Each data point is a 96-dimensional data. The dataset
  was generated with 7 distinct consumption patterns.
- _Dataset 4_: Synthetic 10,000 data point dataset.
  Same rules as Dataset 3 but with an additional consumption pattern.
  This new consumption pattern is far more spread out
  and challenging to pinpoint.

  

## 5.3 Core Algorithm Performance Evaluation
### 5.3.1 Computational Efficiency Comparison
### 5.3.2 LSH Parameter Impact

## 5.4 CLUE Macrobenchmarks - Performance
### 5.4.1 CLUE performance with LSH parameter variation

## 5.5 Accuracy and Parameter Optimization Eﬀectiveness
### 5.5.1 DBSCAN/IP.LSH.DBSCAN Accuracy
### 5.5.2 Cluster Quality

## 5.6 Application and Evaluation of CLUE in a Real-world Scenario
### 5.6.1 Round 1: Outlier Detection and Separation
### 5.6.2 Round 2A: Exploring the Clusters Data
### 5.6.3 Round 2B: Exploring the noise/outlier Data

## 5.7 Summary

# 6 Discussion

## 6.1 Performance
### 6.1.1 Large high-dimensional datasets
### 6.1.2 Parameter Search

## 6.2 Applicability 