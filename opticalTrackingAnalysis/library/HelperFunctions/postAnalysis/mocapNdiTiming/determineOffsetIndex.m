function offsetIndex = determineOffsetIndex(time,timeOffset)
    [~,offsetIndex] = min(abs(time-timeOffset));
end