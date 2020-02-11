function onPositionBrushAction(~,~,posCallBackData)
    %this is called upon selecting a point on the linear position graph
    mocapPosI=find(posCallBackData.mocapPosLine.BrushData);
    %number of data points selected
    posLength=length(mocapPosI);
    ndiMocapPosPathI=zeros(1,posLength);
    jointsMocapPosPathI=zeros(1,posLength);
    
    %for each data point selected
    for n=1:posLength
        %if it's the first data point selected
        if n==1
            %find the LAST index in the time warp that matches the selected
            %mocap position index (for both the ndi and joints time warp)
            ndiMocapPosPathI(n)=find(posCallBackData.ndiMocapPath(:,1)==mocapPosI(n),1,'last');
            jointsMocapPosPathI(n)=find(posCallBackData.jointsMocapPath(:,1)==mocapPosI(n),1,'last');
        %if the last data point is selected
        elseif n==posLength
            %find the FIRST index in the time warp that matches the selected
            %mocap position index (for both the ndi and joints time warp)
            ndiMocapPosPathI(n)=find(posCallBackData.ndiMocapPath(:,1)==mocapPosI(n),1,'first');
            jointsMocapPosPathI(n)=find(posCallBackData.jointsMocapPath(:,1)==mocapPosI(n),1,'first');
        %if in the middle
        else
            %find all of the indices in the time warp that matches the selected
            %mocap position index (for both the ndi and joints time warp),
            %then average them
            ndiMocapPosPathI(n)=round(mean(find(posCallBackData.ndiMocapPath(:,1)==mocapPosI(n))),0);
            jointsMocapPosPathI(n)=round(mean(find(posCallBackData.jointsMocapPath(:,1)==mocapPosI(n))),0);
        end
    end
    
    %we should now have the corresponding indices for the ndi and joints
    %data. So update the MarkerIndices properties for the ndi and joints
    %line in order to visually show the correlation between mocap and ndi
    %and mocap and joints data
    posCallBackData.ndiHsPosLine.MarkerIndices=posCallBackData.ndiMocapPath(ndiMocapPosPathI,2);
    posCallBackData.jointsHsPosLine.MarkerIndices=posCallBackData.jointsMocapPath(jointsMocapPosPathI,2);
    
    %finally update the base workspace variable so it is then subsequently
    %available to the calling function
    assignin('base','ndiMocapPosPathI',ndiMocapPosPathI);
    assignin('base','jointsMocapPosPathI',jointsMocapPosPathI);
end
