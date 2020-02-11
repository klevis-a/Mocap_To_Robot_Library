function initExternalLibsMine()
    [path,~,~]=fileparts(mfilename('fullpath'));
    addpath(fullfile(path,'CoordinateSystems'));
    addpath(fullfile(path,'FileSystem'));
end