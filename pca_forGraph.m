function pca_score = pca_forGraph(gra_set)

    gn = length(gra_set);
    for i = 1:gn
        gra_set{i}.E = edge_resample(gra_set{i}.E,20);
    end
    q_set = cell(1,gn);
    coord_set = cell(1,gn);
    for i = 1:gn
        for j = 1:length(gra_set{i}.E)
            q_set{i}{j} = curve_to_qnos(gra_set{i}.E{j});
        end
        coord_set{i} = get_coord(gra_set{i});
    end
    
    [mean_gra] = get_simpleMean(gra_set);

    mean_gra.E = edge_resample(mean_gra.E,20);

    mean_q = mean_gra.E;
    for j = 1:length(mean_gra.E)
        mean_q{j} = curve_to_qnos(mean_gra.E{j});
    end
    
    mean_coord = mean_gra.coord;
    
    vn = size(gra_set{1}.V,2);
    T = size(gra_set{1}.E{1},2);
    
    n = length(find(mean_gra.V ~= 0))/2;
%     keyboard;
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
        coord_offset = zeros(size(mean_coord));
        for j = 1:size(mean_coord,2)
            if coord_set{k}(1,j) ~= inf && mean_coord(1,j) ~= inf
                coord_offset(:,j) = coord_set{k}(:,j) - mean_coord(:,j);
            end
        end
        eigen_Mat(k,:) = [shooting_vector(:)',coord_offset(1,:),coord_offset(2,:)];
%         find(isnan(eigen_Mat(k,:)))
%         eigen_Mat(k,:) = [shooting_vector(:)'];
%         keyboard;
    end
    K = cov(eigen_Mat);
    [U,S,~] = svd(K);
    s = sqrt(diag(S));
    figure(888);clf;
    plot(s,'b--o');
    title('determine the dimension after dimensionality reduction');
    new_n = find(s >= 1e-2);
    new_n = new_n(end);
    text(new_n, s(new_n), 'key point');
    idx = input('Which principal direction:');
    t_valSet = -2:1:2;
    tn = length(t_valSet);
    
    E_set = cell(1,tn);
    for i = 1:tn
        E_set{i} = cell(1,2000);
    end
    edge_set = zeros(2000,2);
    new_coord_set = cell(1,tn);
    
    for k = 1:length(t_valSet)
        shooting_vector = t_valSet(k)*s(idx)*U(:,idx)'/2;
        en = 0;
        for i = 1:vn
            for j = i:vn
                if mean_gra.V(i,j) == 0
                    continue;
                end
                en = en + 1;
                v = shooting_vector((en-1)*2*T+1:en*2*T);
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
        coord_offset = shooting_vector(exist_n*2*T+1:end);
        new_coord_set{k} = mean_coord + [coord_offset(1:vn);coord_offset(vn+1:end)];
%         new_coord_set{k} = mean_coord;
%         keyboard;
    end
%     keyboard;
%     variabiliy_set = cell(1,tn);
%     for i = 1:tn
%         variabiliy_set{i} = connect_curves(E_set{i},edge_set,new_coord_set{i});
%     end
%     
%     plot_graph(variabiliy_set,258);
    pca_score = zeros(gn,new_n);
    for i = 1:gn
        for j = 1:new_n % new_n depends on s 
            pca_score(i,j) = dot(eigen_Mat(i,:),U(:,j)');
        end
    end
end