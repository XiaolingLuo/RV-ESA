function p = q_to_curve(q)
%beta'(t) = q(t)||q(t)||
[n,T] = size(q);

for i = 1:T
    qnorm(i) = norm(q(:,i));
end

for i = 1:n
    p(i,:) = [ cumtrapz(q(i,:).*qnorm )/T ] ;
end
