function opto_to_robot=optoToRobot(transformFile)
    tm=csvread(transformFile);
    opto_to_robot=ht(tm,[0 0 0]);
end