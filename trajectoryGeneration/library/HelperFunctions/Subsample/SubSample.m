function indices=SubSample(proximal,distal,rotationM,subSamplePercentage)
    %global errorI
    numFrames=size(proximal,1);
    framesToRemove=(1-subSamplePercentage)*numFrames;
    numSignals=3;
    %indices of frames that remain (i.e. are not removed), 
    %note that we will remove elements from this vector,
    %however the elements that are leftover will always point to the correct
    %index. So let's say that you removed element number 2, then
    %frames_left_indices would contain 1:1, 2:3, 3:4, etc. where the number before
    %the colon is the index of the left over frames (i.e. the index of
    %frames_left_indices), whereas the number after the colon is the index of that
    %leftover frame in the original array (i.e. it's corresponding index in
    %frames)
    frames_left_indices=1:numFrames;
    
    %iterate through all the frames that need to be removed
    for i=1:framesToRemove
        %resulting error at each point for removing that frame
        error = NaN(numFrames,numSignals);
        %iterate from the 2nd to the 2nd to last frame - we don't remove
        %the endframes
        for l=2:length(frames_left_indices)-1
            %index of frame prior to current frame - remember that we keep
            %removing frames so this is not necessarily the prior frame in
            %the original sequence
            s_i=frames_left_indices(l-1);
            %index of frame after the current frame - remember that we keep
            %removing frames so this is not necessarily the prior frame in
            %the original sequence
            e_i=frames_left_indices(l+1);
            
            error(l,1)=max(DetermineError(s_i,e_i,proximal));
            error(l,2)=max(DetermineError(s_i,e_i,distal));
            error(l,3)=max(DetermineErrorOrientation(s_i,e_i,rotationM));
        end
        %for each datapoint determine the error for each signal. For each
        %datapoint determine the maximum of these errors. Now go through
        %each datapoint and pick the one with the smallest maximum error
        %amongst all signals to remove. We do this for this reason: imagine
        %having an error amongst signal on a datapoint as 1E-10 2.0 3.0.
        %1E-10 is a very small error so it will get picked amongst all
        %datapoints if we use the minimum error amongst signals and
        %datapoints strategy. But this means that the very large 2.0 and
        %3.0 errors will be included in this remove. Hence our strategy.
        errorR = NaN(numFrames,numSignals);
        for z=1:numSignals
            errorR(:,z) = tiedrank(error(:,z));
        end
        [errorF,~] = max(errorR,[],2);
        %errorF=dot(errorR,errorR,2);
        [~,I] = min(errorF);
        frames_left_indices(I(1))=[];
    end
    indices = frames_left_indices;
end