function [splited_gra] = split_toUpDown_byLandmark(gra,trunk_gra,index)
%     keyboard;
    [~,up_index,down_index] = split_toUpDown(trunk_gra);
%     keyboard;
    vn = size(gra.V,2);
    label = Inf(1,vn);
    for i = 1:length(up_index)
        label(index(up_index(i))) = 1;
    end
    for i = 1:length(down_index)
        label(index(down_index(i))) = -1;
    end
%     keyboard;
    
    y_half = 292;
    coord = get_coord(gra);
    for i = 1:vn
        if label(i) ~= inf
            continue;
        end
        res = bfs(i,label,gra);
        if res == inf
            if coord(2,i) <= y_half
                res = -2;
            else
                res = 2;
            end
        end
        label(i) = res;
    end
    label(label == 2) = 1;
    label(label == -2) = -1;
%     keyboard;
    up_index = find(label == 1);
    down_index = find(label == -1);
    
    up_V = gra.V(up_index,up_index);
    col_sum = sum(up_V,2);
    isolate_index = find(col_sum == 0);
    up_isolate = up_index(isolate_index);
    up_index(isolate_index) = [];
    
    down_V = gra.V(down_index,down_index);
    col_sum = sum(down_V,2);
    isolate_index = find(col_sum == 0);
    down_isolate = down_index(isolate_index);
    down_index(isolate_index) = [];
    
    up_index = [up_index,down_isolate];
    up_index = sort(up_index);
    
    down_index = [down_index,up_isolate];
    down_index = sort(down_index);
    
    
    up_V = gra.V(up_index,up_index);
    [up_V,up_E] = rearrange(up_V,gra.E);
    down_V = gra.V(down_index,down_index);
    [down_V,down_E] = rearrange(down_V,gra.E);
    
    
    up_coord = gra.coord(:,up_index);
    down_coord = gra.coord(:,down_index);
    up_gra = struct('V',{up_V},'E',{up_E},'coord',{up_coord});
    down_gra = struct('V',{down_V},'E',{down_E},'coord',{down_coord});
    splited_gra = struct('up_gra',up_gra,'down_gra',down_gra);
    
    check = find(up_coord(1,:) == inf);
    if ~isempty(check)
        keyboard;
    end
    check = find(down_coord(1,:) == inf);
    if ~isempty(check)
        keyboard;
    end
%     keyboard;
end