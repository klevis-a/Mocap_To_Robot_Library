function [frames,tb]=readFramesFile(file)
    content=csvread(file);
    tb=content(:,1);
    content=reshape(content(:,2:end),[],4,4);
    frames=permute(content, [3 2 1]);
end