function [q,len] = curve_to_qnos(p)

[n,N] = size(p);
%���ڲ���������beta(t) = (x(t),y(t))���䵼������(x'(t),y'(t))
for i = 1:n
    v(i,:) = gradient(p(i,:),1/(N-1));
end
% keyboard;
for i = 1:N %������ߵ�SRVF����,q(t) = beta'(t)/sqrt(||beta'(t)||)
    L(i) = sqrt(norm(v(:,i)));
    if L(i) > 0.0001
        q(:,i) = v(:,i)/L(i);
    else
        q(:,i) = v(:,i)*0.0001; %%%%%% ������
    end
end

% keyboard;