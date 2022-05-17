function result = align_vertex(gra_set)
    gn = length(gra_set);
    vn_set = zeros(1,gn);
    for i = 1:gn
        vn_set(i) = size(gra_set{i}.V,2);
    end
    
%     flag = 1;
%     for i = 2:gn
%         if vn_set(i) ~= vn_set(i-1)
%             flag = 0;
%             break;
%         end
%     end
%     if flag == 1
%         result = gra_set;
%         for i = 1:gn
%             result{i}.alignV = result{i}.V;
%         end
%         return;
%     end
    
    
    max_vn = max(vn_set);
    
    % test
%     max_vn = max_vn + ceil(max_vn*0.5);
    max_vn = ceil(max_vn*2);
    

    result = gra_set;
    for i = 1:gn
        new_V = zeros(max_vn,max_vn);
        new_V(1:vn_set(i),1:vn_set(i)) = gra_set{i}.V;
        result{i}.alignV = new_V;
        
        % test
        result{i}.V = new_V;
        result{i}.coord = get_coord(struct('V',{result{i}.V},'E',{result{i}.E}));
    end
%     keyboard;
end