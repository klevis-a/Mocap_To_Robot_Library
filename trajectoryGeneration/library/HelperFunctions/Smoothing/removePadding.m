function [diffV,diffVSmooth,fDiff,fDiffSmooth,framesSmooth]=removePadding(diffV,diffVSmooth,fDiff,fDiffSmooth,framesSmooth,padRemoval)
    framesSmooth=framesSmooth(:,:,padRemoval+1:end-padRemoval);
    fDiff=fDiff(:,:,padRemoval+1:end-padRemoval);
    fDiffSmooth=fDiffSmooth(:,:,padRemoval+1:end-padRemoval);
    diffV=diffV(padRemoval+1:end-padRemoval,:);
    diffVSmooth=diffVSmooth(padRemoval+1:end-padRemoval,:);
end
