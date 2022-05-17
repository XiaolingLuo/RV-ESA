function curve = fit_into_nodes(node1,node2,curve_o)
    if all(node1 == node2)
        keyboard;
    end
%     keyboard;
    T = size(curve_o,2);
    curve = curve_o - repmat(curve_o(:,1),1,T);
    
    vector1 = node2 - node1;
    vector2 = curve(:,end) - curve(:,1);

    flag = 1;
    ta = acos(dot(vector1,vector2)/(norm(vector1)*norm(vector2)));
    O = [cos(ta),-sin(ta);sin(ta),cos(ta)];
    rotated = O*curve;
    vector2ed = rotated(:,end) - rotated(:,1);
    if acos(dot(vector1,vector2ed)/(norm(vector1)*norm(vector2ed))) < 1e-3
        flag = 0;
        curve = rotated;
    end

    if flag == 1
        ta = 2*pi - ta;
        O = [cos(ta),-sin(ta);sin(ta),cos(ta)];
        curve = O*curve;
    end
    
    node2s = node2 - node1;
    if abs(curve(1,end)) > 1e-3
        curve = curve*(node2s(1)/curve(1,end));
    elseif abs(curve(2,end)) > 1e-3
        curve = curve*(node2s(2)/curve(2,end));
    else
        keyboard;
        error('Please check this point!');
    end

    offset = node1 - curve(:,1);
    curve = curve + repmat(offset,1,T);
    curve = real(curve); % why the complex number is generated?
%     plot(curve(1,:),curve(2,:));
%     keyboard;
end