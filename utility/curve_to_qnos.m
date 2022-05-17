function [q,len] = curve_to_qnos(p)

[n,N] = size(p);
%对于参数化曲线beta(t) = (x(t),y(t))，其导数等于(x'(t),y'(t))
for i = 1:n
    v(i,:) = gradient(p(i,:),1/(N-1));
end
% keyboard;
for i = 1:N %求出曲线的SRVF函数,q(t) = beta'(t)/sqrt(||beta'(t)||)
    L(i) = sqrt(norm(v(:,i)));
    if L(i) > 0.0001
        q(:,i) = v(:,i)/L(i);
    else
        q(:,i) = v(:,i)*0.0001; %%%%%% 除法？
    end
end

% keyboard;