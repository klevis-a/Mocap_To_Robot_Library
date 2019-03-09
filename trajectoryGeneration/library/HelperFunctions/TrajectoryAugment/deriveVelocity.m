function accPoly=deriveVelocity(linVelPoly)
    accPoly=zeros(size(linVelPoly,1),size(linVelPoly,2)-1);
    %go through each dimension
    for n=1:3
        accPoly(n,:)=polyder(squeeze(linVelPoly(n,:)));
    end
end
