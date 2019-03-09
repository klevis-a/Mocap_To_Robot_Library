function acc = acceleration(time, data)
    numColumns=size(data,2);
    acc = zeros(length(time),numColumns);
    for i=1:numColumns
        acc(:,i)=4*del2(data(:,i), time);
    end
end