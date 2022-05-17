function dis = simple_distance(gra1,gra2)
    V1 = gra1.V; E1 = gra1.E;
    V2 = gra2.V; E2 = gra2.E;
%     coord1 = get_coord(gra1);
%     coord2 = get_coord(gra2);
%     vn = size(V1,2);
%     tmp = ones(1,vn)*-1;
%     for i = 1:vn
%         if coord1(1,i) ~= inf && coord2(1,i) ~= inf
%             tmp(i) = sqrt(sum((coord1(:,i) - coord2(:,i)).^2));
%         end
%     end
%     max_dis = max(tmp);
%     tmp(tmp == -1) = max_dis;
%     vdis = sum(tmp);
    
    vn = size(V1,2);
    tmp = zeros(vn,vn);
    for i = 1:vn
        for j = i:vn
            if V1(i,j) && V2(i,j)
                tmp(i,j) = distance(E1{V1(i,j)},E2{V2(i,j)});
            end
        end
    end
    edis = sqrt(sum(tmp.^2,'all'));
    dis = edis;
end

function val = distance(X1,X2)
    [q1] = curve_to_qnos(X1);
    [q2] = curve_to_qnos(X2);
    q1 = q1/sqrt(InnerProd_Q(q1,q1));
    q2 = q2/sqrt(InnerProd_Q(q2,q2)); 
    
    [gamI] = DynamicProgrammingQ(q2/sqrt(InnerProd_Q(q2,q2)),q1/sqrt(InnerProd_Q(q1,q1)),0,0);

    gamI = (gamI-gamI(1))/(gamI(end)-gamI(1));


    X2n = Group_Action_by_Gamma_Coord(X2,gamI);
    q2n = curve_to_qnos(X2n);
    q2n = q2n/sqrt(InnerProd_Q(q2n,q2n));

    val = real(acos(InnerProd_Q(q1,q2n)));
end