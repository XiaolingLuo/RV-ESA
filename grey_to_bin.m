clc,clear;

% path = 'Kaggle_part2_crop_data/0/label/';
% newpath = 'Kaggle_part2_crop_data/0/binImg/';
% path = '3341/';
% newpath = '3341_bin/imgs/';
path = 'simu/origin/';
newpath = 'simu/imgs/';
% files = dir(path);
% filenames = 0:10:300;
% filenames = 0:10:300;
% keyboard;
% path = 'simu/init/';
% newpath = 'simu/imgs/';
% filenames = {'a1','a2'};
% path = 'fuzhen/seg/';
% newpath = 'fuzhen/imgs/';
files = dir(path);
for i = 3:length(files)
    filename = strcat(path,files(i).name);
%     keyboard;
    cdata = imread(filename);
    thresh = 0.4;
    binImg = im2bw(cdata,thresh);
%     binImg = ~binImg;

    [m,n] = size(binImg);
    binImg(1:2,1:n) = 0;
    binImg(m-1:m,1:n) = 0;
    binImg(1:m,1:2) = 0;
    binImg(1:m,n-1:n) = 0;
    
    labels = bwlabel(binImg);                %对各连通域进行标记
    stats = regionprops(labels,'Area');    %求各连通域的大小
    area = cat(1,stats.Area);
    idx_ofMax = find(area >= 1000);        %求最大连通域的索引
    binImg = ismember(labels,idx_ofMax);   
%     binImg = bwmorph(binImg,'thin',1);
    binImg = ~binImg;
    figure(2);clf;imshow(binImg);
%     keyboard;
    ns = split(files(i).name,'.');
    new_filename = strcat(newpath,ns{1},'.gif');
%     keyboard;
    imwrite(binImg,new_filename);
end
 