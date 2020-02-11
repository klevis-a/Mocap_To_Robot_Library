function [ndiMocapFit,jointsMocapFit,peakInfo]=determineJJTiming(captureInfo,posMinPeakHeight,varargin)
    cs='lab';
    rigidBody='bone';
    if nargin>2
        cs=varargin{1};
        rigidBody=varargin{2};
    end
    %ndi orientation and position peaks
    [peakInfo.ndi.position.peaks,peakInfo.ndi.position.locs,...
        peakInfo.ndi.position.widths,peakInfo.ndi.position.prominences]=...
        findpeaks(captureInfo.ndi.(cs).(rigidBody).mmdeg.pose.position.scalar, captureInfo.ndi.time, 'MinPeakHeight',posMinPeakHeight,'MinPeakProminence',15);
    
    [peakInfo.ndi.orient.peaks,peakInfo.ndi.orient.locs,...
        peakInfo.ndi.orient.widths,peakInfo.ndi.orient.prominences]=...
        findpeaks(captureInfo.ndi.(cs).(rigidBody).mmdeg.pose.rotation.scalar,captureInfo.ndi.time, 'MinPeakHeight', 70, 'MinPeakProminence', 5);
    
    %mocap orientation and position peaks
    [peakInfo.mocap.position.peaks,peakInfo.mocap.position.locs,...
        peakInfo.mocap.position.widths,peakInfo.mocap.position.prominences]=...
        findpeaks(captureInfo.mocap.(cs).(rigidBody).mmdeg.pose.position.scalar, captureInfo.mocap.time, 'MinPeakHeight',posMinPeakHeight,'MinPeakProminence',15);
    [peakInfo.mocap.orient.peaks,peakInfo.mocap.orient.locs,...
        peakInfo.mocap.orient.widths,peakInfo.mocap.orient.prominences]=...
        findpeaks(captureInfo.mocap.(cs).(rigidBody).mmdeg.pose.rotation.scalar,captureInfo.mocap.time,'MinPeakHeight', 70, 'MinPeakProminence', 5);
    
    %put them together and find a linear fit
    ndiTimes=[peakInfo.ndi.position.locs' peakInfo.ndi.orient.locs'];
    mocapTimes=[peakInfo.mocap.position.locs peakInfo.mocap.orient.locs];
    [ndiMocapFit.slope,ndiMocapFit.offset,ndiMocapFit.Rsq]=linearFit(mocapTimes,ndiTimes);
    
    if(isfield(captureInfo,'joints'))
        %joints orientation and position peaks
        [peakInfo.joints.position.peaks,peakInfo.joints.position.locs,...
            peakInfo.joints.position.widths,peakInfo.joints.position.prominences]=...
            findpeaks(captureInfo.joints.(cs).(rigidBody).mmdeg.pose.position.scalar,captureInfo.joints.time, 'MinPeakHeight',posMinPeakHeight,'MinPeakProminence',15);
        [peakInfo.joints.orient.peaks,peakInfo.joints.orient.locs,...
            peakInfo.joints.orient.widths,peakInfo.joints.orient.prominences]=...
            findpeaks(captureInfo.joints.(cs).(rigidBody).mmdeg.pose.rotation.scalar,captureInfo.joints.time,'MinPeakHeight', 70, 'MinPeakProminence', 5);
        
        %put them together and find a linear fit
        jointsTimes=[peakInfo.joints.position.locs' peakInfo.joints.orient.locs'];
        [jointsMocapFit.slope,jointsMocapFit.offset,jointsMocapFit.Rsq]=linearFit(mocapTimes,jointsTimes);
    end
end