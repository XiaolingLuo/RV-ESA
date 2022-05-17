function gamI = invertGamma(gam)

N = length(gam);
x = linspace(0,1,N);
gam = (gam-gam(1))/(gam(end)-gam(1));
gamI = interp1(gam,x,x,'linear');