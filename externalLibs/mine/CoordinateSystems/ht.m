function tm=ht(R,t)
    %computes a homogeneous transformation matrix given the rotation matrix
    %and translation vector
    tm = zeros(4,4);
    tm(4,4) = 1;
    tm(1:3,1:3)=R;
    tm(1:3,4)=t;
end