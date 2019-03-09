function [velPolysPre,velPolysPost]=prePostVelocityPolys(tb,ta,velVector,accVector)
    velPolysPre=zeros(3,4);
    velPolysPost=zeros(3,4);
    %go through each dimension
    for n=1:3
        velPolysPre(n,:)=generateVelocityPoly(tb(n),velVector(1,n),accVector(1,n));
        velPolysPost(n,:)=generateVelocityPoly(ta(n),velVector(end,n),accVector(end,n));
    end
end
