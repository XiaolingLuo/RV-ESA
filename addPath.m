function addPath
    footpath = cd;
    addpath(genpath([footpath '/utility']));
    
    addpath(genpath([footpath '/fgm-master/src']));
    addpath(genpath([footpath '/fgm-master/lib']));
end

