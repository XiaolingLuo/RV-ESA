clc,clear;

% idx = 22;
% path_prefix = '1st_manual/right_eye/';
% path_prefix = 'STARE/';

% load([path_prefix,'blood_',num2str(idx),'_holefilled.mat']);
% for t = 0:3
%     src_path = '4/imgs/';
%     dest_path = '4/trunk/';
    src_path = 'fuzhen/imgs/';
    dest_path = 'fuzhen/trunk/';
%     src_path = '4_left/img/';
%     dest_path = '4_left/trunk/';
    files = dir(src_path);
    for k = 3:length(files)
        filename = strcat(src_path,files(k).name);
        binImg = logical(imread(filename));
        bw = boolean(binImg);
%         figure(1);
%         imshow(binImg);
%         title('Original');

        %% WLD
        r=5;
        mass=wldb(binImg,bw,r);
        mass=(mass>.35);
        imLabel = bwlabel(mass);                %对各连通域进行标记
        stats = regionprops(logical(imLabel),'Area');    %求各连通域的大小
        area = cat(1,stats.Area);
%         keyboard;
        index = find(area >= 10000);  %求最大连通域的索引
        img_trunk = ismember(imLabel,index);          %获取最大连通域图像
        % keyboard;
%         figure(2);
%         imshow(img_trunk);
%         keyboard;
        ns = split(files(k).name,'.');
        new_filename = strcat(dest_path,[ns{1},'_trunk.gif']);
        imwrite(img_trunk,new_filename);
%         keyboard;
    end
% end
% title('WLD')
% imwrite(img_trunk,[path_prefix,'blood_',num2str(idx),'_trunk.gif']);
% print(['28-trunk.png'],'-dpng','-painters','-r300');