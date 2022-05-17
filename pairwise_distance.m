function d = pairwise_distance(gra1,gra2,isUpDown,varargin)
    gra1.E = smooth_edge(edge_resample(gra1.E,30));
    gra2.E = smooth_edge(edge_resample(gra2.E,30));
    
    
    result = align_vertexNum({gra1,gra2},1);
    gra1n = result{1};
    gra2n = result{2};
%             keyboard;
    [gra2n,P] = align_byUpDown(gra1n,gra2n);
    gra1n = struct('V',gra1n.V(3),'E',gra1n.E(3));
    gra2n = struct('V',gra2n.V(3),'E',gra2n.E(3));
    gra2n = edge_registration(gra1n,gra2n);
    d = simple_distance(gra1n,gra2n);
end

