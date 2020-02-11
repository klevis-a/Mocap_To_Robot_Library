function extDiff=extFrameDiff(frames)
    extDiff=zeros(3,3,length(frames)-1);
    for i=1:length(frames)-1
        extDiff(:,:,i)=frames(1:3,1:3,i+1)*frames(1:3,1:3,i)';
    end
end