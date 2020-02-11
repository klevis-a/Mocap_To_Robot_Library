function [proximal,orientation,humerusLength,startEndIndices,thoraxOrientation,events]=readV3DExport(file,period)
    %reads a file that has been exported from V3D
    content=dlmread(file,'\t',5,1);
    %humerus proximal position
    proximal=content(:,1:3);
    %humerus orientation
    rotm=content(:,4:12);
    orientation=reshape(rotm,[],3,3);
    orientation=permute(orientation,[2,3,1]);
    humerusLength=content(content(:,22)~=0,22);
    %thorax orientation
    thoraxrotm=content(:,13:21);
    thoraxOrientation=reshape(thoraxrotm,[],3,3);
    thoraxOrientation=permute(thoraxOrientation,[2,3,1]);
    %process start and end indices
    [~,name,ext]=fileparts(file);
    [startEndIndices,events]=findStartEnd(strcat(name,ext),content,period);
end

function [startEndIndices,events] = findStartEnd(fileName,content,period)
    [~,activityString,~] = fileNameParser(fileName);
    activity=Activities.parse(activityString);
    switch activity
        case Activities.JJ_free
            [startEndIndices,events] = findStartEndJJFree(content,period);
        case Activities.JO_free
            [startEndIndices,events] = findStartEndJOFree(content,period);
        case Activities.JL
            [startEndIndices,events] = findStartEndJL(content,period);
        case Activities.IR90
            [startEndIndices,events] = findStartEndIR90(content,period);
        otherwise
            error('Activity does not exist');
    end
end

function [startEndIndices,events] = findStartEndJJFree(content,period)
    jjStartEnd = content(1:find(content(:,23),1,'last'),23);
    events = floor(jjStartEnd./period+1);
    startEndIndices(1) = events(1);
    startEndIndices(2) = events(end);
end

function [startEndIndices,events] = findStartEndJL(content,period)
    startEndIndices(1) = floor(content(1,23)/period+1);
    startEndIndices(2) = floor(content(1,24)/period+1);
    events=startEndIndices;
end

function [startEndIndices,events] = findStartEndIR90(content,period)
    startEndIndices(1) = floor(content(1,23)/period+1);
    startEndIndices(2) = floor(content(1,24)/period+1);
    events=startEndIndices;
end

function [startEndIndices,events] = findStartEndJOFree(content,period)
    if size(content,2)>=23
        joStartEnd = content(1:find(content(:,23),1,'last'),23);
        startEndIndices(1) = floor(joStartEnd(1)/period+1);
        startEndIndices(2) = floor(joStartEnd(end)/period+1);
        events=startEndIndices;
        proximal=content(:,1:3);
        disp(norm(proximal(startEndIndices(2),:)-proximal(startEndIndices(1),:)));
    else
        startEndIndices = [];
        events=startEndIndices;
    end
end

% function startEndIndices = findStartEndJOFree(content,period)
%     jom = floor(content(1,14)./period+1);
%     disp(jom);
%     %now calculate 0.9 m to each side of the maximum axial force
%     %first normalize the data with respect to the maximum axial force frame
%     proximal=content(:,1:3);
%     norm2d=proximal(:,1:2)-proximal(jom,1:2);
%     normdist2d=sqrt(dot(norm2d,norm2d,2));
%     %now break the vector into two parts: before and after the maximum
%     %axial force
%     numDataPoints=size(content,1);
%     normdist2d1=normdist2d(1:jom);
%     normdist2d2=normdist2d(jom:numDataPoints);
%     desiredDist=0.9;
%     [minDist1,indexOfMin1]=min(abs(normdist2d1-desiredDist));
%     [minDist2,indexOfMin2]=min(abs(normdist2d2-desiredDist));
%     disp([indexOfMin1 indexOfMin2+jom-1]);
%     disp([minDist1 minDist2]);
%     startEndIndices=[indexOfMin1, indexOfMin2+jom-1];
% end