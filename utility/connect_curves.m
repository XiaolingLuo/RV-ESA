function gra = connect_curves(E,edge_set,coord)
%     keyboard;
    vn = size(coord,2);
    T = size(E{1},2);
    en = length(E);
    
%     keyboard;
    V = zeros(vn,vn);
    
    visited = zeros(1,size(edge_set,1));
    flag = 1;
%     keyboard;
    while flag
        new_coord = ones(2,vn)*inf;
        flag = 0;
        for i = 1:size(edge_set,1)
            if visited(i) == 1
                continue;
            end
            
            v1 = edge_set(i,1);
            v2 = edge_set(i,2);
            ee = E{i};
            if isinf(ee(1,1))
                keyboard;
            end
            
            tag = 0;
            if coord(1,v1) ~= inf && coord(1,v2) ~= inf
                if all(coord(:,v1) == coord(:,v2))
%                     visited(i) = 1;
                    keyboard;
                end
                E{i} = fit_into_nodes(coord(:,v1),coord(:,v2),ee);
            elseif coord(1,v1) ~= inf
                offset = coord(:,v1) - ee(:,1);
                E{i} = ee + repmat(offset,1,T);
                new_coord(:,v2) = E{i}(:,end);
                tag = 1;
            elseif coord(1,v2) ~= inf
                offset = coord(:,v2) - ee(:,end);
                E{i} = ee + repmat(offset,1,T);
                new_coord(:,v1) = E{i}(:,1);
                tag = 1;
            else
                continue;
            end
            
            en = en + 1;
            E{en} = fliplr(E{i});
            V(v1,v2) = i;
            V(v2,v1) = en;
            
            visited(i) = 1;
            flag = 1;
            if tag == 1
                break;
            end
        end
        
        idx_set = find(new_coord(1,:) ~= inf);
        coord(:,idx_set) = new_coord(:,idx_set);
    end
    gra = struct('V',{V},'E',{E},'coord',{coord});
    % the function is weak that not the all edge can be processed.
    if length(find(visited == inf)) ~= 0
        keyboard;
    end
end
