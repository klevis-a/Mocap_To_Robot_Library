function [proximal,orientation]=truncateTrajectory(proximal,orientation,truncateIndices)
    proximal=proximal(truncateIndices(1):truncateIndices(2),:);
    orientation=orientation(:,:,truncateIndices(1):truncateIndices(2));
end