function [angAcceleration]=computeAngAcceleration(time,frames)
    numFrames=size(frames,3);
    angAcceleration=zeros(numFrames,3);
    angAccTensor=zeros(3,3,numFrames);
    for i=1:3
        for j=1:3
            angAccTensor(i,j,:)=acceleration(time,squeeze(frames(i,j,:)));
        end
    end
    for n=1:numFrames
        angAccTensor(:,:,n)=squeeze(angAccTensor(:,:,n))*squeeze(frames(1:3,1:3,n))';
        angAccTensor(:,:,n)=(0.5)*(squeeze(angAccTensor(:,:,n))-squeeze(angAccTensor(:,:,n))');
        angAcceleration(n,1)=angAccTensor(3,2,n);
        angAcceleration(n,2)=angAccTensor(1,3,n);
        angAcceleration(n,3)=angAccTensor(2,1,n);
    end
end
