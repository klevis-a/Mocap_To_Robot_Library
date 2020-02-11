function [cost,vel_per]=computeCostFromJoints(joints,velLimits,period)
    numFrames=size(joints,1);
    cost=0.0;
    vel_per=zeros(numFrames,6);
    for i=1:numFrames-1
        current=joints(i,:);
        next=joints(i+1,:);
        vel=abs((next-current)/period);
        velPer=vel./velLimits;
        vel_per(i,:)=velPer;
        cost=cost+sum(costFunction(velPer));
    end
end
