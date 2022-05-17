function [mean_gra] = get_simpleMean(gra_set,idx)
    gn = length(gra_set);
%     keyboard;
    q_set = cell(1,gn);
    for i = 1:gn
        for j = 1:length(gra_set{i}.E)
            q_set{i}{j} = curve_to_qnos(gra_set{i}.E{j});
        end
    end
    
%     for j = 1:length(old_mean.E)
%         old_mean_q{j} = curve_to_qnos(old_mean.E{j});
%     end
%     keyboard;
    vn = size(gra_set{1}.V,2);
    
    
    exist_num = zeros(vn,vn);
    freq = zeros(1,gn);

    for i = 1:vn
        for j = i:vn
            for k = 1:gn
                if gra_set{k}.V(i,j) ~= 0
                    exist_num(i,j) = exist_num(i,j) + 1;
                end
            end
            if exist_num(i,j) > 0
                freq(exist_num(i,j)) = freq(exist_num(i,j)) + 1;
            end
        end
    end

%     figure(1);clf;
%     bar(freq);
%     print(['freq-v2-nc-ne-',num2str(idx)],'-dpng','-painters','-r300');
    
    mean_E = 0;
    for i = 1:gn
        mean_E = mean_E + length(gra_set{i}.E);
    end
    mean_E = ceil(mean_E/gn/2);
    
    sum = 0;
    for thd = gn:-1:1
        sum = sum + freq(thd);
        if sum >= 1.5*mean_E % this parameter can change                        
            break;
        end
    end
%     keyboard;
    mean_E = cell(1,2000);
    edge_set = zeros(2000,2); en = 0;
    T = size(gra_set{1}.E{1},2);
    
    
    for i = 1:vn
        for j = i:vn
%             qs_sum = zeros(2,T);
%             for k = 1:gn
%                 if gra_set{k}.V(i,j) ~= 0
%                     e_idx = gra_set{k}.V(i,j);
%                     qs_sum = qs_sum + q_set{k}{e_idx};
% %                 elseif old_mean.V(i,j) ~= 0
% %                     e_idx = old_mean.V(i,j);
% %                     qs_sum = qs_sum + old_mean_q{e_idx};
%                 end
%             end
%             if exist_num(i,j) >= thd
%                 en = en + 1;
%                 edge_set(en,:) = [i,j];
%                 mean_E{en} = q_to_curve(qs_sum/gn);
%             end

            qs_sum_set = [];
            cnt = 0;
            for k = 1:gn
                if gra_set{k}.V(i,j) ~= 0
                    e_idx = gra_set{k}.V(i,j);
                    cnt = cnt + 1;
                    qs_sum_set(:,:,cnt) = q_set{k}{e_idx};
                end
            end
            if exist_num(i,j) >= 1
                en = en + 1;
                edge_set(en,:) = [i,j];
                mean_E{en} = q_to_curve(median(qs_sum_set,3));
            end
        end
    end
    
    edge_set(en+1:end,:) = [];
    mean_E(en+1:end) = [];
    
    coord_set = cell(1,gn);
    for i = 1:gn
%         coord_set{i} = gra_set{i}.coord;
        coord_set{i} = get_coord(gra_set{i});
    end
    
%     coord = Inf(2,vn);
%     for i = 1:vn
%         exists = 0;
%         new_coord = zeros(2,1);
%         for k = 1:gn
%             if coord_set{k}(1,i) ~= inf
%                 exists = exists + 1;
%                 new_coord = new_coord + coord_set{k}(:,i);
%             end
%         end
%         if exists > 0
%             coord(:,i) = round(new_coord/exists);
%         else
% %             keyboard;
%         end
%     end

    coord = Inf(2,vn);
    for i = 1:vn
        one_coord = [];
        cnt = 0;
        for k = 1:gn
            if coord_set{k}(1,i) ~= inf
                cnt = cnt + 1;
                one_coord(:,cnt) = coord_set{k}(:,i);
            end
        end
        if cnt > 0
            coord(:,i) = median(one_coord,2);
        end
    end
    
    mean_gra = connect_curves(mean_E,edge_set,coord);
    
    mean_gra.coord = coord;
%     plot_graph(mean_gra,222);
%     keyboard;
end



% function [mean_gra,exist_num] = get_simpleMean(gra_set)
%     gn = length(gra_set);
%     
%     curves_set = cell(1,gn);
%     qs_set = curves_set;
%     for i = 1:gn
%         [curves_set{i},qs_set{i}] = to_curves_qs(gra_set{i});
%     end
% 
%     vn = size(gra_set{1}.V,2);
%     mean_qs = Inf(size(qs_set{1}));
%     T = size(qs_set{1},2);
%     
%     edge_set = zeros(10000,2); en = 0;
%     exist_num = zeros(vn,vn);
%     freq = zeros(1,gn);
%     mean_E = 0;
%     for i = 1:gn
%         mean_E = mean_E + length(gra_set{i}.E);
%     end
%     mean_E = ceil(mean_E/gn/2);
% %     keyboard;
%     for i = 1:vn
%         for j = i:vn
%             for k = 1:gn
%                 if qs_set{k}(1,1,i,j) ~= inf
%                     exist_num(i,j) = exist_num(i,j) + 1;
%                 end
%             end
%             if exist_num(i,j) > 0
%                 freq(exist_num(i,j)) = freq(exist_num(i,j)) + 1;
%             end
%         end
%     end
%     sum = 0;
% %     keyboard;
%     for k = gn:-1:1
%         sum = sum + freq(k);
%         if sum >= mean_E % this parameter can change
%             break;
%         end
%     end
%     for i = 1:vn
%         for j = i:vn
%             qs_sum = zeros(2,T);
%             for t = 1:gn
%                 if qs_set{t}(1,1,i,j) ~= inf
%                     qs_sum = qs_sum + qs_set{t}(:,:,i,j);
%                 end
%             end
%             if exist_num(i,j) >= k
%                 mean_qs(:,:,i,j) = qs_sum/exist_num(i,j);
%                 en = en + 1;
%                 edge_set(en,:) = [i,j];
%             end
%         end
%     end
% %     keyboard;
%     edge_set(en+1:end,:) = [];
% %     keyboard;
%     mean_curves = qs_to_curves(mean_qs);
%     
%     coord_set = cell(1,gn);
%     for i = 1:gn
%         coord_set{i} = get_coord(gra_set{i});
%     end
% %     keyboard;
%     coord = Inf(2,vn);
%     for i = 1:vn
%         exists = 0;
%         new_coord = zeros(2,1);
%         for k = 1:gn
%             if coord_set{k}(1,i) ~= inf
%                 exists = exists + 1;
%                 new_coord = new_coord + coord_set{k}(:,i);
%             end
%         end
%         if exists > 0
%             coord(:,i) = round(new_coord/exists);
%         else
%             keyboard;
%         end
%     end
% %     keyboard;
%     mean_curves = connect_curves(mean_curves,edge_set,coord);
% %     keyboard;
%     mean_gra = to_VE(mean_curves);
%     mean_gra.coord = coord;
% %     keyboard;
%     exist_num(exist_num == 0) = inf;
%     min_val = min(exist_num,[],'all');
%     exist_num(exist_num == inf) = min_val;
%     exist_num = reshape(mapminmax(exist_num(:)',0,1),vn,vn);
% end

function curves = qs_to_curves(qs)
    curves = qs;
    vn = size(curves,3);
    for i = 1:vn
        for j = i:vn
            if qs(1,1,i,j) == inf
                continue;
            end
            curves(:,:,i,j) = q_to_curve(qs(:,:,i,j));
        end
    end
end

function gra = to_VE(curves)
    vn = size(curves,3);
    en = 0;
    E = cell(1,10000);
    V = zeros(vn,vn);
    
    for i = 1:vn
        for j = i:vn
            if curves(1,1,i,j) == inf
                continue;
            end
            E{en+1} = curves(:,:,i,j);
            E{en+2} = fliplr(E{en+1});
            V(i,j) = en+1;
            V(j,i) = en+2;
            en = en+2;
        end
    end
    E(en+1:end) = [];
    gra.V = V;
    gra.E = E;
end