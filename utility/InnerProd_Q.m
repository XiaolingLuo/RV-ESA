function val = InnerProd_Q(q1,q2)
%����q1��q2���ڻ�����ʽΪx1(t)*x2(t) + y1(t)*y2(t)��0��1�ϵĻ���
[n,T] = size(q1);
val = trapz(linspace(0,1,T),sum(q1.*q2));

return;