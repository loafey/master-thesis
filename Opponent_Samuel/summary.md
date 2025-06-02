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
## 3.2 High-Dimensional Time Series Clustering Challenges
### 3.2.1 Dimensionality Effects on Distance Metrics and Computation
### 3.2.2 Temporal Dependencies and Structure

## 3.3 The Parameterization Problem

## 3.4 Feature Engineering vsRaw Data Approaches

## 3.5 Computational Eﬃciency vsAccuracy

## 3.6 Domain Knowledge

## 3.7 Reﬁned Problem Statement

# 4 CLUE Toolchain Architecture

## 4.1 Overview and Design Goals

## 4.2 Core Components
### 4.2.1 Clustering Algorithms
### 4.2.2 Distance/Similarity Metrics
### 4.2.3 Parameter Optimization
### 4.2.4 Feature Standardization

# 5 Evaluation

## 5.1 Evaluation Methodology
### 5.1.1 Technical Performance Metrics
### 5.1.2 Application Speciﬁc Validation of CLUE

## 5.2 Experimental Setup

## 5.3 Core Algorithm Performance Evaluation
### 5.3.1 Computational Eﬃciency Comparison
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