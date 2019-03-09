function vel = velocity(time, data)
    numColumns=size(data,2);
    vel = zeros(length(time),numColumns);
    for i=1:numColumns
        vel(:,i)=gradient(data(:,i),time);
    end
end