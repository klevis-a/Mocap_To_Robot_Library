function indices=SubSampleUniform(numFrames,frequency)
    %number of frames with endpoints removed
    numFramesNoEP=numFrames-2;
    %if we have perfect spacing then the following equation would give an
    %integer solution for n f*n+(f-1)=numFramesNoEP;
    %if it doesn't have a solution the modulus gives us the number of
    %points that we will have to account for
    modF=mod(numFramesNoEP-(frequency-1),frequency);
    isEven=(mod(modF,2)==0);
    
    %now create the indices
    if isEven
        lAdjustment=modF/2;
        rAdjustment=lAdjustment;
    else
        lAdjustment=(modF-1)/2+1;
        rAdjustment=(modF-1)/2;
    end
    
    secondToLastFrame=numFrames-frequency-rAdjustment;
    indices(1)=1;
    currentF=indices(1)+lAdjustment+frequency;
    indices(2)=currentF;
    counter=3;
    while currentF<secondToLastFrame-frequency
        indices(counter)=currentF+frequency;
        currentF=indices(counter);
        counter=counter+1;
    end
    indices(counter)=secondToLastFrame;
    indices(counter+1)=numFrames;
end
