function [forces_body,moments_body,forces_lab,moments_lab]=calcKineticsMethod1(humerusLength,residualPercentage,angVel,angAcc,linAcc,frames,forearmRotation)
    %mass
    handMass=0.416;
    forearmMass=1.013;
    pylonLinearDensity=0.50823; %kg/m
    attachmentMass=0.15;

    %length
    handLength=.1524;
    forearmLength=.254;

    %width
    wristWidth=0.054;
    elbowWidth=0.0762;
    pylonWidth=0.060;

    %rotation matrices
    A_R_F_calc = axang2rotm([0 0 1 pi/2])*axang2rotm([0 1 0 forearmRotation]);
    %A_R_F_rep = [[0.403449	-0.080334	0.911475]' [-0.863347	0.29654	0.408278]' [-0.303085	-0.951634	0.050263]'];
    A_R_F = A_R_F_calc;

    %calculated
    pylonLength=(1-residualPercentage)*humerusLength;
    pylonMass=pylonLength*pylonLinearDensity+attachmentMass*2;

    %individual moments of inertia
    handMoI = cylinderMoI(handMass,wristWidth/2,handLength);
    forearmMoI = cylinderMoI(forearmMass,elbowWidth/2,forearmLength);
    pylonMoI = cylinderMoI(pylonMass,pylonWidth/2,pylonLength);

    %calculate system CoM
    %note - the origin here is considered the bone-implant interface
    originToHandCoM = -[0 0 1]'*pylonLength-A_R_F(:,3)*(forearmLength+handLength/2);
    originToForearmCoM = -[0 0 1]'*pylonLength-A_R_F(:,3)*(forearmLength/2);
    originToPylonCoM = -[0 0 1]'*(pylonLength/2);
    systemMass = handMass+forearmMass+pylonMass;
    systemCoM = (originToHandCoM*handMass+originToForearmCoM*forearmMass+originToPylonCoM*pylonMass)/systemMass;

    %displace all moments of inertia to system CoM and account for orientation
    %changes - it doesn't matter whether the orientation changes or the
    %displacement is done first as I have derived
    systemMoI = MoI_displace(A_R_F*handMoI*A_R_F',handMass,originToHandCoM-systemCoM) + ...
        MoI_displace(A_R_F*forearmMoI*A_R_F',forearmMass,originToForearmCoM-systemCoM) + ...
        MoI_displace(pylonMoI,pylonMass,originToPylonCoM-systemCoM);
    
    g=[0 0 -9.8]';
    humerusOrigToOrig=-[0 0 1]'*residualPercentage*humerusLength;
    numFrames=size(angVel,1);
    forces_lab=zeros(numFrames,3);
    moments_lab=zeros(numFrames,3);
    forces_body=zeros(numFrames,3);
    moments_body=zeros(numFrames,3);
    for n=1:numFrames
        forces_lab(n,:)=systemMass*distantLinAcc(linAcc(n,:)',angVel(n,:)',angAcc(n,:)',frames(1:3,1:3,n)*(humerusOrigToOrig+systemCoM))-g*systemMass;
        moments_lab(n,:)=frames(1:3,1:3,n)*systemMoI*frames(1:3,1:3,n)'*angAcc(n,:)'+cross(angVel(n,:)',frames(1:3,1:3,n)*systemMoI*frames(1:3,1:3,n)'*angVel(n,:)')+cross(frames(1:3,1:3,n)*systemCoM,forces_lab(n,:)');
        forces_body(n,:)=frames(1:3,1:3,n)'*forces_lab(n,:)';
        moments_body(n,:)=frames(1:3,1:3,n)'*moments_lab(n,:)';
    end
end