clc,clear;


for i = 1:3
    gra_path = [num2str(i),'/gra/'];
    gra_files = dir(gra_path);
    load(strcat('kaggle_v10_',num2str(i)));
    mean = merge_gra(mean_gra{6}.up_gra,mean_gra{6}.down_gra);
    for j = 1:length(gra_setn)
        sample = merge_gra(gra_setn{j}.up_gra, gra_setn{j}.down_gra);
%         plot_graph(sample,123);
        diff_gra = edge_diff(sample, mean);
%         plot_graph(diff_gra,256);
        img = logical(gra2img(diff_gra));
%         figure(343);clf;
%         imshow(img);
        prefix = split(gra_files(j+2).name, "_");
%         keyboard;
        img_name = strcat(gra_path,prefix(1),"_",prefix(2),"_",prefix(3),"_diff.gif");
        imwrite(img,img_name);
%         keyboard;
    end
    
%     keyboard;
end

function img = gra2img(gra)
    m = 592;
    n = 592;
    img = zeros(m,n);
    V = gra.V;
    E = gra.E;
    vn = size(V,2);
    for i = 1:vn
        for j = i:vn
            if ~V(i,j)
                continue;
            end
            curve = E{V(i,j)};
            curve = resampling(curve, 1000);
            for k = 1:length(curve)
                x = ceil(curve(1,k));
                y = ceil(curve(2,k));
                if x <=n && x >= 1 && y < m && y >= 0
                    img(m-y,x) = 1;
                end
            end
        end
    end
end