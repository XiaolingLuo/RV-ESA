function gra_set = get_geodesic(gra1,gra2,amount,isShow,idx)
%     keyboard;
    if amount < 2
        error('The length of geodesic should not be less than 3');
    end

    E_set = cell(1,amount);
    
    for i = 1:length(gra1.E)
        E_set{1}{i} = curve_to_qnos(gra1.E{i});
    end
    
    for i = 1:length(gra2.E)
        E_set{amount}{i} = curve_to_qnos(gra2.E{i});
    end
    
    vn = size(gra1.V,2);
    coord1 = get_coord(gra1);
    coord2 = get_coord(gra2);
    
    coord_set = Inf(2,vn,amount); %% determine the coordinates
    for k = 2:amount-1
%         w = (k-1+floor(amount/2))/(amount-1+floor(amount/2));
        w = (k-1)/(amount-1);
        for i = 1:vn
            if coord1(1,i) ~= inf && coord2(1,i) ~= inf
                coord_set(:,i,k) = coord1(:,i)*(1-w) + coord2(:,i)*w;
            end
        end
    end
    
    for i = 2:amount-1
        E_set{i} = cell(1,2000);
    end
    
    edge_set = zeros(10000,2);
    en = 0;
    T = size(gra1.E{1},2);
    lineWidth_set = zeros(vn,vn,amount);
    max_lineWidth = 3;
    min_lineWidth = 0.5;
    
    for i = 1:vn
        for j = i:vn
            if gra1.V(i,j) == 0 && gra2.V(i,j) == 0
                continue;
            end
            
            isHappy = 1; %% The father and mother are here
            if gra1.V(i,j) == 0
                s = zeros(2,T);
                isHappy = 0;
            else
                s = E_set{1}{gra1.V(i,j)};
            end
            if gra2.V(i,j) == 0
                e = zeros(2,T);
                isHappy = 0;
            else
                e = E_set{amount}{gra2.V(i,j)};
            end
            
            en = en + 1;
            edge_set(en,:) = [i,j];
            for k = 2:amount-1
%                 w = (k-1+floor(amount/2))/(amount-1+floor(amount/2));
                w = (k-1)/(amount-1);
                E_set{k}{en} = q_to_curve((1-w)*s + w*e);
            end
  
            if isShow == 0
                continue;
            end
            for k = 1:amount %% determining the linewidth for each curve in each graph
                if isHappy == 1
                    lineWidth_set(i,j,k) = max_lineWidth;
                else
%                     w = (k-1+floor(amount/2))/(amount-1+floor(amount/2));
                    w = (k-1)/(amount-1);
                    if gra1.V(i,j) ~= 0
                        lineWidth_set(i,j,k) = (1-w)*(max_lineWidth-min_lineWidth)+min_lineWidth;
                    else
                        lineWidth_set(i,j,k) = w*(max_lineWidth-min_lineWidth)+min_lineWidth;
                    end
                end
            end
        end
    end
    edge_set(en+1:end,:) = [];
    for i = 2:amount-1
        E_set{i}(en+1:end) = [];
    end
%     keyboard;
    gra_set = cell(1,amount);
    gra_set{1} = gra1;
    gra_set{amount} = gra2;
%     keyboard;
    for k = 2:amount-1
        gra_set{k} = connect_curves(E_set{k},edge_set,coord_set(:,:,k));
    end
%     keyboard;
    if isShow == 1
        plot_geodesic(gra_set,lineWidth_set,idx);
    end
end

function plot_geodesic(gra_set,lineWidth_set,idx)

    amount = length(gra_set);
    
%     keyboard;
    coord(:,:,1) = get_coord(gra_set{1});
    coord(:,:,2) = get_coord(gra_set{end});
    
    x_range = [1,1]*coord(1,1,1);
    y_range = [1,1]*coord(2,1,1);

    for i = 1:2
        coords = coord(:,:,i);
        for j = 1:size(coords,2)
            if coords(1,j) == inf
                continue;
            end
            x_range(1) = min(x_range(1),coords(1,j));
            x_range(2) = max(x_range(2),coords(1,j));
            y_range(1) = min(y_range(1),coords(2,j));
            y_range(2) = max(y_range(2),coords(2,j));
        end
    end

    x_range(1) = x_range(1)*0.85;
    x_range(2) = x_range(2)*1.1;
    y_range(1) = y_range(1)*0.85;
    y_range(2) = y_range(2)*1.1;

    n_color = 0;
    vn = size(gra_set{1}.V,2);
    colors = zeros(vn,vn);
    
    for i = 1:vn
        for j = i:vn
            if gra_set{1}.V(i,j) ~= 0 || gra_set{end}.V(i,j) ~= 0
                n_color = n_color + 1;
                colors(i,j) = n_color;
            end
        end
    end
    color_map = jet(n_color);
%     keyboard;
    col = 5;
    row = ceil(amount/col);
    
%     idx = input('The number of figure');
%     figure(idx);hold on;
    for k = 1:amount
        gra = gra_set{k};
%         subplot(row,col,k);
%         hold on;
        figure(idx+k-1);clf;hold on;
%         retina
%         set(gcf,'position',[300,300,550,600]);
%         set(gca,'position',[0.05 0.05 1 1]);

%         simu
        set(gcf,'position',[300,300,550,550]);
        set(gca,'position',[0.02 0.02 1.02 1.02]);
        for i = 1:vn
            for j = i:vn
                if gra.V(i,j) ~= 0
                    ee = gra.E{gra.V(i,j)};
                    if colors(i,j) > n_color
                        keyboard;
                    end
                    if colors(i,j) == 0
                        keyboard;
                    end
                    plot(ee(1,:),ee(2,:),'color',color_map(colors(i,j),:),'LineWidth',lineWidth_set(i,j,k));
%                     plot(ee(1,:),ee(2,:),'color',color_map(colors(i,j),:));
                end
            end
        end
        xlim(x_range);
        ylim(y_range);
        coord = get_coord(gra);
        for i = 1:size(coord,2)
            if coord(1,i) == inf
                continue;
            end
            plot(coord(1,i),coord(2,i),'ko','MarkerFaceColor','k','MarkerSize',3);
%             text(coord(1,i),coord(2,i),num2str(i),'FontSize',20);
        end
        axis off;
    end
    
%     print whole_nolandmark -dpng -painters -r1000;
end
