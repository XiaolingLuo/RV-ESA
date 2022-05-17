function result = align_vertexNum(gra_set,isUpDown, varargin)
%     keyboard;
    if isUpDown == 1
%         keyboard;
        gn = length(gra_set);
        up_gra_set = cell(1,gn);
        down_gra_set = cell(1,gn);
        
        if length(varargin) == 0
            for i = 1:gn
                result = split_toUpDown(gra_set{i});
                up_gra_set{i} = result.up_gra;
                down_gra_set{i} = result.down_gra;
            end
        else
            trunk_set = varargin{1};
%             keyboard;
            for i = 1:gn
                indexs = get_index(gra_set{i},trunk_set{i});
                result = split_toUpDown_byLandmark(gra_set{i},trunk_set{i},indexs);
                up_gra_set{i} = result.up_gra;
                down_gra_set{i} = result.down_gra;
            end
        end
        
        up_result = align_vertex(up_gra_set);
        down_result = align_vertex(down_gra_set);
        
        result = cell(1,gn);
        for i = 1:gn
            result{i} = struct('up_gra',up_result(i),'down_gra',down_result(i));
        end
%         keyboard;
    else
        result = align_vertex(gra_set);
%         keyboard;
    end
    if length(result) == 1
        result = result{1};
    end
end