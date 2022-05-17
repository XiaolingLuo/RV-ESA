function new_coord = action_on_coord(coord,P)
    new_coord = Inf(2,length(coord));
    vn = length(P);
    for i = 1:vn
        j = find(P(i,:) == 1);
        new_coord(:,i) = coord(:,j);
    end
end