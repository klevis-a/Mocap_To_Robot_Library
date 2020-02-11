function captureInfo=addEigenPosCS(captureInfo)
    %calculate the eigen coordinate system for the hemisphere position
    %V is the rotation matrix from lab to the eigen coordinate system, so
    %V is the transformation matrix from eigen to lab
    %hence V' is the transformation matrix from lab to eigen
    [~,~,V]=svd(squeeze(captureInfo.mocap.lab.hs.pose.frames(1:3,4,:))');
    TLtoE=ht(V',[0 0 0]);
    captureInfo=addCS(captureInfo,TLtoE,'lab','eigenPos');
    captureInfo.referenceCS{end+1}='eigenPos';
end