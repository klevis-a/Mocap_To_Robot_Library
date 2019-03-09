function initTrajGenPackage()
    [path,~,~]=fileparts(mfilename('fullpath'));
    addpath(fullfile(path,'library'));
    addpath(fullfile(path,'library','CoordinateSystems'));
    addpath(fullfile(path,'library','Kinematics'));
    addpath(fullfile(path,'library','HelperFunctions'));
    addpath(fullfile(path,'library','HelperFunctions','ProgramGeneration'));
    addpath(fullfile(path,'library','HelperFunctions','Smoothing'));
    addpath(fullfile(path,'library','HelperFunctions','Subsample'));
    addpath(fullfile(path,'library','HelperFunctions','TrajectoryAugment'));
end