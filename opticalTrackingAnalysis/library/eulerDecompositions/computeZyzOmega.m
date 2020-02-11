function zyzOmega=computeZyzOmega(eulAngles)
    zyzOmega=[0 -sin(eulAngles(1))  cos(eulAngles(1))*sin(eulAngles(2)); 
              0  cos(eulAngles(1))  sin(eulAngles(1))*sin(eulAngles(2)); 
              1        0                    cos(eulAngles(2))];
end
