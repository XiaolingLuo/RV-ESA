function [V,E] = rid_intersection(V,E)

N = 50;
select_len = floor(N/5);
threshold = 2.4;
en = size(E,2);

while 1
    vn = size(V,2);
    degree = get_degree(V);
    flag = 1;
    
    for i = 1:vn
        if degree(i) ~= 4
            continue;
        end
        adjac_set = find(V(i,:) ~= 0);
        vector_set = zeros(2,4);
        for j = 1:4
            ee = resampling(E{V(i,adjac_set(j))},N);
%             keyboard;
            ee = ee - repmat(ee(:,1),1,N);
            for k = 1:select_len
                vector_set(:,j) = vector_set(:,j) + ee(:,k) - ee(:,1); %%%% revised
            end
            vector_set(:,j) = vector_set(:,j)/select_len;
        end
        angles = zeros(4,4);
        g1 = [1,2];
        for j = 1:4
            for k = j+1:4
                angles(j,k) = get_angle(vector_set(:,j),vector_set(:,k));
                if angles(g1(1),g1(2)) < angles(j,k)
                    g1 = [j,k];
                end
            end
        end
        g2 = [1,2,3,4];
        g2(g1) = [];
%         keyboard;
        if angles(g1(1),g1(2)) < threshold || angles(g2(1),g2(2)) < threshold
            continue;
        else
            flag = 0;
            break;
        end
    end
    if flag == 1
        break;
    end
    g = [g1;g2];
    for k = 1:2
        s = adjac_set(g(k,1));
        e = adjac_set(g(k,2));
        ee = [E{V(s,i)}(:,1:end-1),E{V(i,e)}];
        E{en+1} = ee;
        E{en+2} = fliplr(ee);
        V(s,e) = en+1;
        V(e,s) = en+2;
        en = en+2;
    end
    V(:,i) = [];
    V(i,:) = [];
end
[V,E] = rearrange(V,E);