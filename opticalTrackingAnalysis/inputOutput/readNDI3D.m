function [data]=readNDI3D(file)
    %read the file
    content=csvread(file,1,0);
    frameNumber=content(:,1);
    markerId=content(:,2);
    uniqueMarkers=unique(markerId,'sorted');
    data=permute(reshape(content(:,3:5)',[3,length(uniqueMarkers),frameNumber(end)]), [2 1 3]) ;
end