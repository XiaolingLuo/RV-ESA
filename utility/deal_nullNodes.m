function gra2 = deal_nullNodes(gra1,gra2)

    coord1 = get_coord(gra1);
    coord2 = get_coord(gra2);
    V1 = gra1.V;
    V2 = gra2.V;
    E1 = gra1.E;
    E2 = gra2.E;
%     keyboard;
    vn = size(gra2.V,2);
    e2n = length(E2);
    
    redef_N = 100;
    old_N = size(E1{1},2);
    
    for i = 1:vn
        for j = i:vn
            if ~(V2(i,j) ~= 0 && V1(i,j) == 0)
                continue;
            end
%             keyboard;
            global path_set;
            global n_path;
            path_set = [];
            n_path = 0;
            dfs(i,j,V1,zeros(1,vn),coord2,[]);
            if n_path == 0
                continue;
            end
%             keyboard;
            for k = 1:n_path
                paths = path_set{k};
                flag = 1;
                for o = 2:length(paths)-1
                    if coord2(1,paths(o)) ~= inf
                        flag = 0;
                        break;
                    end
                end
                if flag == 1
                    break;
                end
            end
            
            path_len = [];
            for o = 2:length(paths)
                path_len(o-1) = get_length(E1{V1(paths(o-1),paths(o))});
            end
            path_len = cumsum(path_len);
            path_ratio = path_len/path_len(end);
            
            ee = resampling(E2{V2(i,j)},redef_N);
            path_len = [];
            for o = 2:size(ee,2)
                path_len(o-1) = get_length(ee(:,1:o));
            end
            path_len = path_len/path_len(end);
            
            index_set = zeros(1,length(paths));
            index_set(1) = 1;
            index_set(end) = redef_N;
            for o = 1:length(path_ratio)-1
                index_set(o+1) = bin_search(path_len,path_ratio(o));
            end
            
            for o = 2:length(paths)
                s = paths(o-1);
                e = paths(o);
                E2{e2n+1} = resampling(ee(:,index_set(o-1):index_set(o)),old_N);
                E2{e2n+2} = fliplr(E2{e2n+1});
                V2(s,e) = e2n+1;
                V2(e,s) = e2n+2;
                e2n = e2n+2;
            end
            V2(i,j) = 0;
            V2(j,i) = 0;
%             keyboard;
        end
    end
%     keyboard;
    [V2,E2] = rearrange(V2,E2);
    gra2.V = V2;
    gra2.E = E2;
end 

function dfs(start,target,V,visited,coord,paths)
%     keyboard;
    if start == target
        global path_set;
        global n_path;
        n_path = n_path + 1;
        path_set{n_path} = [paths,target];
        return;
    end
    visited(start) = 1;
    paths = [paths,start];
    vn = size(V,2);
    for i = 1:vn
        if V(start,i) ~= 0 && visited(i) == 0 && (i == target || coord(1,i) == inf)
            dfs(i,target,V,visited,coord,paths);
        end
    end
end

function len = get_length(X)
    [n,N] = size(X);
    v = zeros(n,N);
    for i = 1:n
        v(i,:) = gradient(X(i,:),1/(N-1));
    end
    len = trapz(linspace(0,1,N),sqrt(sum(v.*v))); %%revise
end

function index = bin_search(A,target)
    low = 1; high = length(A);
    while low < high
        mid = low + floor((high-low)/2);
        if abs(A(mid)-target) < 1e-2
            index = mid;
            return;
        elseif A(mid) > target
            high = mid - 1;
        else
            low = mid + 1;
        end
    end
    index = low;
end