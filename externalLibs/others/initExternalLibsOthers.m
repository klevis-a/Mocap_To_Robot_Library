function initExternalLibsOthers()
    [path,~,~]=fileparts(mfilename('fullpath'));
    addpath(fullfile(path,'affine_fit'));
    addpath(fullfile(path,'quadfit'));
    addpath(fullfile(path,'tolgabirdal_averaging_quaternions'));
    addpath(fullfile(path,'quaternion'));
    addpath(fullfile(path,'ExportFig'));
end