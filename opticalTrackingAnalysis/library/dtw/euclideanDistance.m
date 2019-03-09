function distance=euclideanDistance(x,y)
    diff=x-y;
    distance=sqrt(dot(diff,diff));
end
