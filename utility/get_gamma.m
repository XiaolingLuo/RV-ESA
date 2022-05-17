function gamI = get_gamma(X1,X2)
    q1 = curve_to_qnos(X1);
    q2 = curve_to_qnos(X2);
    gam1 = DynamicProgrammingQ(q2/sqrt(InnerProd_Q(q2,q2)),q1/sqrt(InnerProd_Q(q1,q1)),0,0);
    gam1 = (gam1-gam1(1))/(gam1(end)-gam1(1));
    
    [gam2] = DynamicProgrammingQ(q1/sqrt(InnerProd_Q(q1,q1)),q2/sqrt(InnerProd_Q(q2,q2)),0,0);
    gam2 = invertGamma(gam2);
    
    gamI = (gam1+gam2)/2;
end

