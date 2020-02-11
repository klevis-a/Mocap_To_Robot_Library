function [proximal,distal,orient] = readSSErrorsFile(file)
    content=csvread(file);
    proximal=content(:,1)*1000;
    distal=content(:,2)*1000;
    orient=content(:,3);
end