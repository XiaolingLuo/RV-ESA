function [outputArg1,outputArg2] = model(gra_set)
    gn = length(gra_set);
%     for i = 1:gn
%         gra_set{i}.E = edge_resample(gra_set{i}.E,10);
%     end
    q_set = cell(1,gn);
    coord_set = cell(1,gn);
    for i = 1:gn
        for j = 1:length(gra_set{i}.E)
            q_set{i}{j} = curve_to_qnos(gra_set{i}.E{j});
        end
        coord_set{i} = get_coord(gra_set{i});
    end
    
    [mean_gra] = get_simpleMean(gra_set,0);
    
    mean_q = mean_gra.E;
    for j = 1:length(mean_gra.E)
        mean_q{j} = curve_to_qnos(mean_gra.E{j});
    end
    
    mean_coord = mean_gra.coord;
    
    vn = size(gra_set{1}.V,2);
    T = size(gra_set{1}.E{1},2);
    
    n = length(find(mean_gra.V ~= 0))/2;
    keyboard;
    eigen_Mat = zeros(gn,2*T*n+2*vn);
    for k = 1:gn
        shooting_vector = zeros(2*T,n);
        exist_n = 0;
        for i = 1:vn
            for j = i:vn
                if mean_gra.V(i,j) == 0
                    continue;
                end
                exist_n = exist_n + 1;
                if gra_set{k}.V(i,j) == 0
                    q = zeros(2,T);
                else
                    e_idx = gra_set{k}.V(i,j);
                    q = q_set{k}{e_idx};
                end
                v = q - mean_q{mean_gra.V(i,j)};
                shooting_vector(:,exist_n) = [v(1,:),v(2,:)];
            end
        end
        coord_offset = coord_set{k} - mean_coord;
        coord_offset(abs(coord_offset) == inf) = 0; 
        coord_offset(isnan(coord_offset)) = 0; 
%         keyboard;
        eigen_Mat(k,:) = [shooting_vector(:)',coord_offset(1,:),coord_offset(2,:)];
%         eigen_Mat(k,:) = shooting_vector(:)';
    end
    K = cov(eigen_Mat);
    keyboard;
%     [U,~,~] = svd(K);
    load U.mat;
    keyboard;
    c = Inf(gn,length(eigen_Mat));
    for i = 1:gn
        for j = 1:length(eigen_Mat)
            c(i,j) = dot(eigen_Mat(i,:)',U(:,j));
        end
    end
    keyboard;
    
    mu = zeros(1,length(eigen_Mat)); sigma = cov(c);
    n = 15;
    simu_c = mvnrnd(mu,sigma/50,n);
    
    E_set = cell(1,n);
    for i = 1:n
        E_set{i} = cell(1,2000);
    end
    edge_set = zeros(2000,2);
    new_coord_set = cell(1,n);
    
    for k = 1:n
        en = 0;
        u = zeros(1,length(eigen_Mat));
        for j = 1:length(eigen_Mat)
            u = u + simu_c(k,j)*U(:,j)';
        end
        for i = 1:vn
            for j = i:vn
                if mean_gra.V(i,j) == 0
                    continue;
                end
                en = en + 1;
                v = u((en-1)*2*T+1:en*2*T);
                v = [v(1:T);v(T+1:end)];
                E_set{k}{en} = q_to_curve(mean_q{mean_gra.V(i,j)} + v);
                if k == 1
                    edge_set(en,:) = [i,j];
                end
            end
        end
        E_set{k}(en+1:end) = [];
        if k == 1
            edge_set(en+1:end,:) = [];
        end
%         keyboard;
        coord_offset = u(en*2*T+1:end);
%         keyboard;
        new_coord_set{k} = mean_coord + [coord_offset(1:vn);coord_offset(vn+1:end)];
    end
    keyboard;
    model_set = cell(1,n);
    for i = 1:n
        model_set{i} = connect_curves(E_set{i},edge_set,new_coord_set{i});
    end
    keyboard;
end

