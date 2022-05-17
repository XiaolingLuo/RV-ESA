function [V,E] = rid_unconnected(V,E)
%     keyboard;
    vn = size(V,2);
    visited = Inf(1,vn);
    label = 0;
    for i = 1:vn
        if visited(i) == inf
            label = label + 1;
%             disp('hello');
            visited = dfs(i,V,visited,label);
        end
    end
    vn_set = Inf(1,label);
    for i = 1:label
        temp = find(visited == i);
        vn_set(i) = length(temp);
    end
%     keyboard;
    max_idx = find(vn_set >= 20);
    index = [];
    for i = 1:length(max_idx)
        tmp = find(visited == max_idx(i));
        index = [index,tmp];
    end
    sub_V = V(index,index);
    [V,E] = rearrange(sub_V,E);
%     keyboard;
end
function visited = dfs(rt,V,visited,label)
    visited(rt) = label;
    vn = size(V,2);
    for i = 1:vn
        if V(rt,i) ~= 0 && visited(i) == inf
            visited = dfs(i,V,visited,label);
        end
    end
end