function A=orientProject(R,v)
    Rquat=rotm2quat(R);
    r=Rquat(2:4);
    p=dot(r,v)*v;
    A=quat2rotm([Rquat(1),p(1),p(2),p(3)]);
end