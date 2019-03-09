function angVel=evalAngVel(angVelPoly,t,tcond)
    angVel=zeros(1,3);
    for n=1:3
        if t>=tcond(n,1) && t<=tcond(n,2)
            angVel(n)=polyval(angVelPoly(n,:),t);
        else
            angVel(n)=0;
        end
    end
end
