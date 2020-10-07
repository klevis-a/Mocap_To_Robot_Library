function [forces,moments]=calcKineticsMethod2(humerusLength,residualPercentage,angVel,angAcc,linAcc)
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
    A_R_F_calc = axang2rotm([0 0 1 pi/2])*axang2rotm([0 1 0 -pi/2]);
    %A_R_F_rep = [[0.403449	-0.080334	0.911475]' [-0.863347	0.29654	0.408278]' [-0.303085	-0.951634	0.050263]'];
    A_R_F = A_R_F_calc;

    %calculated
    pylonLength=(1-residualPercentage)*humerusLength;
    pylonMass=pylonLength*pylonLinearDensity+attachmentMass*2;

    %individual moments of inertia
    handMoI = cylinderMoI(handMass,wristWidth/2,handLength);
    handMoI_A = A_R_F*handMoI*A_R_F';
    forearmMoI = cylinderMoI(forearmMass,elbowWidth/2,forearmLength);
    forearmMoI_A = A_R_F*forearmMoI*A_R_F';
    pylonMoI = cylinderMoI(pylonMass,pylonWidth/2,pylonLength);

    %calculate system CoM
    handProxToHandCoM = A_R_F*-[0 0 1]'*handLength/2;
    forearmProxToForearmCoM = A_R_F*-[0 0 1]'*forearmLength/2;
    handProxToForearmCoM = -forearmProxToForearmCoM;
    
    originToHandCoM = -[0 0 1]'*pylonLength-A_R_F(:,3)*(forearmLength+handLength/2);
    originToForearmCoM = -[0 0 1]'*pylonLength-A_R_F(:,3)*(forearmLength/2);
    originToPylonCoM = -[0 0 1]'*(pylonLength/2);
    
    numFrames=size(angVel,1);
    forces=zeros(numFrames,3);
    moments=zeros(numFrames,3);
    g=[0 0 -9.8]';
    humerusOrigToOrig=-[0 0 1]'*residualPercentage*humerusLength;
    for n=1:numFrames
        handLinAcc=distantLinAcc(linAcc(n,:)',angVel(n,:)',angAcc(n,:)',humerusOrigToOrig+originToHandCoM);
        handForce=handLinAcc*handMass-g*handMass;
        handMoment=handMoI_A*angAcc(n,:)'+cross(angVel(n,:)',handMoI_A*angVel(n,:)')+cross(handProxToHandCoM,handForce);
        
        forearmLinAcc=distantLinAcc(linAcc(n,:)',angVel(n,:)',angAcc(n,:)',humerusOrigToOrig+originToForearmCoM);
        forearmForce=forearmLinAcc*forearmMass-g*forearmMass+handForce;
        forearmMoment=forearmMoI_A*angAcc(n,:)'+cross(angVel(n,:)',forearmMoI_A*angVel(n,:)')+...
            handMoment+cross(forearmProxToForearmCoM,forearmForce)-cross(handProxToForearmCoM,handForce);
        
        pylonLinAcc=distantLinAcc(linAcc(n,:)',angVel(n,:)',angAcc(n,:)',humerusOrigToOrig+originToPylonCoM);
        forces(n,:)=pylonLinAcc*pylonMass-g*pylonMass+forearmForce;
        moments(n,:)=pylonMoI*angAcc(n,:)'+cross(angVel(n,:)',pylonMoI*angVel(n,:)')+...
            forearmMoment+cross(originToPylonCoM,forces(n,:)')-cross(-originToPylonCoM,forearmForce);
    end
end

