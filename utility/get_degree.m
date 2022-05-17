function degree = get_degree(V)

vn = size(V,2);
degree = zeros(1,vn);

for i = 1:vn
    for j = i:vn
        if V(i,j) ~= 0
            degree(i) = degree(i) + 1;
            degree(j) = degree(j) + 1;
        end
    end
end