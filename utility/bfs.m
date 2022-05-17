function which = bfs(start,label,gra)

    visited = Inf(size(label));
    queue = Inf(1,1000); head = 1;rear = 1;
    queue(rear) = start; rear = rear + 1;
    visited(start) = 1;
    
    flag = 0;
    vn = length(label);
    while ~flag
        if head == rear
            disp('check!');
            which = inf;
%             keyboard;
            return;
        end
        right = rear;
        for i = head:right-1
            rt = queue(head);
            head = head+1;
            for j = 1:vn
                if gra.V(rt,j) ~= 0
                    if label(j) == 1 && ~flag
                        which = 2;
                        flag = 1;
                        break;
                    end
                    if label(j) == -1 && ~flag
                        which = -2;
                        flag = 1;
                        break;
                    end
                    if visited(j) == inf
                        queue(rear) = j;
                        rear = rear+1;
                        visited(j) = 1;
                    end
                end
            end
            if flag == 1
                break;
            end
        end
    end
end

function count = search(start, label, gra, which)
    visited = Inf(size(label));
    queue = Inf(1,1000); head = 1;rear = 1;
    queue(rear) = start; rear = rear + 1;
    visited(start) = 1;
    
    flag = 0;
    vn = length(label);
    count = 1;
    while ~flag
        if head == rear
            disp('check!');
            count = -1;
            keyboard;
            return;
        end
        right = rear;
        for i = head:right-1
            rt = queue(head);
            head = head+1;
            for j = 1:vn
                if gra.V(rt,j) ~= 0
                    if label(j) == which && ~flag
                        flag = 1;
                        break;
                    end
                    if visited(j) == inf
                        queue(rear) = j;
                        rear = rear+1;
                        visited(j) = 1;
                    end
                end
            end
            if flag == 1
                break;
            end
        end
        count = count + 1;
    end
end