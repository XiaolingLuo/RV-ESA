clc,clear;

%     src_path = '3341_bin/imgs/';
%     dest_path = '3341_bin/thin/';

    src_path = 'simu/imgs/';
    dest_path = 'simu/thin/';
%     src_path = 'simu/imgs/';
%     dest_path =  'simu/thin/';
%     src_path = 'fuzhen/imgs/';
%     dest_path = 'fuzhen/thin/';
%     src_path = 'kaggle/img/';
%     dest_path = 'kaggle/thin/';
    files = dir(src_path);
%     keyboard;
    for k = 3:length(files)
    %     idx = index_set(k);
    %     binImg = imread([path_prefix,num2str(idx),'_trunk.gif']);

    %     figure(1);clf;imshow(binImg);
        filename = strcat(src_path,files(k).name);
        binImg = logical(imread(filename));
%         keyboard;
        for i = 1:6
            for j = 1:6
                binImg = fillHole_byRect(binImg,i,j);
            end
        end
        figure(2);clf;imshow(binImg);
%         keyboard;
        binImg = bwmorph(binImg,'thin',inf);
    %     figure(3);clf;imshow(binImg);

        labels = bwlabel(binImg);                %对各连通域进行标记
        stats = regionprops(labels,'Area');    %求各连通域的大小
        area = cat(1,stats.Area);
%         keyboard;
%         idx_ofMax = find(area >= 10000);        %求最大连通域的索引
        idx_ofMax = find(area == max(area));
        binImg = ismember(labels,idx_ofMax);          %获取最大连通域图像
%         figure(4);clf;imshow(binImg);
%         keyboard;
        binImg = bwmorph(binImg,'spur',5);
%         figure(5);clf;imshow(binImg);
    %     print([num2str(idx),'thinned-ah'],'-dpng','-painters','-r300');
    %     imwrite(binImg,[path_prefix,'blood_',num2str(idx),'_trunk_thinned.gif']);
        ns = split(files(k).name,'.');
        new_filename = strcat(dest_path,[ns{1},'.gif']);
%         keyboard;
        imwrite(binImg,new_filename);
%         keyboard;
    end
% end


function binImg = fillHole_byRect(binImg,w,h)
    [m,n] = size(binImg);
    for x = 2:n-w
        for y = 2:m-h
            flag = 1;
            for j = x:x+w-1
                if binImg(y-1,j) == 0
                    flag = 0;
                    break;
                end
                if binImg(y+h,j) == 0
                    flag = 0;
                    break;
                end
            end
            if flag == 0
                continue;
            end
            for i = y:y+h-1
                if binImg(i,x-1) == 0
                    flag = 0;
                    break;
                end
                if binImg(i,x+w) == 0
                    flag = 0;
                    break;
                end
            end
            if flag == 1
                for i = y:y+h-1
                    for j = x:x+w-1
                        binImg(i,j) = 1;
                    end
                end
            end
        end
    end
end