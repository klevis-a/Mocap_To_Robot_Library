function initMocapToRobotLib()
    [path,~,~]=fileparts(mfilename('fullpath'));
    addpath(fullfile(path,'trajectoryGeneration'));
    addpath(fullfile(path,'opticalTrackingAnalysis'));
    addpath(fullfile(path,'enumerations'));
    addpath(fullfile(path,'externalLibs'));
    initTrajGenPackage();
    initOpticalAnalysisPackage();
    initExternalLibs();
end