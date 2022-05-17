function [gra1n, gra2n] = pairwise_alignment(gra1,gra2,isUpDown,varargin)
    % allowed input format:
    %   1. gra = {V,E,coord}, isUpDown = 1;
    %   2. gra = {V,E,coord}, isUpDown = 1, varargin = trunk_gra;
    %   3. gra = {up_gra,down_gra}, isUpDown = 1;
    %   4. gra = {V,E,coord}, isUpDown = 0
    
    if isfield(gra1,'E')
        gra1.E = smooth_edge(edge_resample(gra1.E,30));
        gra2.E = smooth_edge(edge_resample(gra2.E,30));
    end
    if isUpDown == 1
        if length(varargin) == 0 && ~isfield(gra1,'up_gra')
            result = align_vertexNum({gra1,gra2},1);
        elseif length(varargin) > 0
%             keyboard;
            trunk_set = varargin{1};
            result = align_vertexNum({gra1,gra2},1,trunk_set);
        else
            up_result = align_vertexNum({gra1.up_gra,gra2.up_gra},0);
            down_result = align_vertexNum({gra1.down_gra,gra2.down_gra},0);
            for i = 1:2
                result{i}.up_gra = up_result{i};
                result{i}.down_gra = down_result{i};
            end
        end
        
%         keyboard;
        gra1n = result{1};
        gra2n = result{2};
        matching_set = cell(1,2);
        matching_set{1} = struct('gra1',{gra1n.up_gra},'gra2',{gra2n.up_gra},'required',{[]},'banned',{[]});
        matching_set{2} = struct('gra1',{gra1n.down_gra},'gra2',{gra2n.down_gra},'required',{[]},'banned',{[]});
        
        result_P = get_P(matching_set);
        
        gra2n.up_gra.V = result_P{1}*gra2n.up_gra.alignV*result_P{1}';
        gra2n.up_gra.coord = action_on_coord(gra2n.up_gra.coord,result_P{1});
        gra2n.up_gra = rmfield(gra2n.up_gra,{'alignV'});
        
        gra2n.down_gra.V = result_P{2}*gra2n.down_gra.alignV*result_P{2}';
        gra2n.down_gra.coord = action_on_coord(gra2n.down_gra.coord,result_P{2});
        gra2n.down_gra = rmfield(gra2n.down_gra,{'alignV'});
        
        gra1n.up_gra.V = gra1n.up_gra.alignV;
        gra1n.up_gra = rmfield(gra1n.up_gra,{'alignV'});
        
        gra1n.down_gra.V = gra1n.down_gra.alignV;
        gra1n.down_gra = rmfield(gra1n.down_gra,{'alignV'});
        
        gra1n = merge_gra(gra1n.up_gra,gra1n.down_gra);
        gra2n = merge_gra(gra2n.up_gra,gra2n.down_gra);
    else
        result = align_vertexNum({gra1,gra2},0);
        gra1n = result{1};
        gra2n = result{2};
%         keyboard;
        matching_set{1} = struct('gra1',{gra1n},'gra2',{gra2n},'required',{[]},'banned',{[]});
        
        result_P = get_P(matching_set);
%         keyboard;
        gra2n.V = result_P{1}*gra2n.alignV*result_P{1}';
        gra2n.coord = action_on_coord(gra2n.coord,result_P{1});
        gra1n.V = gra1n.alignV;
        
        gra1n = rmfield(gra1n,{'alignV'});
        gra2n = rmfield(gra2n,{'alignV'});
%         gra2n = deal_nullNodes(gra1n,gra2n);
%         gra1n = deal_nullNodes(gra2n,gra1n);
    end
%     gra2n = edge_registration(gra1n,gra2n);
%     get_geodesic(gra1n,gra2n,10);
%     keyboard;
end

