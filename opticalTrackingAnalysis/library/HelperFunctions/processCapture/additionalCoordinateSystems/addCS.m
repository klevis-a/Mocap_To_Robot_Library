function captureInfo=addCS(captureInfo,T,fromCS,toCS)
    %go through each capture source (mocap,ndi,joints)
    for i=1:length(captureInfo.sources)
        currentSource=captureInfo.sources{i};
        %go through each rigid body, (hs,bone)
        for j=1:length(captureInfo.rigidBodies)
            currentRB=captureInfo.rigidBodies{j};
            %if the capture source and rigid body exist
            if(isfield(captureInfo.(currentSource),fromCS) && isfield(captureInfo.(currentSource).(fromCS),currentRB))
                %perform the coordinate system transformation
                captureInfo.(currentSource).(toCS).(currentRB).pose.frames=...
                    changeCS(captureInfo.(currentSource).(fromCS).(currentRB).pose.frames,T);
            end
        end
    end
end