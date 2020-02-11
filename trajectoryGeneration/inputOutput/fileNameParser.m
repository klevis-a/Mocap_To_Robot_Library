function [subjectId,activity,trialNumber] = fileNameParser(file)
    persistent activities;
    activities ={'JJ_free','JJ_Free','IR90','JO_free','JL'};
    for n=1:length(activities)
        currentAct=activities{n};
        match=strfind(file,currentAct);
        if ~isempty(match)
            match1=match(1);
            activity=currentAct;
            activityLength=length(activity);
            subjectId=char(extractBetween(file,match1-4,match1-2));
            if(file(match1+activityLength)=='_')
                trialNumber=char(extractBetween(file,match1+activityLength+1,match1+activityLength+2));
            else
                trialNumber=char(extractBetween(file,match1+activityLength,match1+activityLength+1));
            end
            break;
        end
    end
end

