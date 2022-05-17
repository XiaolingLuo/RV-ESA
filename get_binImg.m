clc,clear;

path = 'simu/origin/';

newpath = 'simu/imgs/';

files = dir(path);
keyboard;
for i = 3:length(files)
    filename = strcat(path,files(i).name);
%     keyboard;
    cdata = imread(filename);
    thresh = 0.4;
    binImg = im2bw(cdata,thresh);

    binImg = ~binImg;
    figure(2);clf;imshow(binImg);
%     keyboard;
    ns = split(files(i).name,'.');
    new_filename = strcat(newpath,ns{1},'.gif');
%     keyboard;
    imwrite(binImg,new_filename);
end
 