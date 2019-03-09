function [angVelocity]=computeAngVelocity(time,frames)
    numFrames=size(frames,3);
    angVelocity=zeros(numFrames,3);
    angVelTensor=zeros(3,3,numFrames);
    for i=1:3
        for j=1:3
            angVelTensor(i,j,:)=velocity(time,squeeze(frames(i,j,:)));
        end
    end
    for n=1:numFrames
        angVelTensor(:,:,n)=squeeze(angVelTensor(:,:,n))*squeeze(frames(1:3,1:3,n))';
        angVelocity(n,1)=angVelTensor(3,2,n);
        angVelocity(n,2)=angVelTensor(1,3,n);
        angVelocity(n,3)=angVelTensor(2,1,n);
    end
end

% function [angVelocity]=computeAngVelocity(time,frames)
%     numFrames=size(frames,3);
%     angVelocity=zeros(numFrames,3);
%     for i=1:numFrames
%         if i==1
%             frameDiff=(squeeze(frames(1:3,1:3,i+1))*squeeze(frames(1:3,1:3,i))');
%             axangDiff=rotm2axang(frameDiff);
%             angVelocity(i,:)=axangDiff(1:3)*axangDiff(4)/(time(i+1)-time(i));
%         elseif i==numFrames
%             frameDiff=(squeeze(frames(1:3,1:3,i))*squeeze(frames(1:3,1:3,i-1))');
%             axangDiff=rotm2axang(frameDiff);
%             angVelocity(i,:)=axangDiff(1:3)*axangDiff(4)/(time(i)-time(i-1));
%         else
%             frameDiff=(squeeze(frames(1:3,1:3,i+1))*squeeze(frames(1:3,1:3,i-1))');
%             axangDiff=rotm2axang(frameDiff);
%             angVelocity(i,:)=axangDiff(1:3)*axangDiff(4)/(time(i+1)-time(i-1));
%         end
%     end
% end