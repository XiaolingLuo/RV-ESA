function gra = shrink(gra)
    V = gra.V;
    
    sumOfRow = sum(V,1);
    null_set = find(sumOfRow == 0);
    V(:,null_set) = [];
    V(null_set,:) = [];
    
    coord = gra.coord;
    coord(:,null_set) = [];
    
    
    gra.V = V;
    gra.coord = coord;
end

