function gra2 = edge_registration(gra1,gra2)
    coord2 = get_coord(gra2);
    vn = size(gra1.V,2);
    for i = 1:vn
        for j = i:vn
            if gra1.V(i,j) == 0 || gra2.V(i,j) == 0
                continue;
            end
            gamI = get_gamma(gra1.E{gra1.V(i,j)},gra2.E{gra2.V(i,j)});
            curve = Group_Action_by_Gamma_Coord(gra2.E{gra2.V(i,j)},gamI);
            curve = fit_into_nodes(coord2(:,i),coord2(:,j),curve);
            gra2.E{gra2.V(i,j)} = curve;
            if gra2.V(j,i) == 0
                keyboard;
            end
            gra2.E{gra2.V(j,i)} = fliplr(curve);
        end
    end
end