function initOpticalAnalysisPackage()
    [path,~,~]=fileparts(mfilename('fullpath'));
    addpath(strcat(path,'/inputOutput'));
    addpath(strcat(path,'/library'));
    addpath(strcat(path,'/library/dtw'));
    addpath(strcat(path,'/library/HelperFunctions'));
    addpath(strcat(path,'/library/HelperFunctions/common'));
    addpath(strcat(path,'/library/HelperFunctions/ndiToRobot'));
    addpath(strcat(path,'/library/HelperFunctions/processCapture'));
    addpath(strcat(path,'/library/HelperFunctions/processCapture/kinematics'));
    addpath(strcat(path,'/library/HelperFunctions/postAnalysis'));
    addpath(strcat(path,'/library/HelperFunctions/postAnalysis/mocapNdiTiming'));
end