function error=DetermineErrorOrientation(s_i,e_i,rotationM)
    %starting and ending orientation 
    s_o=rotationM(:,:,s_i);
    e_o=rotationM(:,:,e_i);
    %rotation matrix that allows to rotate between these two orientations
    R = e_o*s_o';
    axangR=rotm2axang(R);
    
    error = zeros(1,e_i-s_i-1);
    for n=s_i+1:e_i-1
        c_o=rotationM(:,:,n);
        %rotation from start to current and its quaternion
        rSToC=c_o*s_o';
        rSToCQuat=rotm2quat(rSToC);
        rSToC_Proj=orientProject(rSToC,axangR(1:3));
        rSToCProjQuat=rotm2quat(rSToC_Proj);
        error(n-s_i)=1-dot(rSToCQuat,rSToCProjQuat)^2;
    end
end