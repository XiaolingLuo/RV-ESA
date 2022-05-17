function [V,E] = rid_degree2(V,E)

en = size(E,2);
while 1
    vn = size(V,2);
    degree = get_degree(V);
    flag = 1;
    for i = 1:vn
        if degree(i) ~= 2
            continue;
        else
            flag = 0;
            break;
        end
    end
    if flag == 1
        break;
    end
    adjac_set = find(V(i,:) ~= 0);
    s = adjac_set(1);
    e = adjac_set(2);
    
    ee = [E{V(s,i)},E{V(i,e)}(:,2:end)];
    E{en+1} = ee;
    E{en+2} = fliplr(ee);
    V(s,e) = en+1;
    V(e,s) = en+2;
    en = en+2;
    V(:,i) = [];
    V(i,:) = [];
end

[V,E] = rearrange(V,E);