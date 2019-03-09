function [time,joints]=readCapturedJoints(file,tickDefinition)
    content=csvread(file,1,0);
    ticks=content(:,1);
    %first normalize the tick count with respect to the first tick count
    ticks=ticks-ticks(1);
    time=ticks*tickDefinition;
    %somtimes the same measurement is repeated - we want to remove these
    %repeats
    [~,timeIndexUnique,~]=unique(time);
    time=time(timeIndexUnique);
    joints=content(timeIndexUnique,2:7);
    %note that matlab and fanuc compute joint angles differently, that is
    %why this is needed.
    joints(:,3)=joints(:,3)+joints(:,2);
end