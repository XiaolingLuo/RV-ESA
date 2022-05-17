function gra = merge_gra(up_gra,down_gra)

    v1n = size(up_gra.V,2);
    v2n = size(down_gra.V,2);
    e1n = length(up_gra.E);
    e2n = length(down_gra.E);
    
    vn = v1n+v2n;
    V = zeros(vn,vn);
    V(1:v1n,1:v1n) = up_gra.V;
%     keyboard;
    down_gra.V(down_gra.V~=0) = down_gra.V(down_gra.V~=0) + e1n;
%     keyboard;
    V(v1n+1:end,v1n+1:end) = down_gra.V;
    E = cell(1,e1n+e2n);
    E(1:e1n) = up_gra.E; 
    E(e1n+1:end) = down_gra.E;
    gra = struct('V',{V},'E',{E});
    gra.coord = get_coord(gra);
%     keyboard;
end

