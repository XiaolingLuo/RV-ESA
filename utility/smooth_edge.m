function E = smooth_edge(E)
% keyboard;
if strcmp(class(E),'cell')
    en = length(E);

    for i = 1:en
        ee = E{i};
        span = round(size(ee,2)/10);
        if span < 5
            span = 5;
        end
        if mod(span,2) == 0
            span = span + 1;
        end
        ee(1,:) = smooth(ee(1,:),span);
        ee(2,:) = smooth(ee(2,:),span);
        E{i} = ee;
    end
elseif strcmp(class(E),'double')
    span = round(size(E,2)/10);
    if span < 5
        span = 5;
    end
    if mod(span,2) == 0
        span = span + 1;
    end
    E(1,:) = smooth(E(1,:),span);
    E(2,:) = smooth(E(2,:),span);
end
