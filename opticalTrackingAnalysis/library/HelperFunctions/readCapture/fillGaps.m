function [pos,orient]=fillGaps(frameNum,data,numRigidBodies)

    assert(numRigidBodies==2);
    for n=1:numRigidBodies
        %find indices of the missing data
        missingData{n}=find(any(squeeze(data(:,:,n))<-3E28,2));
        %the available data is simply then simply the remaining data
        availDataTemp=frameNum;
        availDataTemp(missingData{n})=[];
        availData{n}=availDataTemp;
        %since data is usually missing in chunks it will be helpful to have
        %endpoints for missing data
        availDataEndpoints{n}=findSequencesWithinVector(availData{n});
        missingDataEndpoints{n}=findSequencesWithinVector(missingData{n});
    end

    %endpoints for hemisphere missing data
    hsMissDataEP = missingDataEndpoints{2};
    %endpoints for hemisphere available data
    hsAvailDataEP = availDataEndpoints{2};

    %available data for smart marker
    smAvailData = availData{1};
    %available data for hemisphere
    hsAvailData = availData{2};
    %missing data for smart marker
    smMissingData = missingData{1};
    %missing data for hemisphere
    hsMissingData = missingData{2};

    %check first to see whether we even have to fill in any missing gaps
    if(hsAvailDataEP(1,1)==frameNum(1) && hsAvailDataEP(2,1)==frameNum(end))
        disp('No data missing');
        pos=squeeze(data(:,1:3,2));
        orient=quat2rotm(squeeze(data(:,4:7,2)));
        return
    end

    %now check that gaps between the smart marker and hemisphere do not overlap
    if(any(ismember(hsMissingData,smMissingData)==1))
        disp('Overlapping missing data');
        return
    end

    %number of gaps we need to fill
    numGaps = size(hsMissDataEP, 2);
    %frame numbers at the beginning of the gap that can be used to determine a
    %transformation between smart marker and hemisphere
    gapMatrixStart = zeros(10,numGaps);
    %frame numbers at the end of the gap that can be used to determine a
    %transformation between smart marker and hemisphere
    gapMatrixEnd = zeros(10,numGaps);

    %maximum number of frames to average at beginning and end
    framesToAverage = 10;
    %the maximum number of frames from the beginning or end of the gap that we
    %will search to determine available frames for a transformation
    maxGap=20;

    %go through each gap
    for i=1:numGaps
        %a failed gap is one where we don't have any transformation frames at
        %the beginning or end
        failedGap=0;

        %for this gap determine the start and end (these are inclusive)
        hsStart = hsMissDataEP(1,i);
        hsEnd = hsMissDataEP(2,i);

        %last frame back to check for available transformation frames
        sEndPoint=hsStart-maxGap;
        if sEndPoint<1
            sEndPoint=1;
        end

        %walk through each point
        numPoints=0;
        for j=hsStart-1:-1:sEndPoint
            %if you have accumulated enough frames to perform the transformation
            %simply stop
            if(numPoints >= framesToAverage)
                break;
            end
            %check that the current frame is present in both the smart marker
            %and hemisphere - otherwise we can't determine a transformation
            if ismember(j,smAvailData) && ismember(j,hsAvailData)
                numPoints=numPoints+1;
                gapMatrixStart(numPoints,i)=j;
            end
        end

        %if no frames were found this satisfies the first criterion for calling
        %this a failed gap
        if(numPoints==0)
            failedGap=failedGap+1;
        end

        %last frame forward to check for transformation frames
        eEndPoint=hsEnd+maxGap;
        if eEndPoint > frameNum(end)
            eEndPoint = frameNum(end);
        end

        %walk through each point
        numPoints=0;
        for j=hsEnd+1:1:eEndPoint
            %if you have accumulated enough frames to perform the transformation
            %simply stop
            if(numPoints >= framesToAverage)
                break;
            end
            %check that the current frame is present in both the smart marker
            %and hemisphere - otherwise we can't determine a transformation
            if ismember(j,smAvailData) && ismember(j,hsAvailData)
                numPoints=numPoints+1;
                gapMatrixEnd(numPoints,i)=j;
            end
        end

        %if no frames were found this satisfies the second criterion for calling
        %this a failed gap
        if(numPoints==0)
            failedGap=failedGap+1;
        end

        if(failedGap==2)
            disp('Cannot fill in missing data');
            return
        end
    end

    %now we can fill in the missing data
    pos = zeros(frameNum(end),3);
    orient = zeros(3,3,frameNum(end));
    pos(hsAvailData,:) = squeeze(data(hsAvailData,1:3,2));
    orient(:,:,hsAvailData) = quat2rotm(squeeze(data(hsAvailData,4:7,2)));

    %note the algorithm below can be simplified significantly but my expertise
    %with quaternions is currently limited. I would think that
    %right-conjugation by a quaternion is the same as right-multiplying by a
    %matrix but I didn't take time to verify

    for n=1:numGaps
        %these are the frame numbers that will be used to compute a
        %transformation matrix between the smart marker and hemisphere
        transformFrames = [gapMatrixStart(:,n);gapMatrixEnd(:,n)];
        transformFrames(transformFrames==0)=[];
        numTransFrames = length(transformFrames);

        %these are the frames that need to be filled in this gap
        framesToFill = hsMissDataEP(1,n):hsMissDataEP(2,n);

        %positions and orientations of hemisphere and smart marker to be used
        %in creating the transformation matrix
        hspos = squeeze(data(transformFrames,1:3,2));
        hsorient = squeeze(data(transformFrames,4:7,2));
        smpos = squeeze(data(transformFrames,1:3,1));
        smorient = squeeze(data(transformFrames,4:7,1));

        %create a transformation matrix from smart marker to hemisphere for 
        %each of the above frames. Note that this is what I would call an
        %intrinsic transformation, i.e. the base frame is the smart marker
        %frame
        transforms = zeros(4,4,numTransFrames);
        for i=1:numTransFrames
            hsF=ht(quat2rotm(hsorient(i,:)),hspos(i,:));
            smF=ht(quat2rotm(smorient(i,:)),smpos(i,:));
            transforms(:,:,i)=htInverse(smF)*hsF;
        end

        %convert just the rotation part of the transformation matrices to
        %quaternions
        transformsQ = rotm2quat(transforms(1:3,1:3,:));
        %use a quaternion averaging algoirthm
        transformsQAvg = wavg_quaternion_markley(transformsQ, ones(1,numTransFrames))';
        %compute the average transformation matrix using this average and the
        %average of the positions
        transformAvg = ht(quat2rotm(transformsQAvg),mean(squeeze(transforms(1:3,4,:)),2));

        %now fill in the frames using this average transformation frame
        for frameToFill=framesToFill
            %create the smart marker frame
            smFrame = ht(quat2rotm(squeeze(data(frameToFill,4:7,1))), squeeze(data(frameToFill,1:3,1)));
            %the filled frame is just the smart marker after the transformation
            %has been applied to it
            filledFrame = smFrame*transformAvg;
            %now convert back to quaternions
            pos(frameToFill,:)=filledFrame(1:3,4);
            orient(:,:,frameToFill)=filledFrame(1:3,1:3);
        end
    end
end
