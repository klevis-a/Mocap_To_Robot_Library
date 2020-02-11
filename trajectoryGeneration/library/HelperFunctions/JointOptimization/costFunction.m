function c=costFunction(velPer)
    persistent expEndVal m cutOff;
    cutOff=1.2;
    expEndVal=(exp(7*cutOff)-1)/400;
    m=(100-expEndVal)/(2-cutOff);
    c=zeros(1,length(velPer));
    for i=1:length(velPer)
        if(velPer(i)<=cutOff)
            c(i)=(exp(7*velPer(i))-1)/400;
        else
            c(i)=m*(velPer(i)-cutOff)+expEndVal;
        end
    end
end
