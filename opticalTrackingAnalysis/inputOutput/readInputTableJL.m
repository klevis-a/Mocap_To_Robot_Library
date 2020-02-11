function [ndiMocapPathI,jointsMocapPathI]=readInputTableJL(inputTable)
    ndiMocapPathCell=inputTable{1,'ndiMocapPathI'};
    ndiMocapPathI=str2num(ndiMocapPathCell{1});
    jointsMocapPathICell=inputTable{1,'jointsMocapPathI'};
    jointsMocapPathI=str2num(jointsMocapPathICell{1});
end