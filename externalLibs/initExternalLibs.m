function initExternalLibs()
    [path,~,~]=fileparts(mfilename('fullpath'));
    addpath(fullfile(path,'mine'));
    addpath(fullfile(path,'others'));
    initExternalLibsMine();
    initExternalLibsOthers();
end