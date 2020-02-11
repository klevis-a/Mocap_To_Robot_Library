function [ndiMocapFit,jointsMocapFit,alignData]=determineJLTiming(captureInfo,varargin)
    markerSize=12;
    
    %if reference coordinate system and rigid body are not specified, use
    %default ones
    cs='lab';
    linRigidBody='hs';
    rotRigidBody='bone';
    if nargin>1
        cs=varargin{1};
        linRigidBody=varargin{2};
        rotRigidBody=varargin{3};
    end
    
    %this is calculated to simply remove data points from the end of the
    %ndi capture so the graphs look more even
    ndiVelEnd=find(captureInfo.ndi.(cs).(linRigidBody).mmdeg.velocity.linear.scalar>1,1,'last')+10; %mm/sec
    if(ndiVelEnd>length(captureInfo.ndi.(cs).(linRigidBody).mmdeg.velocity.linear.scalar))
        ndiVelEnd=length(captureInfo.ndi.(cs).(linRigidBody).mmdeg.velocity.linear.scalar);
    end
    
    %time warp ndi against mocap
    [~,alignData.ndiMocapPath]=dtwK2(captureInfo.mocap.(cs).(linRigidBody).mmdeg.pose.position.vector',...
        captureInfo.ndi.(cs).(linRigidBody).mmdeg.pose.position.vector(1:ndiVelEnd,:)',@euclideanDistance,...
        captureInfo.mocap.(cs).(rotRigidBody).pose.quaternion', captureInfo.ndi.(cs).(rotRigidBody).pose.quaternion(1:ndiVelEnd,:)', @quatDistance);
    
    %time warp joints against mocap
    [~,alignData.jointsMocapPath]=dtwK2(captureInfo.mocap.(cs).(linRigidBody).mmdeg.pose.position.vector',...
        captureInfo.joints.(cs).(linRigidBody).mmdeg.pose.position.vector',@euclideanDistance,...
        captureInfo.mocap.(cs).(rotRigidBody).pose.quaternion', captureInfo.joints.(cs).(rotRigidBody).pose.quaternion', @quatDistance);
    
    %find position peaks for mocap, ndi, and joints for both linear and
    %angular scalar position
    [~,mocapPosPeak]=findpeaks(captureInfo.mocap.(cs).(linRigidBody).mmdeg.pose.position.scalar, captureInfo.mocap.time, 'MinPeakHeight', 200, 'MinPeakWidth', 0.5);
    [~,mocapAPosPeak]=findpeaks(captureInfo.mocap.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar, captureInfo.mocap.time, 'MinPeakHeight', 50, 'MinPeakWidth', 0.5);
    [~,ndiPosPeak]=findpeaks(captureInfo.ndi.(cs).(linRigidBody).mmdeg.pose.position.scalar, captureInfo.ndi.time, 'MinPeakHeight', 200, 'MinPeakWidth', 0.5);
    [~,ndiAPosPeak]=findpeaks(captureInfo.ndi.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar, captureInfo.ndi.time, 'MinPeakHeight', 50, 'MinPeakWidth', 0.5);
    [~,jointsPosPeak]=findpeaks(captureInfo.joints.(cs).(linRigidBody).mmdeg.pose.position.scalar, captureInfo.joints.time, 'MinPeakHeight', 200, 'MinPeakWidth', 0.5);
    [~,jointsAPosPeak]=findpeaks(captureInfo.joints.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar, captureInfo.joints.time, 'MinPeakHeight', 50, 'MinPeakWidth', 0.5);
    
    %the base workspace holds these variables, clear them so we start fresh
    evalin( 'base', 'clear ndiMocapPosPathI');
    evalin( 'base', 'clear ndiMocapOrientPathI');
    evalin( 'base', 'clear jointsMocapPosPathI');
    evalin( 'base', 'clear jointsMocapOrientPathI');
    
    close all
    
    %figure one has 3 subplots, 1)mocap linear position 2)ndi linear
    %position 3)joints linear position
    figPos=figure(1);
    
    %plot mocap linear position
    posAx(1)=subplot(1,3,1);
    mocapPosLine=plot(captureInfo.mocap.time,captureInfo.mocap.(cs).(linRigidBody).mmdeg.pose.position.scalar, '-*', 'MarkerIndices', find(captureInfo.mocap.time==mocapPosPeak));
    %posPlot1XLim=xlim;
    title('Mocap Hemisphere Position')
    
    %plot ndi linear position
    posAx(2)=subplot(1,3,2);
    ndiHsPosLine=plot(captureInfo.ndi.time(1:ndiVelEnd),captureInfo.ndi.(cs).(linRigidBody).mmdeg.pose.position.scalar(1:ndiVelEnd),'-*', 'MarkerIndices', []);
    hold on
    %plot peak of ndi linear position
    plot(ndiPosPeak,captureInfo.ndi.(cs).(linRigidBody).mmdeg.pose.position.scalar(captureInfo.ndi.time==ndiPosPeak),'r.', 'MarkerSize', markerSize);
    %posPlot2XLim=xlim;
    title('NDI Hemisphere Position');
    
    %plot joints linear position
    posAx(3)=subplot(1,3,3);
    jointsHsPosLine=plot(captureInfo.joints.time,captureInfo.joints.(cs).(linRigidBody).mmdeg.pose.position.scalar,'-*', 'MarkerIndices', []);
    hold on
    %plot peak of joints linear position
    plot(jointsPosPeak,captureInfo.joints.(cs).(linRigidBody).mmdeg.pose.position.scalar(captureInfo.joints.time==jointsPosPeak),'r.', 'MarkerSize', markerSize);
    %posPlot3XLim=xlim;
    title('Joints Hemisphere Position');
    
    %linkaxes(posAx,'y');
    %maxPosXLim=max([posPlot1XLim(2),posPlot2XLim(2),posPlot3XLim(2)]);
    %xlim(posAx(1),[0 maxPosXLim]);
    %xlim(posAx(2),[0 maxPosXLim]);
    %xlim(posAx(3),[0 maxPosXLim]);
    
    %establish the call back for the selecting points via the brush for
    %linear position
    posCallBackData.ndiHsPosLine=ndiHsPosLine;
    posCallBackData.jointsHsPosLine=jointsHsPosLine;
    posCallBackData.mocapPosLine=mocapPosLine;
    posCallBackData.ndiMocapPath=alignData.ndiMocapPath;
    posCallBackData.jointsMocapPath=alignData.jointsMocapPath;
    figPosBrush = brush(figPos);
    figPosBrush.ActionPostCallBack = {@onPositionBrushAction, posCallBackData};
    
    %figure 2 contains 2 subplots 1) time warped ndi vs mocap linear
    %position 2) time warped joints vs mocap linear position. This is used
    %to visually assure that the time warps look fine
    figure(2)
    
    %plot time-warped ndi vs mocap
    subplot(1,2,1)
    plot(captureInfo.mocap.(cs).(linRigidBody).mmdeg.pose.position.scalar(alignData.ndiMocapPath(:,1)));
    hold on
    plot(captureInfo.ndi.(cs).(linRigidBody).mmdeg.pose.position.scalar(alignData.ndiMocapPath(:,2)));
    title('Time Warped Mocap vs NDI Hemisphere Position');
    
    %plot time-warped joints vs mocap
    subplot(1,2,2)
    plot(captureInfo.mocap.(cs).(linRigidBody).mmdeg.pose.position.scalar(alignData.jointsMocapPath(:,1)));
    hold on
    plot(captureInfo.joints.(cs).(linRigidBody).mmdeg.pose.position.scalar(alignData.jointsMocapPath(:,2)));
    title('Time Warped Joints vs NDI Hemisphere Position');
    
    
    %figure one has 3 subplots, 1)mocap angular position 2)ndi angular
    %position 3)joints angular position
    figOrient=figure(3);
    
    %plot mocap angular position
    subplot(1,3,1)
    mocapOrientLine=plot(captureInfo.mocap.time,captureInfo.mocap.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar, '-*', 'MarkerIndices', find(captureInfo.mocap.time==mocapAPosPeak));
    title('Mocap Bone Orientation')
    
    %plot ndi angular position
    subplot(1,3,2)
    ndiOrientLine=plot(captureInfo.ndi.time(1:ndiVelEnd),captureInfo.ndi.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar(1:ndiVelEnd),'-*', 'MarkerIndices', []);
    hold on
    %plot peak ndi angular position
    plot(ndiAPosPeak,captureInfo.ndi.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar(captureInfo.ndi.time==ndiAPosPeak),'r.', 'MarkerSize', markerSize);
    title('NDI Bone Orientation');
    
    %plot joints angular position
    subplot(1,3,3)
    jointsOrientLine=plot(captureInfo.joints.time,captureInfo.joints.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar,'-*', 'MarkerIndices', []);
    hold on
    %plot peak joints angular position
    plot(jointsAPosPeak,captureInfo.joints.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar(captureInfo.joints.time==jointsAPosPeak),'r.', 'MarkerSize', markerSize);
    title('Joints Bone Position');
    
    %figure 4 contains 2 subplots 1) time warped ndi vs mocap angular
    %position 2) time warped joints vs mocap angular position. This is used
    %to visually assure that the time warps look fine
    figure(4)
    subplot(1,2,1)
    plot(captureInfo.mocap.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar(alignData.ndiMocapPath(:,1)));
    hold on
    plot(captureInfo.ndi.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar(alignData.ndiMocapPath(:,2)));
    title('Time Warped Mocap vs NDI Hemisphere Orientation');
    subplot(1,2,2)
    plot(captureInfo.mocap.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar(alignData.jointsMocapPath(:,1)));
    hold on
    plot(captureInfo.joints.(cs).(rotRigidBody).mmdeg.pose.rotation.scalar(alignData.jointsMocapPath(:,2)));
    title('Time Warped Joints vs NDI Hemisphere Orientation');
    
    %establish the call back for the selecting points via the brush for
    %angular position
    orientCallBackData.ndiOrientLine=ndiOrientLine;
    orientCallBackData.jointsOrientLine=jointsOrientLine;
    orientCallBackData.mocapOrientLine=mocapOrientLine;
    orientCallBackData.ndiMocapPath=alignData.ndiMocapPath;
    orientCallBackData.jointsMocapPath=alignData.jointsMocapPath;
    figOrientBrush = brush(figOrient);
    figOrientBrush.ActionPostCallBack = {@onOrientationBrushAction, orientCallBackData};
    
    %pause, once the points have been selected the user hints enter to
    %continue
    pause;
    
    %grab the selected alignments from the base workspace
    alignData.ndiMocapPathI=[evalin('base','ndiMocapPosPathI') evalin('base','ndiMocapOrientPathI')];
    alignData.jointsMocapPathI=[evalin('base','jointsMocapPosPathI') evalin('base','jointsMocapOrientPathI')];
    
    %convert indices to times
    ndiMocapTimes=captureInfo.mocap.time(alignData.ndiMocapPath(alignData.ndiMocapPathI,1));
    jointsMocapTimes=captureInfo.mocap.time(alignData.jointsMocapPath(alignData.jointsMocapPathI,1));
    ndiTimes=captureInfo.ndi.time(alignData.ndiMocapPath(alignData.ndiMocapPathI,2));
    jointsTimes=captureInfo.joints.time(alignData.jointsMocapPath(alignData.jointsMocapPathI,2));
    
    %do a linear fit for ndi vs mocap and joints vs mocap
    [ndiMocapFit.slope,ndiMocapFit.offset,ndiMocapFit.Rsq]=linearFit(ndiMocapTimes,ndiTimes');
    [jointsMocapFit.slope,jointsMocapFit.offset,jointsMocapFit.Rsq]=linearFit(jointsMocapTimes,jointsTimes');
end
