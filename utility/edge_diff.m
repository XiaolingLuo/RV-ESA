function sample = edge_diff(sample, mean) % sample - mean
    coord2 = get_coord(sample);
    vn = size(mean.V,2);
    for i = 1:vn
        for j = i:vn
            if mean.V(i,j) == 0 || sample.V(i,j) == 0
                continue;
            end
            q = curve_to_qnos(sample.E{sample.V(i,j)}) - curve_to_qnos(mean.E{mean.V(i,j)});
            curve = q_to_curve(q);
            if all(curve(:,1)-curve(:,2) > 1e-2)                
                curve = fit_into_nodes(coord2(:,i),coord2(:,j),curve);
                sample.E{sample.V(i,j)} = curve;
                sample.E{sample.V(j,i)} = fliplr(curve);
            end
        end
    end
end

