function [axis,axisC,hemisphereAxes,tcp,residualsX,residualsY,residualsZ,radiusDiff,maxResTcp,rmsResTcp,joint1pos,joint2pos,joint4pos]=...
    computeNDIToRobot(j1File,j2File,j4File,pos6DFile,processTcp,tcpFunction)
    %read calibration files
    [~,data1,numRigidBodies1] = readNDI6D(j1File);
    [~,data2,numRigidBodies2] = readNDI6D(j2File);
    [~,data4,numRigidBodies4] = readNDI6D(j4File);

    assert(numRigidBodies1==numRigidBodies2);
    assert(numRigidBodies2==numRigidBodies4);

    if numRigidBodies1>1
        hs1=removeBlankNdiData(squeeze(data1(:,:,2)));
        hs2=removeBlankNdiData(squeeze(data2(:,:,2)));
        hs4=removeBlankNdiData(squeeze(data4(:,:,2)));
    else
        hs1=removeBlankNdiData(data1);
        hs2=removeBlankNdiData(data2);
        hs4=removeBlankNdiData(data4);
    end
    
    joint1pos=squeeze(hs1(:,1:3));
    joint2pos=squeeze(hs2(:,1:3));
    joint4pos=squeeze(hs4(:,1:3));
    joint1orient=quat2rotm(squeeze(hs1(:,4:7)));
    joint2orient=quat2rotm(squeeze(hs2(:,4:7)));
    joint4orient=quat2rotm(squeeze(hs4(:,4:7)));
    
    %movement about joint 4 establishes the x-axis
    %movement about joint 2 establishes the y-axis
    %movement about joint 1 establishes the z-axis
    [axis(:,1),residualsX] = calcPlaneVector(joint4pos);
    [axis(:,2),residualsY] = calcPlaneVector(joint2pos);
    [axis(:,3),residualsZ] = calcPlaneVector(joint1pos);

    %since this is a computed rotation matrix, it may not be orthonormal. Here
    %we use SVD to find the closest orthonormal matrix to this one
    axisC=orthoNormalProject(axis);

    %a vector from the start to the end of the movement for joint 2 should
    %point in the general direction of the negative Z-axis. So the dot product 
    %of the z-axis, column 3, and this vector should be negative.
    %If not, then the axis simply needs to be reversed
    negativeZ = joint2pos(end,:)-joint2pos(1,:);
    if(dot(negativeZ,axisC(:,3))>0)
        axisC(:,3)=axisC(:,3)*-1;
    end

    %a vector from the start to the end of the movement for joint 1 should
    %point in the general direction of the positive Y-axis. So the dot product 
    %of the y-axis, column 2, and this vector should be positive.
    %If not, then the axis simply needs to be reversed
    positiveY = joint1pos(end,:)-joint1pos(1,:);
    if(dot(positiveY,axisC(:,2))<0)
        axisC(:,2)=axisC(:,2)*-1;
    end

    %a vector from the start to the end of the movement for joint 2 should
    %point in the general direction of the positive X-axis. So the dot product 
    %of the x-axis, column 3, and this vector should be positive.
    %If not, then the axis simply needs to be reversed
    positiveX = joint2pos(end,:)-joint2pos(1,:);
    if(dot(positiveX,axisC(:,1))<0)
        axisC(:,1)=axisC(:,1)*-1;
    end

    %this is simply here just as a check that this process is giving us good
    %results. Since the hemisphere is locked into the robot (at least in the
    %starting position) in the same orientation we should come up with very
    %similar calculations for the orientation of the hemisphere from the robot
    %perspective in the starting position

    %this process is done more simply in quaternions so first average the
    %orientation of the hemisphere for the first 10 data points for each joint
    quatA=rotm2quat(joint1orient(:,:,1:10));
    quatB=rotm2quat(joint2orient(:,:,1:10));
    quatC=rotm2quat(joint4orient(:,:,1:10));
    quatO=[quatA;quatB;quatC];
    %average of the orientations
    [quatAvg]=wavg_quaternion_markley(quatO, ones(size(quatO,1),1));
    %now let's express this starting hemisphere orientation in terms of the
    %robot coordinate system
    startOrientRobot=axisC'*quat2rotm(quatAvg');
    r0 = eul2rotm(deg2rad(fliplr([180 0 0])));
    hemisphereAxes = r0'*startOrientRobot;
    
    if processTcp
        [tcp,radiusDiff,maxResTcp,rmsResTcp]=tcpFunction(pos6DFile,axisC',r0);
    end
end