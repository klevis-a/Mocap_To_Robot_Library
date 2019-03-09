function diffVSmooth = smoothData(dataVec,gauss_interval)
    diffVSmooth = zeros(size(dataVec,1),size(dataVec,2));
    for i=1:size(dataVec,2)
        diffVSmooth(:,i) = smoothdata(dataVec(:,i),'gaussian',gauss_interval);
    end
end
