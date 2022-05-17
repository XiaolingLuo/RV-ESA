clc,clear;

%     src_path = '3341_bin/thin/';
%     dest_path = '3341_bin/gra/';

    src_path = 'simu/thin/';
    dest_path = 'simu/gra/';
%     src_path = 'fuzhen/thin/';
%     dest_path = 'fuzhen/gra/';
%     src_path = 'simu/thin/';
%     dest_path = 'simu/gra/';
%     src_path = 'kaggle/thin/';
%     dest_path = 'kaggle/gra/';
    files = dir(src_path);
%     filenames = {'0','50','100','150','200','250','300'};
%     filenames = {'a1','a2'};
    for ii = 3:length(files)
%         idx = index_set(ii);
%         filename = strcat(src_path,filenames{ii},'.gif');
        filename = strcat(src_path,files(ii).name);
%         keyboard;
        binImg = logical(imread(filename));
        gra = extract_byB(binImg);
    %     gra.E = edge_resample(gra.E,30);
%         ns = split(filenames{ii},'.');
        ns = split(files(ii).name,'.');
        new_filename = strcat(dest_path,[ns{1},'_graph']);
        save(new_filename,'gra');
%         figure(11);clf;imshow(binImg);
        plot_graph(gra,123);
        keyboard;
    end
% end

function gra = extract_byB(binImg)
    vertex_catagory = ones(size(binImg))*-1;

    [row,col] = size(binImg);

    operators = [0,1;0,-1;1,0;-1,0;1,1;1,-1;-1,1;-1,-1];
    for i = 1:row
        for j = 1:col
            if binImg(i,j) == 0
                continue;    
            end
            n_adj = 0;
            for k = 1:8
                adj_i = i + operators(k,1);
                adj_j = j + operators(k,2);
                if adj_i >= 1 && adj_i <= row && adj_j >= 1 && adj_j <= col && binImg(adj_i,adj_j) == 1
                    n_adj = n_adj + 1;
                end
            end
            vertex_catagory(i,j) = n_adj;
        end
    end

    visited = zeros(row,col);
%     childs = logical(visited);
    parents = Inf(1,2,row,col);
    indexs = Inf(row,col);
    % keyboard;
    stack = zeros(1000,2);
    ptr = 0;
    vn = 0;
%     keyboard;
    for i = 1:row
        for j = 1:col
            if vertex_catagory(i,j) == 1
                parents(:,:,i,j) = [i,j];
                vn = vn + 1;
                indexs(i,j) = vn;
                continue;
            elseif vertex_catagory(i,j) < 3
                continue;
            elseif visited(i,j) == 1
                continue;
            end
%             if i == 375 && j == 55
%                 keyboard;
%             end
            ptr = ptr + 1;
            stack(ptr,:) = [i,j];
            visited(i,j) = 1;
            cluster = [];
            while ptr > 0
                ni = stack(ptr,1);
                nj = stack(ptr,2);
                ptr = ptr - 1;
                cluster = [cluster;ni,nj];
                for k = 1:8
                    adj_i = ni + operators(k,1);
                    adj_j = nj + operators(k,2);
                    if adj_i >= 1 && adj_i <= row && adj_j >= 1 && adj_j <= col
                        if vertex_catagory(adj_i,adj_j) >= 3 && visited(adj_i,adj_j) == 0
                            visited(adj_i,adj_j) = 1;
                            ptr = ptr + 1;
                            stack(ptr,:) = [adj_i,adj_j];
                        end
                    end
                end
            end
            common_parent = round(mean(cluster,1));
            vn = vn + 1;
            for k = 1:size(cluster,1)
                parents(:,:,cluster(k,1),cluster(k,2)) = common_parent;
                indexs(cluster(k,1),cluster(k,2)) = vn;
            end
        end
    end
%     keyboard;
    V = zeros(vn,vn);
    E = cell(1,10000);
    en = 0;
    show = logical(zeros(row,col));
    visited = zeros(row,col);
    for i = 1:row
        for j = 1:col
            if parents(1,1,i,j) == inf
                continue;
            end
%             if i == 360 && j == 28
%                 keyboard;
%             end
            show(i,j) = 1;
            visited(i,j) = 1;
            for k = 1:8
                ni = i + operators(k,1);
                nj = j + operators(k,2);
                if ~(ni >= 1 && ni <= row && nj >= 1 && nj <= col && vertex_catagory(ni,nj) == 2) ...
                        || visited(ni,nj) == 1
                    continue;
                end
                visited(ni,nj) = 1;
                curve = Inf(2,1000);
                curve(:,1:2) = [j,nj;row-i,row-ni];
                n_point = 2;
    %             keyboard;
                while indexs(ni,nj) == inf
                    flag = 1;
                    for u = 1:8
                        adjac_i = ni + operators(u,1);
                        adjac_j = nj + operators(u,2);
                        if adjac_i >= 1 && adjac_i <= row && adjac_j >= 1 && adjac_j <= col && binImg(adjac_i,adjac_j) == 1 ...
                            && (vertex_catagory(adjac_i,adjac_j) == 2 && visited(adjac_i,adjac_j) == 0 || (indexs(adjac_i,adjac_j) ~= inf && indexs(adjac_i,adjac_j) ~= indexs(i,j)))
                            flag = 0;
                            break;
                        end
                    end
                    if flag == 1
                        break;
                    end
                    visited(adjac_i,adjac_j) = 1;
                    n_point = n_point + 1;
                    curve(:,n_point) = [adjac_j,row-adjac_i];
                    ni = adjac_i;
                    nj = adjac_j;
%                     keyboard;
                end
                if flag == 1
                    continue;
                end
                if indexs(i,j) == indexs(ni,nj)
%                     keyboard;
                    continue;
                end
                temp = parents(:,:,ni,nj);
                curve(:,n_point) = [temp(2),row-temp(1)];
                temp = parents(:,:,i,j);
                curve(:,1) = [temp(2),row-temp(1)];
                
                E{en+1} = curve(:,1:n_point);
                E{en+2} = fliplr(E{en+1});
                V(indexs(i,j),indexs(ni,nj)) = en+1;
                V(indexs(ni,nj),indexs(i,j)) = en+2;
                en = en + 2;
    %             keyboard;
            end
        end
    end
%     keyboard;
    E(en+1:end) = [];
    degree = get_degree(V);
    delete_set = find(degree == 0);
    V(delete_set,:) = [];
    V(:,delete_set) = [];
%     keyboard;
    [V,E] = rid_intersection(V,E);
%     [V,E] = rid_H(V,E);
    [V,E] = rid_shortEdge(V,E,10);

    [V,E] = rid_degree2(V,E);
%     [V,E] = rid_unconnected(V,E);
    gra.V = V;
    gra.E = E;
    coord = get_coord(gra);
    check = find(coord(1,:) == inf);
    if ~isempty(check)
        keyboard;
    end
    gra.coord = coord;
end
% && indexs(adjac_i,adjac_j) ~= indexs(i,j)
function gra = extract_byA(binImg)
    vertex_set = extract_vertex(binImg);
    isVertex = zeros(size(binImg));

    for i = 1:length(vertex_set)
        ni = vertex_set{i}.self(1);
        nj = vertex_set{i}.self(2);
        isVertex(ni,nj) = i;
    end
%     keyboard;
    
    visited = zeros(size(binImg));

    vn = length(vertex_set);
    V = zeros(vn,vn);
    E = cell(1,10000);
    en = 0;
    [m,n] = size(binImg);

    for s = 1:vn
        nx_self = vertex_set{s}.self(1);
        ny_self = vertex_set{s}.self(2);
        visited(nx_self,ny_self) = 1;
        
        for k = 1:8
            nx_adj = vertex_set{s}.neighbor(k,1);
            if nx_adj == inf
                break;
            end
            ny_adj = vertex_set{s}.neighbor(k,2);
            curve = [ny_self,ny_adj;m - nx_self,m - nx_adj];
            
            flag = 0;
            if isVertex(nx_adj,ny_adj) ~= 0
                e = isVertex(nx_adj,ny_adj);
                flag = 1;
            elseif visited(nx_adj,ny_adj) == 0
                visited(nx_adj,ny_adj) = 1;
                [curve,visited] = seek_curve(nx_adj,ny_adj,curve,visited,binImg,isVertex,nx_self,ny_self);
                e = isVertex(m-curve(2,end),curve(1,end));
                flag = 1;
            end
            
            if flag == 1 && ~V(s,e)
                E{en+1} = curve;
                E{en+2} = fliplr(curve);
                V(s,e) = en + 1;
                V(e,s) = en + 2;
                en = en + 2;
            end
        end
    end
    E(en+1:end) = [];
    check(V,E);
%     keyboard;
%     [V,E] = rid_shortEdge(V,E,4);
%     [V,E] = rid_intersection(V,E);
%     [V,E] = rid_degree2(V,E);
    gra.V = V;
    gra.E = E;
end

function [curve,visited] = seek_curve(nx_current,ny_current,curve,visited,...
                            binImg,isVertex,nx_self,ny_self)
    operators = [-1,-1;-1,0;-1,1;0,-1;0,1;1,-1;1,0;1,1];
    t_curve = ones(2,5000)*inf;
    t_curve(1:2,1:2) = curve;
    curve = t_curve;
    n_vertex = 2;

    [m,n] = size(binImg);

    while isVertex(nx_current,ny_current) == 0
        for k = 1:8
            nx_adj = nx_current + operators(k,1);
            ny_adj = ny_current + operators(k,2);
            if nx_adj >= 1 && nx_adj <= m && ny_adj >= 1 && ny_adj <= n && binImg(nx_adj,ny_adj) == 1 && ...
                    (visited(nx_adj,ny_adj) == 0 || isVertex(nx_adj,ny_adj) ~= 0) && ...
                    (nx_adj ~= nx_self || ny_adj ~= ny_self)
                break;
            end
        end
        nx_current = nx_adj;
        ny_current = ny_adj;
        n_vertex = n_vertex + 1;
        curve(:,n_vertex) = [ny_current,m - nx_current];
        visited(nx_current,ny_current) = 1;
    end
    curve(:,n_vertex+1:end) = [];
end



function vertex_set = extract_vertex(binImg)
    vertex_set = cell(1,5000);

    vn = 0;
    operators = [-1,-1;-1,0;-1,1;0,-1;0,1;1,-1;1,0;1,1];

    [m,n] = size(binImg);
    for i = 1:m
        for j = 1:n
            if binImg(i,j) == 0
                continue;
            end
            
            info.self = [i,j];
            info.neighbor = ones(8,2)*inf;
            n_ofNeighbor = 0;
            for k = 1:8
                ni = i + operators(k,1);
                nj = j + operators(k,2);
                if ni >= 1 && ni <= m && nj >= 1 && nj <= n && binImg(ni,nj) == 1
                    n_ofNeighbor = n_ofNeighbor + 1;
                    info.neighbor(n_ofNeighbor,:) = [ni,nj];
                end
            end

            if n_ofNeighbor == 1 || n_ofNeighbor > 2
                vn = vn + 1;
                vertex_set{vn} = info;
            end
        end
    end
    vertex_set(vn+1:end) = [];
end
