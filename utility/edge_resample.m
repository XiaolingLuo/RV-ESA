function E = edge_resample(E,N)

for i = 1:length(E)
    E{i} = resampling(E{i},N);
end
