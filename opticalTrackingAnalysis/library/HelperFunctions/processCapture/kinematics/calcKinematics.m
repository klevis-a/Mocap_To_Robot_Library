function calcStruct=calcKinematics(time,frameSeq,varargin)
    if nargin>2
        opts=varargin{1};
    else
        opts.zeroRot=0;
    end
    
    if(isa(frameSeq,'struct'))
        calcStruct=frameSeq;
    else
        calcStruct.pose.frames=frameSeq;
    end
    
    %number of frames
    numFrames=size(calcStruct.pose.frames,3);
    
    %now compute the position and rotation vectors
    poseVector=frameToVectorDiff(calcStruct.pose.frames);
    calcStruct.pose.position.vector=poseVector(:,1:3);
    
    if(opts.zeroRot)
        [~,zeroRotFrames]=cumFrameDiff(calcStruct.pose.frames);
        zeroRotFrames=prependIdentity(zeroRotFrames);
        poseVectorZero=frameToVectorDiff(zeroRotFrames);
        calcStruct.pose.rotation.vector=poseVectorZero(:,4:6);
    else
        calcStruct.pose.rotation.vector=poseVector(:,4:6);
    end

    %compute quaternions as well
    calcStruct.pose.quaternion=rotm2quat(calcStruct.pose.frames(1:3,1:3,:));
    
    %now compute the scalar position and rotation
    calcStruct.pose.position.scalar=vector3ToScalar(calcStruct.pose.position.vector);
    calcStruct.pose.rotation.scalar=vector3ToScalar(calcStruct.pose.rotation.vector);
    
    %now decompose into euler angles    
    calcStruct.pose.euler.zyz.vector=rotm2eul(calcStruct.pose.frames(1:3,1:3,:),'ZYZ');
    calcStruct.pose.euler.yxz.vector=yxzIntrinsicDecompose(calcStruct.pose.frames);
    
    %compute linear velocity vector and scalar
    calcStruct.velocity.linear.vector=velocity(time,calcStruct.pose.position.vector);
    calcStruct.velocity.linear.scalar=vector3ToScalar(calcStruct.velocity.linear.vector);
    calcStruct.velocity.axial=dot(calcStruct.velocity.linear.vector,squeeze(calcStruct.pose.frames(1:3,3,:))',2);
    
    %compute angular velocity vector and scalar
    calcStruct.velocity.angular.vector=computeAngVelocity(time,calcStruct.pose.frames(1:3,1:3,:));
    calcStruct.velocity.angular.scalar=vector3ToScalar(calcStruct.velocity.angular.vector);
    
    %compute euler angle rates
    calcStruct.velocity.euler.zyz.vector=zeros(numFrames,3);
    calcStruct.velocity.euler.yxz.vector=zeros(numFrames,3);
    
    %compute linear acceleration vector and scalar
    calcStruct.acceleration.linear.vector = acceleration(time,calcStruct.pose.position.vector);
    calcStruct.acceleration.linear.scalar = vector3ToScalar(calcStruct.acceleration.linear.vector);
    
    %compute angular acceleration vector and scalar
    calcStruct.acceleration.angular.vector = velocity(time,calcStruct.velocity.angular.vector);
    calcStruct.acceleration.angular.scalar = vector3ToScalar(calcStruct.acceleration.angular.vector);
    
    %compute euler angle accelerations
    calcStruct.acceleration.euler.zyz.vector=zeros(numFrames,3);
    calcStruct.acceleration.euler.yxz.vector=zeros(numFrames,3);
    
    for n=1:numFrames
        omega=computeZyzOmega(calcStruct.pose.euler.zyz.vector(n,:));
        calcStruct.velocity.euler.zyz.vector(n,:)=omega\calcStruct.velocity.angular.vector(n,:)';
        calcStruct.acceleration.euler.zyz.vector(n,:)=omega\calcStruct.acceleration.angular.vector(n,:)';
        
        omega=computeYxzOmega(calcStruct.pose.euler.yxz.vector(n,:));
        calcStruct.velocity.euler.yxz.vector(n,:)=omega\calcStruct.velocity.angular.vector(n,:)';
        calcStruct.acceleration.euler.yxz.vector(n,:)=omega\calcStruct.acceleration.angular.vector(n,:)';
    end
end



