function yxzOmega=computeYxzOmega(eulAngles)
    yxzOmega=[0 cos(eulAngles(1))  sin(eulAngles(1))*cos(eulAngles(2)); 
              1         0               -sin(eulAngles(2)); 
              0 -sin(eulAngles(1)) cos(eulAngles(1))*cos(eulAngles(2))];
end
