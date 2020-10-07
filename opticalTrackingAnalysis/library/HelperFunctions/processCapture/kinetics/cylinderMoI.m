function moi=cylinderMoI(m,r,h)
    moi=zeros(3,3);
    moi(1,1)=(1/12)*m*(3*r*r+h*h);
    moi(2,2)=moi(1,1);
    moi(3,3)=(1/2)*m*r*r;
end