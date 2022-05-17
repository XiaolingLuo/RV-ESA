function [V,E] = rid_shortEdge(V,E,threshold)

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
            if size(E{V(i,j)},2) <= threshold && (degree(i) >= 2 && degree(j) >= 2)
                flag = 0;
                break;
            end
        end
        if flag == 0
            break;
        end
    end
    if flag == 1
        break;
    end
    % why once < becomes <=, the result changes hugely?
%     if degree(i) <= degree(j) 
%         del_idx = i;
%         save_idx = j;
%     else
%         del_idx = j;
%         save_idx = i;
%     end
    del_idx = j;
    save_idx = i;
    for k = 1:vn
        if k == save_idx || ~V(k,del_idx)                                                                                                                                                                                                                                                                       || ~V(k,j)
            continue;
        end
        ee = [E{V(k,del_idx)}(:,1:end-1),E{V(del_idx,save_idx)}(:,end)];
        E{en+1} = ee;
        E{en+2} = fliplr(ee);
        V(k,save_idx) = en+1;
        V(save_idx,k) = en+2;
        en = en+2;
    end
    V(:,del_idx) = [];
    V(del_idx,:) = [];
%     keyboard;
end
degree = get_degree(V);
delete_set = find(degree == 0);
V(delete_set,:) = [];
V(:,delete_set) = [];

[V,E] = rearrange(V,E);