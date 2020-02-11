function [posErrors,orientErrors]=computeErrors(posDiffS,orientDiffS)
    %grab the first and last 10, and the middle portion of position
    %differences
    n=10;
    posFirstn=posDiffS(1:n);
    posLastn=posDiffS(end-(n-1):end);
    posMiddle=posDiffS(n+1:end-n);
    
    %grab the first and last 10, and the middle portion of orientation
    %differences
    orientFirstn=orientDiffS(1:n);
    orientLastn=orientDiffS(end-(n-1):end);
    orientMiddle=orientDiffS(n+1:end-n);
    
    %find the maximum value and its index for each portion of position
    [posFirstnMax,posFirstnMaxI]=max(posFirstn);
    [posLastnMax,posLastnMaxI]=max(posLastn);
    [posMiddleMax,posMiddleMaxI]=max(posMiddle);
    
    %find the maximum value and its index for each portion of orientation
    [orientFirstnMax,orientFirstnMaxI]=max(orientFirstn);
    [orientLastnMax,orientLastnMaxI]=max(orientLastn);
    [orientMiddleMax,orientMiddleMaxI]=max(orientMiddle);
    
    %put the results in the appropriate cells for position errors
    posErrors(1,1)=posFirstnMaxI;
    posErrors(2,1)=posFirstnMax;
    posErrors(1,3)=length(posDiffS)-n+posLastnMaxI;
    posErrors(2,3)=posLastnMax;
    posErrors(1,2)=posMiddleMaxI+n;
    posErrors(2,2)=posMiddleMax;
    
    %put the results in the appropriate cells for orientation errors
    orientErrors(1,1)=orientFirstnMaxI;
    orientErrors(2,1)=orientFirstnMax;
    orientErrors(1,3)=length(orientDiffS)-n+orientLastnMaxI;
    orientErrors(2,3)=orientLastnMax;
    orientErrors(1,2)=orientMiddleMaxI+n;
    orientErrors(2,2)=orientMiddleMax;
end
