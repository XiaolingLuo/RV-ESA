addPath.m: run this file before starting.
thinning_binImage.m: Skeletonize the binary graph of retinal vessels.
extract_curve.m: The adjacency matrix is constructed according to the skeletonized graph, and the points and edges are found.  
extract_trunkCurve.m: The adjacency matrix of main vessels is extracted.
pairwise_alignment.m: The adjacency matrices of two graphs are registered.
multiple_alignment.m:  The adjacency matrices of more than 3 graphs are registered.
kaggle_data_mean.m: This script is used to calculate the mean and overall registration results for the kaggle dataset.
pca_forGraph.m：Inputting the results of multiple_alignment.m before the PCA is calculating. Each sample takes a dot product with each eigenvector to get a PCA score.
get_geodesic.m：for geodesic deformations.
