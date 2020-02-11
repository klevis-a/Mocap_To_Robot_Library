function plotSmoothTraj(rawVDiff,smoothVDiff,rawFDiff,smoothFDiff,posDiffS,orientDiffS,posErrors,orientErrors,period)
    %create time vector
    indices=1:size(rawVDiff,1);
    time=(indices-1)*period;

    %compute velocities and accelerations
    rawVel(:,1:3)=velocity(time,rawVDiff(:,1:3));
    rawVel(:,4:6)=computeAngVelocity(time,rawFDiff(1:3,1:3,:));
    smoothVel(:,1:3)=velocity(time,smoothVDiff(:,1:3));
    smoothVel(:,4:6)=computeAngVelocity(time,smoothFDiff(1:3,1:3,:));
    rawAcc(:,1:3)=acceleration(time,rawVDiff(:,1:3));
    rawAcc(:,4:6)=velocity(time,rawVel(:,4:6));
    smoothAcc(:,1:3)=acceleration(time,smoothVDiff(:,1:3));
    smoothAcc(:,4:6)=velocity(time,smoothVel(:,4:6));
    
    close all

    %plot cumulative difference from starting position
    figure('NumberTitle', 'off', 'Name', 'Cumulative Difference')
    for n=1:6
        subplot(2,3,n);
        plot(rawVDiff(:,n));
        hold on
        plot(smoothVDiff(:,n));
        titles(n);
        axesLabels(n);
    end

    %plot the difference of the cumulative difference between raw and
    %smooth
    figure('NumberTitle', 'off', 'Name', 'Cumulative Difference Raw Minus Smooth')
    for n=1:6
        subplot(2,3,n);
        plot(rawVDiff(:,n)-smoothVDiff(:,n));
        titles(n);
        axesLabels(n);
    end

    figure('NumberTitle', 'off', 'Name', 'Scalar Difference Raw Minus Smooth')
    subplot(2,1,1);
    %plot scalar difference in position
    %point out differences at endpoints and max difference
    plot(posDiffS);
    text(posErrors(1,1),posErrors(2,1), strcat(num2str(posErrors(2,1)),'\rightarrow'),...
        'HorizontalAlignment','right','Color','red', 'FontWeight','bold', 'FontSize',14);
    text(posErrors(1,2),posErrors(2,2), strcat('\leftarrow',num2str(posErrors(2,2)))...
        ,'Color','red', 'FontWeight','bold', 'FontSize',14);
    text(posErrors(1,3),posErrors(2,3), strcat('\leftarrow',num2str(posErrors(2,3)))...
        ,'Color','red', 'FontWeight','bold', 'FontSize',14);
    subplot(2,1,2);
    %plot scalar difference in orientation
    %point out differences at endpoints and max difference
    plot(orientDiffS);
    text(orientErrors(1,1),orientErrors(2,1), strcat(num2str(orientErrors(2,1)),'\rightarrow'),...
        'HorizontalAlignment','right','Color','red', 'FontWeight','bold', 'FontSize',14);
    text(orientErrors(1,2),orientErrors(2,2), strcat('\leftarrow',num2str(orientErrors(2,2)))...
        ,'Color','red', 'FontWeight','bold', 'FontSize',14);
    text(orientErrors(1,3),orientErrors(2,3), strcat('\leftarrow',num2str(orientErrors(2,3)))...
        ,'Color','red', 'FontWeight','bold', 'FontSize',14);
    axesLabels(n);

    %plot velocity
    figure('NumberTitle', 'off', 'Name', 'Velocity')
    for n=1:6
        subplot(2,3,n);
        plot(rawVel(:,n));
        hold on
        plot(smoothVel(:,n),'LineWidth',2);
        titles(n);
        axesLabelsVel(n);
        minVel=min(smoothVel(:,n));
        maxVel=max(smoothVel(:,n));
        range=maxVel-minVel;
        additional=0.1*range;
        ylim([minVel-additional,maxVel+additional]);
    end

    %plot acceleration
    figure('NumberTitle', 'off', 'Name', 'Acceleration')
    for n=1:6
        subplot(2,3,n);
        plot(rawAcc(:,n));
        hold on
        plot(smoothAcc(:,n),'LineWidth',2);
        titles(n);
        axesLabelsAcc(n);
        minAcc=min(smoothAcc(:,n));
        maxAcc=max(smoothAcc(:,n));
        range=maxAcc-minAcc;
        additional=0.1*range;
        ylim([minAcc-additional,maxAcc+additional]);
    end
end

function titles(i)
    switch i
        case 1
            title('X');
        case 2
            title('Y');
        case 3
            title('Z');
        case 4
            title('X Rotation');
        case 5
            title('Y Rotation');
        case 6
            title('Z Rotation');
    end
end

function axesLabels(i)
    xlabel('Index');
    if i<4
        ylabel('mm');
    else
        ylabel('deg');
    end
end

function axesLabelsVel(i)
    xlabel('Index');
    if i<4
        ylabel('mm/sec');
    else
        ylabel('deg/sec');
    end
end

function axesLabelsAcc(i)
    xlabel('Index');
    if i<4
        ylabel('mm/sec^2');
    else
        ylabel('deg/sec^2');
    end
end