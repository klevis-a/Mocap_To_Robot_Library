function startEndIndices=modifyStartEndIndices(startEndIndices,fileName,gaussInterval)
    [~,activityString,~] = fileNameParser(fileName);
    activity=Activities.parse(activityString);
    switch activity
        case Activities.JJ_free
        case Activities.JO_free
        case Activities.IR90
        case Activities.JL
            %this should be the same as the gauss interval
            startEndIndices(1)=startEndIndices(1)-gaussInterval;
            startEndIndices(2)=startEndIndices(2)+gaussInterval;
        otherwise
            error('Activity does not exist');
    end
end