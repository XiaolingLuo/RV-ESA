% This script is used to calculate the geodesic for the wheat dataset 

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
[gra1n, gra2n] = pairwise_alignment(gra_set{6},gra_set{10},0); % select two graphs from the graph set and perform registraion
keyboard;
get_geodesic(gra1n,gra2n,5,1,1); % get the geodesic between the aligned graphs