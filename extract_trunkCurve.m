clc,clear;

% index_set = [22,24,25,27,28,29,30,32,33,36,37,38,40];
% index_set = [28,40];
% index_set = [22,28];
% path_prefix = '1st_manual/right_eye/';
operators = [-1,-1;-1,0;-1,1;0,-1;0,1;1,-1;1,0;1,1;0,0];

% for t = 0:3
    graph_path = 'fuzhen/gra/';
    trunk_path = 'fuzhen/trunk/';
    trunk_graph_path = 'fuzhen/trunk_gra/';
    
    graph_files = dir(graph_path);
    trunk_files = dir(trunk_path);
    for ii = 3:length(graph_files)
%         idx = index_set(ii);
        graph_name = strcat(graph_path,graph_files(ii).name);
%         keyboard;
        trunk_name = strcat(trunk_path,trunk_files(ii).name);
%         keyboard;
        load(graph_name);
        
%         keyboard;
    %     binImg = imread([path_prefix,'blood_',num2str(idx),'_trunk_thinned.gif']);
        binImg = imread(trunk_name);
        binImg = logical(binImg);
    %     keyboard;
    %     plot_graph(gra,585);
    %     keyboard;
        [height,width] = size(binImg);
        vn = size(gra.V,2);
        vertex_set = [];
        edge_set = [];
        for i = 1:vn
            for j = i:vn
                if ~gra.V(i,j)
                    continue;
                end
                ee = gra.E{gra.V(i,j)};
                n_hit = 0;
                for m = 1:size(ee,2)
                    self_x = height - round(ee(2,m));
                    self_y = round(ee(1,m));
                    flag = 0;
                    for k = 1:9
                        adj_x = self_x + operators(k,1);
                        adj_y = self_y + operators(k,2);
                        if adj_x >= 1 && adj_x <= height && adj_y >= 1 && adj_y <= width && binImg(adj_x,adj_y) == 1
                            flag = 1;
                            break;
                        end
                    end
                    if flag == 1
                        n_hit = n_hit + 1;
                    end
                end
                if n_hit*1.25 >= size(ee,2)
                    vertex_set = [vertex_set,i,j];
                    edge_set = [edge_set,gra.V(i,j)];
                end
            end
        end
        vertex_set = unique(vertex_set);
        sub_V = gra.V(vertex_set,vertex_set);
        vn = size(sub_V,2);
        for i = 1:vn
            for j = i:vn
                if ~sub_V(i,j)
                    continue;
                end
                if length(find(edge_set == sub_V(i,j))) == 0
                    sub_V(i,j) = 0;
                    sub_V(j,i) = 0;
                end
            end
        end
    %     keyboard;
        [sub_V,sub_E] = rearrange(sub_V,gra.E);

    %     [sub_V,sub_E] = rid_degree2(sub_V,sub_E);
%         keyboard;
%         [sub_V,sub_E] = rid_unconnected(sub_V,sub_E);
%         check(sub_V,sub_E);
%         keyboard;
    %     sub_E = edge_resample(sub_E,30);

        gra.V = sub_V;
        gra.E = sub_E;
        coord = get_coord(gra);
        check = find(coord(1,:) == inf);
        if ~isempty(check)
            keyboard;
        end
        gra.coord = coord;
    %     curveMat = to_curveMat(sub_V,sub_E);
    %     keyboard;
%         keyboard;
        ns = split(trunk_files(ii).name,'.');
        new_filename = strcat(trunk_graph_path,[ns{1},'_graph']);
        save(new_filename,'gra');
%         plot_graph(gra,145);
%         keyboard;
    end
% end