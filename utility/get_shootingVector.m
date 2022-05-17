function sv = get_shootingVector(gra1,gra2)
    gra_set = {gra1,gra2};
    
    gn = 2;
    q_set = cell(1,gn);
    coord_set = cell(1,gn);
    for i = 1:gn
        for j = 1:length(gra_set{i}.E)
            q_set{i}{j} = curve_to_qnos(gra_set{i}.E{j});
        end
        coord_set{i} = get_coord(gra_set{i});
    end
    
    vn = length(coord_set{1});
    T = length(gra1.E{1});
    sv = [];
    cnt = 0;
    V = zeros(vn,vn);
    for i = 1:vn
        for j = i:vn
            if gra1.V(i,j) == 0 && gra2.V(i,j) == 0
                continue;
            end
            if gra1.V(i,j) == 0
                s = zeros(2,T);
            else
                s = q_set{1}{gra1.V(i,j)};
            end
            if gra2.V(i,j) == 0
                e = zeros(2,T);
            else
                e = q_set{2}{gra2.V(i,j)};
            end
            v = e - s;
            cnt = cnt + 1;
            V(i,j) = cnt;
            Eq{cnt} = v;
        end
    end
%     keyboard;
    coord_offset = coord_set{2} - coord_set{1};
    coord_offset(abs(coord_offset) == inf) = 0;
    coord_offset(isnan(coord_offset)) = 0;
    sv = struct('V',{V},'Eq',{Eq},'offset',{coord_offset});
%     keyboard;
end

