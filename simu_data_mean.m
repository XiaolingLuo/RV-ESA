% This script is used to calculate the mean and pca score for the simulated dataset 

clc,clear;

path = 'simu/gra/';

filenames = 1:5;

gra_set = cell(1,length(filenames));
files = dir(path); % get the names of all graphs
keyboard;
for i = 3:length(files)
    filename = strcat(path,files(i).name); % construct the path where the graph is located
    load(filename);
    gra_set{i-2} = gra;
end
keyboard;
[gra_setn,mean_gra] = multiple_alignment(gra_set,0,5);
keyboard;
pca_score = pca_forGraph(gra_setn);