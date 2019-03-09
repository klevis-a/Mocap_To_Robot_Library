function [proximalE,distalE,orientationE]=computeSubSamplingError(proximal,distal,orientation,indices)
    numFrames=size(proximal,1);
    %compute error at each point
    proximalE=zeros(numFrames,1);
    distalE=zeros(numFrames,1);
    orientationE=zeros(numFrames,1);
    for n=1:length(indices)-1
        s_i=indices(n);
        e_i=indices(n+1);
        %the error at the starting and ending index is zero
        proximalE(s_i,:)=0;
        proximalE(e_i,:)=0;
        distalE(s_i,:)=0;
        distalE(e_i,:)=0;
        orientationE(s_i,:)=0;
        orientationE(e_i,:)=0;
        if(e_i ~= s_i+1)
            %we want to compute the error for the orientation, proximal
            %end, and distal end
            proximalE(s_i+1:e_i-1)=DetermineError(s_i,e_i,proximal);
            distalE(s_i+1:e_i-1)=DetermineError(s_i,e_i,distal);
            orientationE(s_i+1:e_i-1,1)=acosd(1-2*DetermineErrorOrientation(s_i,e_i,orientation));
        end
    end
end