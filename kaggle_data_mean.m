% This script is used to calculate the mean and overall registration results for the kaggle dataset 

clc,clear;

for i = 0:3
    cnt = 1;
    gra_path = ['kaggle/',num2str(i),'/gra/']; % eg: 0/gra; 1/gra
    trunk_path = ['kaggle/',num2str(i),'/trunk_gra/']; % eg: 0/trunk_gra; 1/trunk_gra
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
    [gra_setn,mean_gra] = multiple_alignment(gra_set,1,5,trunk_set);
    save(['kaggle_v10_',num2str(i)],'gra_setn','mean_gra');
end