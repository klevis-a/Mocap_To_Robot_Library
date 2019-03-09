function [axis,residuals]=calcPlaneVector(hemispherePos)
    %fit a plane to the collected data
    %n is the vector perpendicular to the plane, p is a point on the plane
    [n,~,p] = affine_fit(hemispherePos);
    %create a projection matrix that will project any vector on the plane
    %defined by n
    projectMat = vecProject(n);
    %recenter the vectors so they are centered around the point p on the
    %plane
    vecPCenter=hemispherePos-p;
    %project these vectors onto the plane
    planeProject = (projectMat*vecPCenter')';
    %the residual is then simply the difference between the initial vector
    %and the portion of the vector that's projected onto the plane
    residuals = sqrt(sum((vecPCenter-planeProject).^2,2));
    axis = n;
end