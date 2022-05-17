function [V,E] = rid_H(V,E)

n_threshold = 6;
N = 50;
select_len = floor(N/2);
angle_threshold = 2.7;
en = size(E,2);

while 1
    vn = size(V,2);
    deg = get_degree(V);
    tag = 0;
    cord = get_coord(struct('V',{V},'E',{E}));
    for i = 1:vn
        for j = i:vn
            if ~V(i,j) || size(E{V(i,j)},2) > n_threshold || deg(i) ~= 3 || deg(j) ~= 3
                continue;
            end
%             keyboard;
            points = zeros(2,4);
            cnt = 0;
            for k = 1:vn
                if k ~= j && V(i,k) ~= 0
                    cnt = cnt + 1;
                    points(1,cnt) = k;
                end
            end
            for k = 1:vn
                if k ~= i && V(j,k) ~= 0
                    cnt = cnt + 1;
                    points(1,cnt) = k;
                end
            end
            sort_points = sort(points(1,:));
            flag = 1;
            for k = 2:4
                if sort_points(k) == sort_points(k-1)
                    disp('weird!');
                    flag = 0;
                    break;
                end
            end
            if flag == 0
                continue;
            end
%             keyboard;
            figure(56565);clf;hold on;
            ee = E{V(i,j)};
            plot(ee(1,:),ee(2,:));
            ee = E{V(i,points(1,1))};
            plot(ee(1,:),ee(2,:));
            ee = E{V(i,points(1,2))};
            plot(ee(1,:),ee(2,:));
            ee = E{V(j,points(1,3))};
            plot(ee(1,:),ee(2,:));
            ee = E{V(j,points(1,4))};
            plot(ee(1,:),ee(2,:));
%             keyboard;
            text(cord(1,i),cord(2,i),num2str(i));
            text(cord(1,j),cord(2,j),num2str(j));
            text(cord(1,points(1,1)),cord(2,points(1,1)),num2str(points(1,1)));
            text(cord(1,points(1,2)),cord(2,points(1,2)),num2str(points(1,2)));
            text(cord(1,points(1,3)),cord(2,points(1,3)),num2str(points(1,3)));
            text(cord(1,points(1,4)),cord(2,points(1,4)),num2str(points(1,4)));
%             keyboard;
            vecs = zeros(2,4);
            for k = 1:2
%                 disp([num2str(V(i,points(1,k))),'-',num2str(size(E,2))]);
                edge = resampling(E{V(i,points(1,k))},N);
%                 keyboard;
%                 turning_point(edge);
%                 disp([num2str(V(j,points(1,3))),'-',num2str(size(E,2))]);
                vecs(:,k) = mean(edge(:,1:select_len),2) - edge(:,1);
            end
            for k = 3:4
                edge = resampling(E{V(j,points(1,k))},N);
%                 turning_point(edge);
                vecs(:,k) = mean(edge(:,1:select_len),2) - edge(:,1);
            end
            flag = 1;
            disp([num2str(points(1,1)),' ',num2str(points(1,2)),' ',num2str(points(1,3)),' ',num2str(points(1,4))]);
            for k = 3:4
                temp = [cal_angle(vecs(:,1),vecs(:,k)),cal_angle(vecs(:,2),vecs(:,k))];
                [val,idx] = max(temp);
                disp(['val:',num2str(val),' idx:',num2str(idx)]);
                if val < angle_threshold
                    flag = 0;
                end
                points(2,idx) = points(1,k);
            end
%             keyboard;
            if points(2,1) == 0 || points(2,2) == 0
                flag = 0;
            end
            if flag == 0
                continue;
            else
                tag = 1;
                disp('yes!');
                break;
            end
        end
        if tag == 1
            break;
        end
    end
%     keyboard;
    if tag == 0
        break;
    end
%     figure(5555);clf;hold on;
%     ee = E{V(i,j)};
%     plot(ee(1,:),ee(2,:));
%     ee = E{V(i,points(1,1))};
%     plot(ee(1,:),ee(2,:));
%     ee = E{V(i,points(1,2))};
%     plot(ee(1,:),ee(2,:));
%     ee = E{V(j,points(1,3))};
%     plot(ee(1,:),ee(2,:));
%     ee = E{V(j,points(1,4))};
%     plot(ee(1,:),ee(2,:));
% %     keyboard;
%     text(cord{i}(1),cord{i}(2),num2str(i));
%     text(cord{j}(1),cord{j}(2),num2str(j));
%     text(cord{points(1,1)}(1),cord{points(1,1)}(2),num2str(points(1,1)));
%     text(cord{points(1,2)}(1),cord{points(1,2)}(2),num2str(points(1,2)));
%     text(cord{points(1,3)}(1),cord{points(1,3)}(2),num2str(points(1,3)));
%     text(cord{points(1,4)}(1),cord{points(1,4)}(2),num2str(points(1,4)));
%     keyboard;
%     keyboard;
%     keyboard;
    for k = 1:2
        s = points(1,k); e = points(2,k);
        ee = [E{V(s,i)}(:,1:end-1),E{V(j,e)}(:,2:end)];
        V(s,e) = en + 1;
        V(e,s) = en + 2;
        E{en+1} = ee;
        E{en+2} = fliplr(ee);
        en = en + 2;
    end
    V(i,:) = [];
    V(:,i) = [];
    V(j,:) = [];
    V(:,j) = [];
%     keyboard;
end

[V,E] = rearrange(V,E);
end

function val = cal_angle(v1,v2)

val = real(acos(dot(v1,v2)/(norm(v1)*norm(v2))));

end

function idx = turning_point(edge)
%     keyboard;
    N = size(edge,2);
    vecs = zeros(2,N);
    for i = 2:N
        vecs(:,i) = edge(:,i) - edge(:,1);
    end
    angle = zeros(1,N);
    for i = 3:N
        angle(:,i) = cal_angle(vecs(:,i),vecs(:,2));
    end
    keyboard;
    angle(:,1:2) = [];
    TF = ischange(angle,'mean');
    idx = find(TF==1);
    keyboard;
    if length(idx) == 0
        idx = -1;
    else
        idx = idx(1);
    end
    keyboard;
end