function Xn = resampling(X,N)%no change to parametrization



    [n,T] = size(X);

    del=linspace(0,1,T);
    
    newdel = linspace(0,1,N);
    for j=1:n
        Xn(j,:) = interp1(del,X(j,1:T),newdel,'linear');
    end
    
    