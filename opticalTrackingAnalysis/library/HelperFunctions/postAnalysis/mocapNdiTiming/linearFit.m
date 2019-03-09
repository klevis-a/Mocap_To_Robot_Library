function [slope,offset,Rsq]=linearFit(x,y)
    p=polyfit(x,y,1);
    sfFit=polyval(p,x);
    sfResid=y-sfFit;
    SSresid = sum(sfResid.^2);
    SStotal = (length(y)-1)*var(y);
    Rsq = 1-SSresid/SStotal;
    slope=p(1);
    offset=p(2);
end