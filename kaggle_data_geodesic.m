% This script is used to calculate geodesic for the kaggle dataset 

clc,clear;

cnt = 1;
gra_path = 'kaggle/0/gra/'; % eg: kaggle/0/gra; kaggle/1/gra
trunk_path = 'kaggle/0/trunk_gra/'; % eg: kaggle/0/trunk_gra; kaggle/1/trunk_gra
trunk_files = dir(trunk_path); % get the names of all trunk graphs
gra_files = dir(gra_path); % get the names of all whole graphs
keyboard;
for k = 3:length(gra_files)
    trunk_name = strcat(trunk_path,trunk_files(k).name); % construct the path where the trunk graph is located
    load(trunk_name);
    trunk_set{cnt} = gra;
    gra_name = strcat(gra_path,gra_files(k).name); % construct the path where the whole graph is located
    load(gra_name);
    gra_set{cnt} = gra;
    cnt = cnt + 1;
end
keyboard;
[gra1n, gra2n] = pairwise_alignment(gra_set{1},gra_set{2},1,trunk_set(1:2)); % select two graphs from the graph set and perform registraion
keyboard;
get_geodesic(gra1n,gra2n,5,1,1); % get the geodesic between the aligned graphs
