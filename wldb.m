function mass=wldb(image,bw,r)
[m,n,~]=size(image(:,:,1));
mass=zeros(size(image));
for i=1:m
    for j=1:n
        x=[i-r:i+r];
        y=[j-r:j+r];
        x=max(1,min(x,m));
        y=max(1,min(y,n));
        tmp=(image(x,y) == image(i,j));
        mass(i,j)=sum(tmp(:));
    end
end
mass=mass/(2*r+1)/(2*r+1).*bw;