function mat=vecProject(v)
%returns a matrix that can be used to project any vector onto the plane
%that is perpendicular to v
    mat=[1-v(1)^2 -v(1)*v(2) -v(1)*v(3);
        -v(2)*v(1) 1-v(2)^2 -v(2)*v(3);
        -v(3)*v(1) -v(3)*v(2) 1-v(3)^2];
end