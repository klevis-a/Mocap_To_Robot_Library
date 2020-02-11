function captureInfo=calcAllBodyKinematics(captureInfo)
    %calculate angular velocity and acceleration with respect to body
    for i=1:length(captureInfo.sources)
        currentSource=captureInfo.sources{i};
        for k=1:length(captureInfo.rigidBodies)
            currentRB=captureInfo.rigidBodies{k};
            if(isfield(captureInfo.(currentSource),'lab') && isfield(captureInfo.(currentSource).lab,currentRB))
                %angular velocity
                captureInfo.(currentSource).body.(currentRB).velocity.angular.vector=...
                    calcBodyKinematics(captureInfo.(currentSource).lab.(currentRB).velocity.angular.vector,...
                    captureInfo.(currentSource).lab.(currentRB).pose.frames);
                captureInfo.(currentSource).body.(currentRB).velocity.angular.scalar=...
                    vector3ToScalar(captureInfo.(currentSource).body.(currentRB).velocity.angular.vector);

                %angular acceleration
                captureInfo.(currentSource).body.(currentRB).acceleration.angular.vector=...
                    calcBodyKinematics(captureInfo.(currentSource).lab.(currentRB).acceleration.angular.vector,...
                    captureInfo.(currentSource).lab.(currentRB).pose.frames);
                captureInfo.(currentSource).body.(currentRB).acceleration.angular.scalar=...
                    vector3ToScalar(captureInfo.(currentSource).body.(currentRB).acceleration.angular.vector);

                %to mm and deg
                captureInfo.(currentSource).body.(currentRB).mmdeg.velocity.angular.vector=...
                    rad2deg(captureInfo.(currentSource).body.(currentRB).velocity.angular.vector);
                captureInfo.(currentSource).body.(currentRB).mmdeg.acceleration.angular.vector=...
                    rad2deg(captureInfo.(currentSource).body.(currentRB).acceleration.angular.vector);
                captureInfo.(currentSource).body.(currentRB).mmdeg.velocity.angular.scalar=...
                    rad2deg(captureInfo.(currentSource).body.(currentRB).velocity.angular.scalar);
                captureInfo.(currentSource).body.(currentRB).mmdeg.acceleration.angular.scalar=...
                    rad2deg(captureInfo.(currentSource).body.(currentRB).acceleration.angular.scalar);
            end
        end
    end
end