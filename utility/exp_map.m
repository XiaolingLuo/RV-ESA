function gra2 = exp_map(gra1,sv,coeff)
   
    Eq = cell(1,length(gra1.E));
    for j = 1:length(gra1.E)
        Eq{j} = curve_to_qnos(gra1.E{j});
    end
    coord1 = get_coord(gra1);
    
    vn = size(gra1.V,2);
    T = length(Eq{1});
    
    E = cell(1,2000);
    edge_set = zeros(2000,2);
    new_coord = cell(1,vn);
    en = 0;
    
    for i = 1:vn
        for j = i:vn
            if gra1.V(i,j) == 0
                continue;
            end
            if gra1.V(i,j) == 0
                q = zeros(2,T);
            else
                q = Eq{gra1.V(i,j)};
            end
            
            if sv.V(i,j) == 0
                v = zeros(2,T);
            else
                v = sv.Eq{sv.V(i,j)};
            end
            
            tmp = q_to_curve(coeff*(q+v));
            if all(tmp == 0)
                continue;
            end
            en = en + 1;
            E{en} = tmp;
            edge_set(en,:) = [i,j];
        end
    end
    E(en+1:end) = [];
    edge_set(en+1:end,:) = [];
    new_coord = coord1 + coeff*sv.offset;
    gra2 = connect_curves(E,edge_set,new_coord);
%     keyboard;
end

