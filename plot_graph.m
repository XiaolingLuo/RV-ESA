function plot_graph(input,idx,varargin)
    min_lineWidth = 0.5;
    max_lineWidth = 3.5;
    if strcmp(class(input),'struct')
        vn = size(input.V,2);
        lineWidth = ones(vn,vn)*(max_lineWidth+min_lineWidth)/2;
        if length(varargin) == 1
            lineWidth = varargin{1}*(max_lineWidth-min_lineWidth) + min_lineWidth;
        end
        figure(idx);clf;hold on;
        en = length(input.E)/2;
        cc = hsv(en);
        cnt = 1;
        for i = 1:vn
            for j = i:vn
                if ~input.V(i,j)
                    continue;
                end
                ee = input.E{input.V(i,j)};
                plot(ee(1,:),ee(2,:),'color',cc(cnt,:),'LineWidth',3);
                cnt = cnt + 1;
            end
        end
        coord = get_coord(input);
        for i = 1:size(coord,2)
            plot(coord(1,i),coord(2,i),'ko','MarkerFaceColor','k','MarkerSize',3);
%             text(coord(1,i),coord(2,i),num2str(i),'FontSize',20);
        end
        axis off;
%         xlim([60,480]);
%         ylim([280,640]);
%         set(gcf,'position',[300,300,400,400]);
%         set(gca,'position',[0 0 1 1]); %x,y,width,height
% %         print 28-trunk-curve -dpng -painters -r300;
%         keyboard;
%         set(gcf,'position',[50,50,1800,800]);
        set(gcf,'position',[300,300,500,500]);
        set(gca,'position',[0.0 0.0 1 1]);
%         print retina-mean-5 -dpng -painters -r1000;
    elseif strcmp(class(input),'double')
        vn = size(input,3);
        lineWidth = ones(vn,vn)*(max_lineWidth+min_lineWidth)/2;
        if length(varargin) == 1
            lineWidth = varargin{1}*(max_lineWidth-min_lineWidth) + min_lineWidth;
        end
        figure(idx);clf;hold on;
        for i = 1:vn
            for j = i:vn
                ee = input(:,:,i,j);
                if ee(1,1) ~= inf
                    plot(ee(1,:),ee(2,:),'b','LineWidth',lineWidth(i,j));
                end
            end
        end
        axis off;
        set(gcf,'position',[300,300,500,500]);
%         set(gca,'position',[0 0 1.05 1.05]); %x,y,width,height
    elseif strcmp(class(input),'cell')
        gn = length(input);
        gra = input{1};
        vn = length(gra.V);
        cnt = 0;
        color_mat = zeros(vn,vn);
        for i = 1:vn
            for j = i:vn
                for k = 1:gn
                    if input{k}.V(i,j) ~= 0
                        cnt = cnt + 1;
                        color_mat(i,j) = cnt;
                        break;
                    end
                end
            end
        end
        cc = hsv(cnt);
%         keyboard;
        for k = 1:gn
            figure(k);clf;hold on;
            gra = input{k};
            vn = length(gra.V);
            for i = 1:vn
                for j = i:vn
                    if ~gra.V(i,j)
                        continue;
                    end
                    ee = gra.E{gra.V(i,j)};
                    plot(ee(1,:),ee(2,:),'color',cc(color_mat(i,j),:),'LineWidth',3);
                end
            end
            coord = get_coord(gra);
            for i = 1:size(coord,2)
                plot(coord(1,i),coord(2,i),'ko','MarkerFaceColor','k','MarkerSize',3);
%                 text(coord(1,i),coord(2,i),num2str(i));
            end
            axis off;
%             /home/zhang/myCode/V2/simu-1-geodesic-1.png
            ylim([250,640]);
            xlim([100,450]);

%             xlim([60,480]);
%             ylim([600,900]);
                %retina
%             set(gcf,'position',[300,300,400,400]);
%             set(gca,'position',[0 0.02 1 1]); %x,y,width,height
            
            set(gcf,'position',[300,300,500,500]);
            set(gca,'position',[0 0 1 1]);
            print(['simu-pc1-',num2str(k)],'-dpng','-painters','-r1000');
            keyboard;
        end
        
%         set(gca,'position',[0 0 1.05 1.05]); %x,y,width,height
    end
%     coord = get_coord(input);
%     for i = 1:vn
% %         plot(coord(1,i),coord(2,i),'ro','MarkerFaceColor','k');
%         if coord(1,1) == inf
%             continue;
%         end
%         text(coord(1,i),coord(2,i),num2str(i),'FontSize',12);
%     end
%     keyboard;
    drawnow;
%     keyboard;
end