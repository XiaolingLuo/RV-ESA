function [V,E] = rearrange(V,E)

vn = size(V,2);
newE = cell(1,10000);
en = 0;
for i = 1:vn
    for j = i:vn
        if ~V(i,j)
            continue;
        end
        newE{en+1} = E{V(i,j)};
        newE{en+2} = E{V(j,i)};
        V(i,j) = en+1;
        V(j,i) = en+2;
        en = en+2;
    end
end
E = newE;
E(en+1:end) = [];