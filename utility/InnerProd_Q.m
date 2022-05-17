function val = InnerProd_Q(q1,q2)
%计算q1和q2的内积，公式为x1(t)*x2(t) + y1(t)*y2(t)在0到1上的积分
[n,T] = size(q1);
val = trapz(linspace(0,1,T),sum(q1.*q2));

return;