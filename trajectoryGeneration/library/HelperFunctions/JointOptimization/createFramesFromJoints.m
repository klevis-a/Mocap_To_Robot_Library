function frames=createFramesFromJoints(robot,base,ee,joints)
    numFrames=size(joints,1);
    frames=zeros(4,4,numFrames);
    for i=1:numFrames
        frames(:,:,i)=getTransform(robot,createConfig(robot,joints(i,:)),ee,base);
    end
end