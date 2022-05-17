function [gra_setn,mean_gra] = multiple_alignment(gra_set,isUpDown,MaxItr, varargin)
    % allowed input format:
    %   1. gra = {V,E,coord}, isUpDown = 1;
    %   2. gra = {V,E,coord}, isUpDown = 1, varargin = trunk_gra;
    %   3. gra = {up_gra,down_gra}, isUpDown = 1;
    %   4. gra = {V,E,coord}, isUpDown = 0
    
    gn = length(gra_set);
    if isfield(gra_set{1},'E')
        for i = 1:gn
            gra_set{i}.E = smooth_edge(edge_resample(gra_set{i}.E,30));
        end
    end


    if isUpDown == 1
%% gradient method 1
        idx = 1;
        for i = 1:gn
            if size(gra_set{i}.V,2) > size(gra_set{idx}.V,2)
                idx = i;
            end
        end
        
        if length(varargin) == 0 && ~isfield(gra_set{1},'up_gra')
            gra_set = align_vertexNum(gra_set,1);
        elseif length(varargin) > 0
%             keyboard;
            trunk_set = varargin{1};
            gra_set = align_vertexNum(gra_set,1,trunk_set);
        end
        
%         keyboard;

        mean_gra = cell(1,100);
        mean_gra{1} = gra_set{idx}; 
%         keyboard;
        for k = 1:MaxItr
            disp(['Iteration ',num2str(k),' ...']);
            matching_set = cell(1,gn*2);
            for i = 1:gn
                matching_set{(i-1)*2+1} = struct('gra1',{mean_gra{k}.up_gra},'gra2',{gra_set{i}.up_gra},'required',{[]},'banned',{[]});
                matching_set{i*2} = struct('gra1',{mean_gra{k}.down_gra},'gra2',{gra_set{i}.down_gra},'required',{[]},'banned',{[]});
            end
            result_P = get_P(matching_set);
%             keyboard;
            up_gra_set = cell(1,gn);
            down_gra_set = cell(1,gn);
            for i = 1:gn
                gra = gra_set{i};
                gra.up_gra.V = result_P{(i-1)*2+1}*gra.up_gra.alignV*result_P{(i-1)*2+1}';
                gra.up_gra.coord = action_on_coord(gra.up_gra.coord,result_P{(i-1)*2+1});
                gra.up_gra = rmfield(gra.up_gra,{'alignV'});
        
                gra.down_gra.V = result_P{i*2}*gra.down_gra.alignV*result_P{i*2}';
                gra.down_gra.coord = action_on_coord(gra.down_gra.coord,result_P{i*2});
                gra.down_gra = rmfield(gra.down_gra,{'alignV'});

                up_gra_set{i} = edge_registration(mean_gra{k}.up_gra,gra.up_gra);
                down_gra_set{i} = edge_registration(mean_gra{k}.down_gra,gra.down_gra);
            end
%             keyboard;
            mean_up_gra = get_simpleMean(up_gra_set,258);
            mean_down_gra = get_simpleMean(down_gra_set,147);
            mean_up_gra.alignV = mean_up_gra.V;
            mean_down_gra.alignV = mean_down_gra.V;
            mean_gra{k+1} = struct('up_gra',mean_up_gra,'down_gra',mean_down_gra);
        end
        gra_setn = cell(1,gn);
        for i = 1:gn
            gra_setn{i} = struct('up_gra',up_gra_set{i},'down_gra',down_gra_set{i});
        end
        
        
%% gradient method 2
%         idx = 1;
%         for i = 1:gn
%             if size(gra_set{i}.V,2) > size(gra_set{idx}.V,2)
%                 idx = i;
%             end
%         end
%         
%         if length(varargin) == 0 && ~isfield(gra_set{1},'up_gra')
%             gra_set = align_vertexNum(gra_set,1);
%         elseif length(varargin) > 0
% %             keyboard;
%             trunk_set = varargin{1};
%             gra_set = align_vertexNum(gra_set,1,trunk_set);
%         end
% 
%         mean_gra = cell(1,100);
%         mean_gra{1} = gra_set{idx};
% %         keyboard;
%         MaxItr = 5;
%         for k = 1:MaxItr
%             disp(['Iteration ',num2str(k),' ...']);
%             means = mean_gra{k};
%             up_gra_set = cell(1,gn);
%             down_gra_set = cell(1,gn);
%             
%             for i = 1:gn
%                 gra = gra_set{i};
%                 matching_pair{1} = struct('gra1',{means.up_gra},'gra2',{gra.up_gra},'required',{[]},'banned',{[]});
%                 matching_pair{2} = struct('gra1',{means.down_gra},'gra2',{gra.down_gra},'required',{[]},'banned',{[]});
%                 P = get_P(matching_pair);
%                 gra.up_gra.V = P{1}*gra.up_gra.alignV*P{1}';
%                 gra.up_gra.coord = action_on_coord(gra.up_gra.coord,P{1});
%                 gra.up_gra = rmfield(gra.up_gra,{'alignV'});
% 
%                 gra.down_gra.V = P{2}*gra.down_gra.alignV*P{2}';
%                 gra.down_gra.coord = action_on_coord(gra.down_gra.coord,P{2});
%                 gra.down_gra = rmfield(gra.down_gra,{'alignV'});
%                 
%                 gra.up_gra = edge_registration(means.up_gra,gra.up_gra);
%                 gra.down_gra = edge_registration(means.down_gra,gra.down_gra);
%                 
%                 means.up_gra = get_simpleMean({means.up_gra,gra.up_gra},123);
%                 means.up_gra.alignV = means.up_gra.V;
%                 
%                 means.down_gra = get_simpleMean({means.down_gra,gra.down_gra},123);
%                 means.down_gra.alignV = means.down_gra.V;
%                 
%                 up_gra_set{i} = gra.up_gra;
%                 down_gra_set{i} = gra.down_gra;
%             end
% %             keyboard;
%             mean_up_gra = get_simpleMean(up_gra_set,258);
%             mean_down_gra = get_simpleMean(down_gra_set,147);
% %             plot_graph(mean_wholeGra,20,exist_num);
% %             keyboard;
%             mean_up_gra.alignV = mean_up_gra.V;
%             mean_down_gra.alignV = mean_down_gra.V;
%             mean_gra{k+1} = struct('up_gra',mean_up_gra,'down_gra',mean_down_gra);
% %             keyboard;
%             
%             plot_graph(merge_gra(mean_up_gra,mean_down_gra),124);
%             drawnow;
% %             keyboard;
%         end
%         gra_setn = cell(1,gn);
%         for i = 1:gn
%             gra_setn{i} = merge_gra(up_gra_set{i},down_gra_set{i});
%         end
    else
%% gradient method 1
%         idx = 1;
%         for i = 1:gn
%             if size(gra_set{i}.V,2) > size(gra_set{idx}.V,2)
%                 idx = i;
%             end
%         end
%         %         keyboard;
%         gra_set = align_vertexNum(gra_set,0);
%         
%         mean_gra = cell(1,100);
%         mean_gra{1} = gra_set{idx};
%         MaxItr = 10;
%         %         keyboard;
%         for k = 1:MaxItr
%             disp(['Iteration ',num2str(k),' ...']);
%             tic;
%             matching_set = cell(1,gn);
%             for i = 1:gn
%                 matching_set{i} = struct('gra1',{mean_gra{k}},'gra2',{gra_set{i}},'required',{[]},'banned',{[]});
%             end
%             %             keyboard;
%             result_P = get_P(matching_set);
%             new_gra_set = gra_set;
%             for i = 1:gn
%                 gra = new_gra_set{i};
%                 c1 = get_coord(gra);
%                 length(find(all(c1 == gra.coord) == 0))
%                 gra.V = result_P{i}*gra.alignV*result_P{i}';
%                 gra.coord = action_on_coord(gra.coord,result_P{i});
% %                 keyboard;
%                 gra = rmfield(gra,{'alignV'});
%                 c2 = get_coord(gra);
%                 length(find(all(c2 == gra.coord) == 0))
% %                 keyboard;
%                 new_gra_set{i} = edge_registration(mean_gra{k},gra);
% %                 new_gra_set{i} = gra;
%             end
%             mean_gra{k+1} = get_simpleMean(new_gra_set,k);
%             mean_gra{k+1}.alignV = mean_gra{k+1}.V;
%             toc;
% %             keyboard;
%             plot_graph(mean_gra{k+1},124);
%             drawnow;
% %             keyboard;
% %             print(['mean-v2-nc-ne-',num2str(k)],'-dpng','-painters','-r300');
% %                         keyboard;
%         end
%         gra_setn = new_gra_set;
        
%% gradient method 2
        idx = 1;
        for i = 1:gn
            if size(gra_set{i}.V,2) > size(gra_set{idx}.V,2)
                idx = i;
            end
        end
%         keyboard;
        gra_set = align_vertexNum(gra_set,0);
        
        mean_gra = cell(1,100);
        mean_gra{1} = gra_set{idx};
%         keyboard;
        for k = 1:MaxItr
            disp(['Iteration ',num2str(k),' ...']);
            means = mean_gra{k};
            new_gra_set = cell(1,gn);
            for i = 1:gn
                gra = gra_set{i};
                matching_pair{1} = struct('gra1',{means},'gra2',{gra},'required',{[]},'banned',{[]});
                P = get_P(matching_pair);
                P = P{1};
                gra.V = P*gra.alignV*P';
                gra.coord = action_on_coord(gra.coord,P);
%                 keyboard;
                gra = rmfield(gra,{'alignV'});
                gra = edge_registration(means,gra);
%                 keyboard;
                means = get_simpleMean({means,gra},11);
                means.alignV = means.V;
                new_gra_set{i} = gra;
%                 keyboard;
            end
            mean_gra{k+1} = get_simpleMean(new_gra_set,k);
            mean_gra{k+1}.alignV = mean_gra{k+1}.V;

        end
        gra_setn = new_gra_set;

    end
end

function [gra1,gra2] = add_coord(gra1,gra2,P)
    vn = length(P);
    c1 = 0;
    c2 = 0;
    for i = 1:vn
        j = find(P(i,:) == 1);
%         if gra1.coord(1,i) == inf && gra2.coord(1,j) ~= inf
%             gra1.coord(:,i) = gra2.coord(:,j);
%             c1 = c1 + 1;
% %             keyboard;
%         end
        if gra1.coord(1,i) ~= inf && gra2.coord(1,j) == inf
            gra2.coord(:,j) = gra1.coord(:,i);
            c2 = c2 + 1;
        end
    end
%     disp(c1);
%     disp(c2);
%     disp('---');
end

function new_coord = action_on_coord(coord,P)
    new_coord = Inf(2,length(coord));
    vn = length(P);
    for i = 1:vn
        j = find(P(i,:) == 1);
        new_coord(:,i) = coord(:,j);
    end
end