function plotJoints(joints,period,vel_limits)
    numFrames=size(joints,1);
    
    %establish the time vector
    time=(0:numFrames-1)*period;
    
    %find joint velocities and accelerations
    jointVel=velocity(time,joints);
    jointAcc=acceleration(time,joints);
    
    close all
    %plot joints
    figure('NumberTitle', 'off', 'Name', 'Joint Positions')
    for i=1:6
        subplot(2,3,i);
        plot(time,rad2deg(joints(:,i)));
        title(strcat('Joint',{' '}, num2str(i)));
        xlabel('Time (s)');
        ylabel('Joint Positions (deg)');
    end
    
    %plot joint velocity percentage
    figure('NumberTitle', 'off', 'Name', 'Joint Velocity Percentage')
    for i=1:6
        subplot(2,3,i);
        plot(time,jointVel(:,i)/vel_limits(i)*100);
        title(strcat('Joint',{' '}, num2str(i)));
        xlabel('Time (s)');
        ylabel('Joint Velocity Percentage');
    end
    
    %plot joint accelerations
    figure('NumberTitle', 'off', 'Name', 'Joint Acceleration')
    for i=1:6
        subplot(2,3,i);
        plot(time,rad2deg(jointAcc(:,i)));
        title(strcat('Joint',{' '}, num2str(i)));
        xlabel('Time (s)');
        ylabel('Joint Accleration deg/sec^2');
    end
end
