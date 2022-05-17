function result_P = get_P(matching_set)

    KPKQ_set = cell(1,length(matching_set));
    for i = 1:length(matching_set)
%         matching_set{i}.gra1 = add_virtualEdge(matching_set{i}.gra1);
%         matching_set{i}.gra2 = add_virtualEdge(matching_set{i}.gra2);
        [KP,KQ] = affinityK(matching_set{i}.gra1,matching_set{i}.gra2);
        required = matching_set{i}.required;
        for j = 1:size(required,1)
            KP(required(j,1),required(j,2)) = 1e+8;
        end
        KPKQ_set{i}.KP = KP;
        KPKQ_set{i}.KQ = KQ;
    end
    
%     keyboard;
    par = struct('nAlp',101,'nItMa',100,'ip','n','deb','n','lamQ',0.5);
    result_P = cell(1,length(matching_set));
    
    parfor i = 1:length(result_P)
        gra1 = matching_set{i}.gra1; gra2 = matching_set{i}.gra2;
        
        gphs = cell(1,2);
        [G,H] = get_GH(gra1); gphs{1} = struct('G',G,'H',H);
        [G,H] = get_GH(gra2); gphs{2} = struct('G',G,'H',H);
        
        banned = matching_set{i}.banned;
        Ct = ones(size(KPKQ_set{i}.KP));
        for j = 1:length(banned)
            Ct(banned{j}{1},banned{j}{2}) = 0;
        end
        
        asgFgmD = fgmD(1*KPKQ_set{i}.KP, 0.5*KPKQ_set{i}.KQ, Ct, gphs, par);
        P = asgFgmD.X;
        
        [v1n,v2n] = size(P);
        vn = size(gra1.alignV,2);
        new_P = zeros(vn,vn);
        new_P(1:v1n,1:v2n) = P;
        left_index = [];
        right_index = [];
        if v1n < v2n
            left_index = v1n+1:vn;
            sum_of_row = sum(P,1);
            right_index = [find(sum_of_row == 0),v2n+1:vn];
    %         keyboard;
        elseif v2n < v1n
            right_index = v2n+1:vn;
            sum_of_col = sum(P,2);
            left_index = [find(sum_of_col == 0),v1n+1:vn];
    %         keyboard;
        end
        for j = 1:length(left_index)
            new_P(left_index(j),right_index(j)) = 1;
        end
        result_P{i} = new_P;
    end
%     keyboard;
end

function [KP,KQ] = affinityK(gra1,gra2)
%     keyboard;
    V1 = gra1.V; E1 = gra1.E; coord1 = gra1.coord;
    V2 = gra2.V; E2 = gra2.E; coord2 = gra2.coord;
    
    v1n = size(V1,2);
    v2n = size(V2,2);

    KP = zeros(v1n,v2n);

%     keyboard;
    parfor i = 1:v1n
        for j = 1:v2n
            if coord1(1,i) ~= inf && coord2(1,j) ~= inf
                KP(i,j) = sqrt(sum((coord1(:,i) - coord2(:,j)).^2));
%                 KP(i,j) = sum(abs(coord1(:,i)-coord2(:,j)));
            elseif coord1(1,i) == inf && coord2(1,j) == inf
                KP(i,j) = -1;
            else
                KP(i,j) = nan;
            end
        end
    end
%     keyboard;
%     aver_dis = mean(KP,'all','omitnan');
    max_dis = max(KP,[],'all');
    KP(KP == -1) = max_dis;
    min_dis = min(KP,[],'all');
%     keyboard;
    KP(isnan(KP)) = (min_dis+max_dis)*0.5;
%     KP(KP == -1) = max_dis;
    KP = max_dis - KP;
    
    e1n = size(E1,2);
    e2n = size(E2,2);

    % EE2 = E2;
    % O = getRotation(E1,EE2);
    % keyboard;
    KQ = zeros(e1n,e2n);
    parfor i = 1:e1n
        for j = 1:e2n
            KQ(i,j) = (aligned_innerProd(E1{i},E2{j})+aligned_innerProd(E2{j},E1{i}))/2;
            if isnan(KQ(i,j))
                keyboard;
            end
        end
    end
    max_dis = max(KQ,[],'all');
%     KP(KP == -1) = max_dis;
    KQ = max_dis - KQ;
    
%     keyboard;
    KP = reshape(mapminmax(KP(:)',0,1),v1n,v2n);
    KQ = reshape(mapminmax(KQ(:)',0,1),e1n,e2n);
end

function val = aligned_innerProd(X1,X2)

    [q1] = curve_to_qnos(X1);
    [q2] = curve_to_qnos(X2);
%     q1 = q1/sqrt(InnerProd_Q(q1,q1));
%     q2 = q2/sqrt(InnerProd_Q(q2,q2));

    % A = q1*q2';
    % [U,S,V] = svd(A);
    % if det(A)> 0
    %     O = U*V';
    % else
    %     O = U*([V(:,1) -V(:,2)])';
    % end

    % X2 = O*X2;
    % q2 = O*q2;

    [gam1] = DynamicProgrammingQ(q2/sqrt(InnerProd_Q(q2,q2)),q1/sqrt(InnerProd_Q(q1,q1)),0,0);
    gam1 = (gam1-gam1(1))/(gam1(end)-gam1(1));
    
    [gam2] = DynamicProgrammingQ(q1/sqrt(InnerProd_Q(q1,q1)),q2/sqrt(InnerProd_Q(q2,q2)),0,0);
    gam2 = invertGamma(gam2);
    
%     keyboard;
    gamI = (gam1+gam2)/2;
    
    X2n = Group_Action_by_Gamma_Coord(X2,gamI);
    q2n = curve_to_qnos(X2n);
%     q2n = q2n/sqrt(InnerProd_Q(q2n,q2n));
    v = q2n - q1;
    val = sqrt(InnerProd_Q(v,v));
%     val = real(acos(InnerProd_Q(q1,q2n)));
%     val = InnerProd_Q(q1,q2n);
end

function [G,H] = get_GH(gra)

    vn = size(gra.V,2);
    en = length(gra.E);
    G = zeros(vn,en);
    H = zeros(vn,en);

    for i = 1:vn
        for j = i+1:vn
            if ~gra.V(i,j)
                continue;
            end
            G(i,gra.V(i,j)) = 1;
            H(j,gra.V(i,j)) = 1;
            G(j,gra.V(j,i)) = 1;
            H(i,gra.V(j,i)) = 1;
        end
    end
end