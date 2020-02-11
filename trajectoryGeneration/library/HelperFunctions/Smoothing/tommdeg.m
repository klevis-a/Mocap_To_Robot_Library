function converted=tommdeg(data)
    converted(:,1:3)=data(:,1:3)*1000;
    converted(:,4:6)=rad2deg(data(:,4:6));
end
