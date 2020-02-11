function captureInfo=addThoraxCS(captureInfo,c3dFile,mocapSamplingPeriod)
    [~,~,~,~,thoraxOrientation]=...
        readV3DExport(c3dFile,mocapSamplingPeriod);
    initThoraxFrame=ht(thoraxOrientation(:,:,1),[0 0 0]);
    TLtoT=htInverse(initThoraxFrame);
    captureInfo=addCS(captureInfo,TLtoT,'lab','thorax');
    captureInfo.referenceCS{end+1}='thorax';
end