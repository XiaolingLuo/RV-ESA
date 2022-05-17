% This script is used to calculate the mean and pca score for the wheat dataset 

clc,clear;

path = 'wheat/3341_bin/gra/'; % eg: wheat/3330_bin/gra/; wheat/3331_bin/gra/

filenames = 0:10:300; % determine the graphs to be selected

gra_set = cell(1,length(filenames));

for i = 1:length(filenames)
    filename = strcat(path,num2str(filenames(i)),'_graph.mat'); % construct the path where the graph is located
    load(filename);
    gra_set{i} = gra;
end
keyboard;
[gra_setn,mean_gra] = multiple_alignment(gra_set,0,5);
keyboard;
pca_score = pca_forGraph(gra_setn);