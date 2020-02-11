function smoothDataFunction=createButterworthFilter(butterOrder,cutoffFreq,samplingFreq)
    fc = cutoffFreq;
    fs = samplingFreq;
    [b,a] = butter(butterOrder,fc/(fs/2));
    smoothDataFunction = @(x) filtfilt(b,a,x);
end