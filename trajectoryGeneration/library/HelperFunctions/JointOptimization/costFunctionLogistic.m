function c=costFunctionLogistic(velPer)
    persistent k x0 L;
    k=10.0;
    x0=1.2;
    L=20.0;
    c=zeros(1,length(velPer));
    for i=1:length(velPer)
        c(i)=L/(1+exp(-k*(velPer(i)-x0)));
    end
end
