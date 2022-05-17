# RV-ESA
**RV-ESA: A Novel Computer-Aided Elastic Shape Analysis System for Retinal Vessels in Diabetic Retinopathy**

**Abstract：**
The retinal vasculature is the only part of the human circulatory system that allows direct noninvasive visualization of the body's microvasculature, which provides the opportunity to detect the structural and functional changes before diabetic retinopathy (DR) becomes unable to intervene. A novel computer-aided analysis system is proposed to provide objective vascular shape analysis data for ophthalmologists to diagnose DR. This paper mathematically represents the vascular geometry model and performs statistical analysis on it. To visualize the changes of vascular networks in the progression of DR, this paper also utilizes the geodesic tool to show the deformation process. 

**Code Description:**
addPath.m: run this file before starting.
thinning_binImage.m: Skeletonize the binary graph of retinal vessels.
extract_curve.m: The adjacency matrix is constructed according to the skeletonized graph, and the points and edges are found.  
extract_trunkCurve.m: The adjacency matrix of main vessels is extracted.
pairwise_alignment.m: The adjacency matrices of two graphs are registered.
multiple_alignment.m:  The adjacency matrices of more than 3 graphs are registered.
kaggle_data_mean.m: This script is used to calculate the mean and overall registration results for the kaggle dataset.
pca_forGraph.m：Inputting the results of multiple_alignment.m before the PCA is calculating. Each sample takes a dot product with each eigenvector to get a PCA score.
get_geodesic.m：for geodesic deformations.
