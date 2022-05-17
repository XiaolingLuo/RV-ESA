function index = get_index(gra,trunk_gra)
    coord = get_coord(gra);
    sub_coord = get_coord(trunk_gra);
    index = Inf(1,size(sub_coord,2));
    for i = 1:size(sub_coord,2)
        for j = 1:size(coord,2)
            if all(abs(coord(:,j) - sub_coord(:,i)) < 1e-3)
                if index(i) == inf
                    index(i) = j;
                else
                    disp('check!');
                    keyboard;
                end
            end
        end
    end
end
