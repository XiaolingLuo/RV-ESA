function [splited_gra,up_index,down_index] = split_toUpDown(gra)
%     keyboard;
    vn = size(gra.V,2);
    coord = get_coord(gra);
    coord_y = coord(2,:);
    coord_y(coord_y == inf) = [];
     coord_y = sort(coord_y);
    y_half = 292;
%     y_half = mean([coord_y(1:10),coord_y(end-9:end)]);
    up_index = [];
    down_index = [];

    for i = 1:vn
        if coord(2,i) == inf
            keyboard;
        elseif coord(2,i) <= y_half
            down_index = [down_index,i];
        else
            up_index = [up_index,i];
        end
    end
%     keyboard;
%     coord = gra.coord;
%     y_half = 292; offset = 60;
%     vn = size(gra.V,2);
%     label = Inf(1,vn);
%     for i = 1:vn
%         if coord(2,i) <= y_half-offset
%             label(i) = -1;
%         elseif coord(2,i) >= y_half+offset
%             label(i) = 1;
%         end
%     end
% 
%     for i = 1:vn
%         if label(i) ~= inf
%             continue;
%         end
%         res = bfs(i,label,gra);
%         if res == Inf
%             if coord(2,i) <= y_half
%                 res = -2;
%             else
%                 res = 2;
%             end
%         end
%         label(i) = res;
%     end
%     label(label == 2) = 1;
%     label(label == -2) = -1;
% %     keyboard;
%     up_index = find(label == 1);
%     down_index = find(label == -1);
    
%     keyboard;
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
    
%     keyboard;
%     gra.V(up_index,down_index) = 0;
%     gra.V(down_index,up_index) = 0;
%     [gra.V,gra.E] = rearrange(gra.V,gra.E);
%     splited_gra.V = {up_V,down_V,gra.V};
%     splited_gra.E = {up_E,down_E,gra.E};
%     splited_gra.index = {up_index,down_index};

    up_coord = gra.coord(:,up_index);
    down_coord = gra.coord(:,down_index);
    up_gra = struct('V',{up_V},'E',{up_E},'coord',{up_coord});
    down_gra = struct('V',{down_V},'E',{down_E},'coord',{down_coord});
    splited_gra = struct('up_gra',up_gra,'down_gra',down_gra);
%     keyboard;
end

function isolate_set = find_isolate(V)
    col_sum = sum(V,2);
    isolate_set = find(col_sum == 0);
end