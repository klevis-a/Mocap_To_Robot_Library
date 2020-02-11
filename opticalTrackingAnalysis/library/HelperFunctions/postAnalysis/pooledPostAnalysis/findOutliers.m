function outlierTable=findOutliers(pNames,rawData)
    %First find the outliers. Since we have an array this will give us the
    %rows and columns with outliers
    [row,col]=find(isoutlier(rawData));
    %matchUp is a sort of lookup table. The first index holds the row
    %number, the second index holds which index this row number corresponds
    %to in the outlierTable
    matchUp=[];
    outlierCounter=1;
    outlierTable={};
    for n=1:length(row)
        %if matchUp is empty we definitely have not seen this row before
        if(isempty(matchUp))
            haveSeen=0;
            seenLocation=0;
        else
            %determine if we have seen this row before and if so what is
            %its index in the matchUp table
            [haveSeen,seenLocation]=ismember(row(n),matchUp(:,1));
        end
        if(haveSeen)
            %the 2nd column in the matchUp table gives us the corresponding
            %index of this row in the outlierTable
            outlierIndex=matchUp(seenLocation,2);
            %now simply the 3rd column of the outlier table so we add
            %another column to this row
            outlierTable{outlierIndex,3}=[outlierTable{outlierIndex,3} col(n)];
        else
            %here we have a brand new row being added to the outlier table
            matchUp=[matchUp; [row(n) outlierCounter]];
            outlierTable{outlierCounter,1}=pNames{row(n)};
            outlierTable{outlierCounter,2}=row(n);
            outlierTable{outlierCounter,3}=col(n);
            outlierCounter=outlierCounter+1;
        end
    end
end
