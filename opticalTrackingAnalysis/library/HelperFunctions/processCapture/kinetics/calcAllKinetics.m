function kinetics=calcAllKinetics(captureInfo)
    kinetics=struct;
    kinetics.mocap=struct;
    kinetics.ndi=struct;
    
    angVelMocap=captureInfo.mocap.lab.bone.velocity.angular.vector;
    angAccMocap=captureInfo.mocap.lab.bone.acceleration.angular.vector;
    linAccMocap=captureInfo.mocap.lab.bone.acceleration.linear.vector;
    mocapFrames=captureInfo.mocap.lab.bone.pose.frames;
    
    angVelNdi=captureInfo.ndi.lab.bone.velocity.angular.vector;
    angAccNdi=captureInfo.ndi.lab.bone.acceleration.angular.vector;
    linAccNdi=captureInfo.ndi.lab.bone.acceleration.linear.vector;
    ndiFrames=captureInfo.ndi.lab.bone.pose.frames;
    
    switch captureInfo.activity
        case Activities.JJ_free
            [forcesMocap,momentsMocap,forcesMocap_lab,momentsMocap_lab]=calcKineticsMethod1(captureInfo.humerusLength,0.25,angVelMocap,angAccMocap,linAccMocap,mocapFrames,-pi/4);
            [forcesNdi,momentsNdi,forcesNdi_lab,momentsNdi_lab]=calcKineticsMethod1(captureInfo.humerusLength,0.25,angVelNdi,angAccNdi,linAccNdi,ndiFrames,-pi/4);
        case Activities.JL
            [forcesMocap,momentsMocap,forcesMocap_lab,momentsMocap_lab]=calcKineticsMethod1Jug(captureInfo.humerusLength,0.25,angVelMocap,angAccMocap,linAccMocap,mocapFrames,0);
            [forcesNdi,momentsNdi,forcesNdi_lab,momentsNdi_lab]=calcKineticsMethod1Jug(captureInfo.humerusLength,0.25,angVelNdi,angAccNdi,linAccNdi,ndiFrames,0);
        case Activities.JO_free
            [forcesMocap,momentsMocap,forcesMocap_lab,momentsMocap_lab]=calcKineticsMethod1(captureInfo.humerusLength,0.25,angVelMocap,angAccMocap,linAccMocap,mocapFrames,-pi/2);
            [forcesNdi,momentsNdi,forcesNdi_lab,momentsNdi_lab]=calcKineticsMethod1(captureInfo.humerusLength,0.25,angVelNdi,angAccNdi,linAccNdi,ndiFrames,-pi/2);
        case Activities.IR90
            [forcesMocap,momentsMocap,forcesMocap_lab,momentsMocap_lab]=calcKineticsMethod1(captureInfo.humerusLength,0.25,angVelMocap,angAccMocap,linAccMocap,mocapFrames,-pi/2);
            [forcesNdi,momentsNdi,forcesNdi_lab,momentsNdi_lab]=calcKineticsMethod1(captureInfo.humerusLength,0.25,angVelNdi,angAccNdi,linAccNdi,ndiFrames,-pi/2);
    end
    
    initThoraxFrame=captureInfo.thoraxOrientation(:,:,1);
    kinetics.mocap.forces.vector=forcesMocap;
    kinetics.mocap.moments.vector=momentsMocap;
    kinetics.mocap.thorax.forces.vector=zeros(size(kinetics.mocap.forces.vector));
    kinetics.mocap.thorax.moments.vector=zeros(size(kinetics.mocap.moments.vector));
    for i=1:size(forcesMocap_lab,1)
        kinetics.mocap.thorax.forces.vector(i,:)=initThoraxFrame'*forcesMocap_lab(i,:)';
        kinetics.mocap.thorax.moments.vector(i,:)=initThoraxFrame'*momentsMocap_lab(i,:)';
    end
    kinetics.mocap.forces.scalar=sqrt(dot(forcesMocap,forcesMocap,2));
    kinetics.mocap.moments.scalar=sqrt(dot(momentsMocap,momentsMocap,2));
    
    kinetics.ndi.forces.vector=forcesNdi;
    kinetics.ndi.moments.vector=momentsNdi;
    kinetics.ndi.thorax.forces.vector=zeros(size(kinetics.ndi.forces.vector));
    kinetics.ndi.thorax.moments.vector=zeros(size(kinetics.ndi.moments.vector));
    for i=1:size(forcesNdi_lab,1)
        kinetics.ndi.thorax.forces.vector(i,:)=initThoraxFrame'*forcesNdi_lab(i,:)';
        kinetics.ndi.thorax.moments.vector(i,:)=initThoraxFrame'*momentsNdi_lab(i,:)';
    end
    kinetics.ndi.forces.scalar=sqrt(dot(forcesNdi,forcesNdi,2));
    kinetics.ndi.moments.scalar=sqrt(dot(momentsNdi,momentsNdi,2));
    kinetics.mocap.axialForce=kinetics.mocap.forces.vector(:,3);
    kinetics.mocap.bendingMoment=sqrt(kinetics.mocap.moments.vector(:,1).^2+kinetics.mocap.moments.vector(:,2).^2);
    kinetics.mocap.axialMoment=kinetics.mocap.moments.vector(:,3);
    kinetics.ndi.axialForce=kinetics.ndi.forces.vector(:,3);
    kinetics.ndi.bendingMoment=sqrt(kinetics.ndi.moments.vector(:,1).^2+kinetics.ndi.moments.vector(:,2).^2);
    kinetics.ndi.axialMoment=kinetics.ndi.moments.vector(:,3);
    kinetics.mocap.thorax.bendingMoment=sqrt(kinetics.mocap.thorax.moments.vector(:,1).^2+kinetics.mocap.thorax.moments.vector(:,2).^2);
    kinetics.ndi.thorax.bendingMoment=sqrt(kinetics.ndi.thorax.moments.vector(:,1).^2+kinetics.ndi.thorax.moments.vector(:,2).^2);
end