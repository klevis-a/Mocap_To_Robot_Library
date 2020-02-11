function captureInfo=calcAllKinematics(captureInfo,sources,css,rbs,kinOpts)
    %calculate kinematic information from frames for each source,reference
    %frame, and rigid body
    
    %go through each source (mocap,ndi,joints)
    for i=1:length(sources)
        currentSource=sources{i};
        for j=1:length(css)
            %go through each coordinate system (lab,thorax,eigen,etc.)
            currentCS=css{j};
            for k=1:length(rbs)
                %go through each rigid body (hs,bone)
                currentRB=rbs{k};
                %iof the combination exists
                if(isfield(captureInfo.(currentSource),currentCS) && isfield(captureInfo.(currentSource).(currentCS),currentRB))
                    %calculate kinematics from frames
                    captureInfo.(currentSource).(currentCS).(currentRB)=...
                        calcKinematics(captureInfo.(currentSource).time,...
                        captureInfo.(currentSource).(currentCS).(currentRB),kinOpts);
                    %convert to mm and deg
                    captureInfo.(currentSource).(currentCS).(currentRB).mmdeg=convertTommdeg(captureInfo.(currentSource).(currentCS).(currentRB));
                end
            end
        end
    end
end