function onOrientationBrushAction(~,~,orientCallBackData)
    %this is called upon selecting a point on the angular position graph
    mocapOrientI=find(orientCallBackData.mocapOrientLine.BrushData);
    %number of data points selected
    orientLength=length(mocapOrientI);
    ndiMocapOrientPathI=zeros(1,orientLength);
    jointsMocapOrientPathI=zeros(1,orientLength);
    
    %for each data point selected
    for n=1:orientLength
        %if it's the first data point selected
        if n==1
            %find the LAST index in the time warp that matches the selected
            %mocap position index (for both the ndi and joints time warp)
            ndiMocapOrientPathI(n)=find(orientCallBackData.ndiMocapPath(:,1)==mocapOrientI(n),1,'last');
            jointsMocapOrientPathI(n)=find(orientCallBackData.jointsMocapPath(:,1)==mocapOrientI(n),1,'last');
        %if the last data point is selected
        elseif n==orientLength
            %find the FIRST index in the time warp that matches the selected
            %mocap position index (for both the ndi and joints time warp)
            ndiMocapOrientPathI(n)=find(orientCallBackData.ndiMocapPath(:,1)==mocapOrientI(n),1,'first');
            jointsMocapOrientPathI(n)=find(orientCallBackData.jointsMocapPath(:,1)==mocapOrientI(n),1,'first');
        %if in the middle
        else
            %find all of the indices in the time warp that matches the selected
            %mocap position index (for both the ndi and joints time warp),
            %then average them
            ndiMocapOrientPathI(n)=round(mean(find(orientCallBackData.ndiMocapPath(:,1)==mocapOrientI(n))),0);
            jointsMocapOrientPathI(n)=round(mean(find(orientCallBackData.jointsMocapPath(:,1)==mocapOrientI(n))),0);
        end
    end
    
    %we should now have the corresponding indices for the ndi and joints
    %data. So update the MarkerIndices properties for the ndi and joints
    %line in order to visually show the correlation between mocap and ndi
    %and mocap and joints data
    orientCallBackData.ndiOrientLine.MarkerIndices=orientCallBackData.ndiMocapPath(ndiMocapOrientPathI,2);
    orientCallBackData.jointsOrientLine.MarkerIndices=orientCallBackData.jointsMocapPath(jointsMocapOrientPathI,2);
    
    %finally update the base workspace variable so it is then subsequently
    %available to the calling function
    assignin('base','ndiMocapOrientPathI',ndiMocapOrientPathI);
    assignin('base','jointsMocapOrientPathI',jointsMocapOrientPathI);
end
