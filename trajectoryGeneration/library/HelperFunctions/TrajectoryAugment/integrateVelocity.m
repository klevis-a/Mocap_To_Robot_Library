function posPoly=integrateVelocity(linVelPoly,initCond)
    posPoly=zeros(size(linVelPoly,1),size(linVelPoly,2)+1);
    %go through each dimension
    for n=1:3
        posPoly(n,:)=polyint(squeeze(linVelPoly(n,:)),initCond(n));
    end
end
