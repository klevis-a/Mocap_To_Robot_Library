function config = createConfig(robot,theta)
    %creates a robot configuration from a joint angle vector - there is
    %problem a better function to do this but I could not find it, and this
    %works
    config = robot.randomConfiguration;
    config(1).JointPosition=theta(1);
    config(2).JointPosition=theta(2);
    config(3).JointPosition=theta(3);
    config(4).JointPosition=theta(4);
    config(5).JointPosition=theta(5);
    config(6).JointPosition=theta(6);
end