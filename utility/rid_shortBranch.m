function [V,E] = rid_shortBranch(V,E,threshold)

en = size(E,2);
while 1
    vn = size(V,2);
    flag = 1;
    degree = get_degree(V);
    for i = 1:vn
        for j = i:vn
            if ~V(i,j)
                continue;
            end
            if size(E{V(i,j)},2) <= threshold
                if degree(i) == 1 && degree(j) >= 2
                    del_idx = i;
                    flag = 0;
                    break;
                elseif degree(j) == 1 && degree(i) >= 2
                    del_idx = j;
                    flag = 0;
                    break;
                end
            end
        end
        if flag == 0
            break;
        end
    end
    if flag == 1
        break;
    end

    V(:,del_idx) = [];
    V(del_idx,:) = [];
%     keyboard;
end
% degree = get_degree(V);
% delete_set = find(degree == 0);
% V(delete_set,:) = [];
% V(:,delete_set) = [];

[V,E] = rearrange(V,E);
