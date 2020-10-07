function linAccDistant=distantLinAcc(linAcc,angVel,angAcc,r)
    linAccDistant=linAcc+cross(angAcc,r)+cross(angVel,cross(angVel,r));
end
