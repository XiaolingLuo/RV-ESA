% This script is used to calculate the geodesic for the simulated dataset 

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
[gra2n, gra1n] = pairwise_alignment(gra_set{3},gra_set{4},0); % select two graphs from the graph set and perform registraion
keyboard;
get_geodesic(gra1n,gra2n,5,1,1); % get the geodesic between the aligned graphs