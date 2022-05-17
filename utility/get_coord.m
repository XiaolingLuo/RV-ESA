function coord = get_coord(input)

if class(input) == 'struct'
    vn = size(input.V,2);
    coord = Inf(2,vn);
    for i = 1:vn
        for j = i:vn
            if input.V(i,j) ~= 0
                ee = input.E{input.V(i,j)};
                if coord(1,i) == inf
%                     coord(:,i) = round(ee(:,1));
                    coord(:,i) = ee(:,1);
                else
%                     if(~all(abs(coord(:,i)-ee(:,1)) < 1e-4))
%                         disp('check!');
%                         keyboard;
%                     end
                end
                if coord(1,j) == inf
%                     coord(:,j) = round(ee(:,end));
                    coord(:,j) = ee(:,end);
                else
%                     if(~all(abs(coord(:,j)-ee(:,end)) < 1e-4))
%                         disp('check!');
%                         keyboard;
%                     end
                end
            end
        end
    end
elseif class(input) == 'double'
    vn = size(input,3);
    coord = Inf(2,vn);
    for i = 1:vn
        for j = i:vn
            ee = input(:,:,i,j);
            if ee(1,1) ~= inf
                coord(:,i) = ee(:,1);
                coord(:,j) = ee(:,end);
            end
        end
    end
end
