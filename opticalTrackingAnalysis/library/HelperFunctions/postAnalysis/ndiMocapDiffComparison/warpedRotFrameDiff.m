function orientDiffVec=warpedRotFrameDiff(mocapData,ndiData,warpPath)
    orientDiffVec=zeros(size(warpPath,1),3);
    for n=1:size(warpPath,1)
        fDiff=squeeze(mocapData(1:3,1:3,warpPath(n,1)))*squeeze(ndiData(1:3,1:3,warpPath(n,2)))';
        axangDiff=rotm2axang(fDiff);
        orientDiffVec(n,:)=axangDiff(1:3)*rad2deg(axangDiff(4));
    end
end
