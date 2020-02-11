function diffVSmooth = smoothData(dataVec,smoothDataFunction)
    diffVSmooth = zeros(size(dataVec,1),size(dataVec,2));
    for i=1:size(dataVec,2)
        diffVSmooth(:,i) = smoothDataFunction(dataVec(:,i));
    end
end
