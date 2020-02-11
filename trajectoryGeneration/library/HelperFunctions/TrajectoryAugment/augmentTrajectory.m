function [newFramesT,figures]=augmentTrajectory(frames,period,amendNumPoints,interpNumPoints,gaussInterval,plotBool)
    %compute kinematics - measure orientation with respect to the first\
    %frame in order to avoid singularities with the rotation vector
    framesT=frames;
    for n=1:size(frames,3)
        framesT(1:3,1:3,n)=squeeze(framesT(1:3,1:3,n))*squeeze(frames(1:3,1:3,1))';
    end
    time=((1:size(framesT,3))-1)*period;
    kineStruct=calcKinematics(time,framesT);

    %easy access to position velocity and acceleration vectors, and
    %quaternions
    posVector=kineStruct.pose.position.vector;
    quatSeq=kineStruct.pose.quaternion;
    rotVector=kineStruct.pose.rotation.vector;
    velVector=kineStruct.velocity.linear.vector;
    accVector=kineStruct.acceleration.linear.vector;
    angVelVector=kineStruct.velocity.angular.vector;
    angAccVector=kineStruct.acceleration.angular.vector;

    %compute final time to interpolate before and after
    lintbf=-interpNumPoints(1:3)*period;
    angtbf=-interpNumPoints(4:6)*period;
    lintaf=interpNumPoints(1:3)*period;
    angtaf=interpNumPoints(4:6)*period;

    %and now create a time vector for the before and after polynomials
    %so we can solve for those timepoints
    tb=-amendNumPoints*period:period:0;
    ta=0:period:amendNumPoints*period;

    %generate velocity polynomials and sequences
    [linVelPolyPre,linVelPolyPost]=prePostVelocityPolys(lintbf,lintaf,velVector,accVector);
    [angVelPolyPre,angVelPolyPost]=prePostVelocityPolys(angtbf,angtaf,angVelVector,angAccVector);
    [velSeqPre,velSeqPost]=generatePrePostSeq(linVelPolyPre,linVelPolyPost,lintbf,lintaf,tb,ta);
    [angVelSeqPre,angVelSeqPost]=generatePrePostSeq(angVelPolyPre,angVelPolyPost,angtbf,angtaf,tb,ta);
    velSeq=weldSeq(velSeqPre,velVector,velSeqPost);
    angVelSeq=weldSeq(angVelSeqPre,angVelVector,angVelSeqPost);

    %derive velocity to arrive at acceleration
    accPolyPre=deriveVelocity(linVelPolyPre);
    accPolyPost=deriveVelocity(linVelPolyPost);
    angAccPolyPre=deriveVelocity(angVelPolyPre);
    angAccPolyPost=deriveVelocity(angVelPolyPost);
    [accSeqPre,accSeqPost]=generatePrePostSeq(accPolyPre,accPolyPost,lintbf,lintaf,tb,ta);
    [angAccPre,angAccPost]=generatePrePostSeq(angAccPolyPre,angAccPolyPost,angtbf,angtaf,tb,ta);
    accSeq=weldSeq(accSeqPre,accVector,accSeqPost);
    angAccSeq=weldSeq(angAccPre,angAccVector,angAccPost);

    %integrate velocity to arrive at position
    posPolyPre=integrateVelocity(linVelPolyPre,posVector(1,:));
    posPolyPost=integrateVelocity(linVelPolyPost,posVector(end,:));
    [posSeqPre,posSeqPost]=generatePrePostSeq(posPolyPre,posPolyPost,lintbf,lintaf,tb,ta);
    posSeq=weldSeq(posSeqPre,posVector,posSeqPost);

    %these are the conditions for which the angular velocity
    %polynomials hold true, otherwise they are zero
    preTCond=zeros(3,2);
    postTCond=zeros(3,2);
    for n=1:3
        preTCond(n,:)=[angtbf(n) 0];
        postTCond(n,:)=[0 angtaf(n)];
    end
    %integrating from time zero to tb(end) allows us to set the initial
    %condition correctly, namely quatSeq(1,:)
    quatSeqPre=integrateAngVelocity(angVelPolyPre,quatSeq(1,:),fliplr(tb),preTCond);
    %account for the fact that we flipped the time
    quatSeqPre=flipud(quatSeqPre);
    quatSeqPost=integrateAngVelocity(angVelPolyPost,quatSeq(end,:),ta,postTCond);
    quatSeqAll=weldSeq(quatSeqPre,quatSeq,quatSeqPost);

    %smooth and compute smoothed linear velocity and acceleration
    smoothDataFunction = @(x) smoothdata(x,'gaussian',gaussInterval);
    newTime=((1:size(posSeq,1))-1)*period;
    posSeqSmooth=smoothData(posSeq,smoothDataFunction);
    velSeqSmooth=velocity(newTime,posSeqSmooth);
    accSeqSmooth=velocity(newTime,velSeqSmooth);

    %smooth and compute smoothed angular velocity and acceleration
    axangSeq=quat2axang(quatSeqAll);
    rotVecSeq=axangSeq(:,1:3).*axangSeq(:,4);
    rotVecSeqSmooth=smoothData(rotVecSeq,smoothDataFunction);
    rotVecSeqSmoothTheta=sqrt(dot(rotVecSeqSmooth,rotVecSeqSmooth,2));
    rotVecSeqSmoothAxis=rotVecSeqSmooth./rotVecSeqSmoothTheta;
    %generate frames from the rotation vectors in order to compute
    %angular velocity
    frameSeqSmooth=axang2rotm([rotVecSeqSmoothAxis rotVecSeqSmoothTheta]);
    angVelSeqSmooth=computeAngVelocity(newTime,frameSeqSmooth);
    angAccSeqSmooth=velocity(newTime,angVelSeqSmooth);
    
    newFrames=createFrames(posSeqSmooth,frameSeqSmooth);
    newFramesT=newFrames;
    %add back initial orientation
    for n=1:size(newFrames,3)
        newFramesT(1:3,1:3,n)=squeeze(newFramesT(1:3,1:3,n))*squeeze(frames(1:3,1:3,1));
    end
    figures=gobjects(0);

    if plotBool
        begNum=length(tb);
        endNum=length(ta)-1;

        fig1=figure(1);
        set(fig1,'visible','off');
        for n=1:3
            subplot(3,1,n);
            %plot the smoothed position
            plot(newTime,posSeqSmooth(:,n),'b');
            hold on
            plot(newTime,posSeq(:,n),'r');
            %plot two red circles showing where the amended trajectory starts and stops
            plot(newTime(begNum),posSeqSmooth(begNum,n),'ro');
            plot(newTime(end-endNum),posSeqSmooth(end-endNum,n),'ro');
            %plot position vector as if it had not been modified
            plot(newTime,[posVector(1,n)*ones(length(tb)-1,1);posVector(:,n);posVector(end,n)*ones(length(ta)-1,1)],'g');
        end
        figures(1)=fig1;

        %plot smoothed velocity
        fig2=figure(2);
        set(fig2,'visible','off');
        for n=1:3
            subplot(3,1,n);
            plot(newTime,velSeqSmooth(:,n),'b');
            hold on
            plot(newTime,velSeq(:,n),'r');
            plot(newTime(begNum),velSeqSmooth(begNum,n),'ro');
            plot(newTime(end-endNum),velSeqSmooth(end-endNum,n),'ro');
            plot(newTime(begNum:end-endNum),velVector(:,n),'g');
        end
        figures(2)=fig2;

        %plot smoothed acceleration
        fig3=figure(3);
        set(fig3,'visible','off');
        for n=1:3
            subplot(3,1,n);
            plot(newTime,accSeqSmooth(:,n),'b');
            hold on
            plot(newTime,accSeq(:,n),'r');
            plot(newTime(begNum),accSeqSmooth(begNum,n),'ro');
            plot(newTime(end-endNum),accSeqSmooth(end-endNum,n),'ro');
            plot(newTime(begNum:end-endNum),accVector(:,n),'g');
        end
        figures(3)=fig3;

        fig4=figure(4);
        set(fig4,'visible','off');
        for n=1:3
            subplot(3,1,n);
            %plot the smoothed position
            plot(newTime,rotVecSeqSmooth(:,n),'b');
            hold on
            plot(newTime,rotVecSeq(:,n),'r');
            %plot two red circles showing where the amended trajectory starts and stops
            plot(newTime(begNum),rotVecSeqSmooth(begNum,n),'ro');
            plot(newTime(end-endNum),rotVecSeqSmooth(end-endNum,n),'ro');
            %plot position vector as if it had not been modified
            plot(newTime,[rotVector(1,n)*ones(length(tb)-1,1);rotVector(:,n);rotVector(end,n)*ones(length(ta)-1,1)],'g');
        end
        figures(4)=fig4;

        %plot smoothed velocity
        fig5=figure(5);
        set(fig5,'visible','off');
        for n=1:3
            subplot(3,1,n);
            plot(newTime,angVelSeqSmooth(:,n),'b');
            hold on
            plot(newTime,angVelSeq(:,n),'r');
            plot(newTime(begNum),angVelSeqSmooth(begNum,n),'ro');
            plot(newTime(end-endNum),angVelSeqSmooth(end-endNum,n),'ro');
            plot(newTime(begNum:end-endNum),angVelVector(:,n),'g');
        end
        figures(5)=fig5;

        %plot smoothed acceleration
        fig6=figure(6);
        set(fig6,'visible','off');
        for n=1:3
            subplot(3,1,n);
            plot(newTime,angAccSeqSmooth(:,n));
            hold on
            plot(newTime,angAccSeq(:,n));
            plot(newTime(begNum),angAccSeqSmooth(begNum,n),'ro');
            plot(newTime(end-endNum),angAccSeqSmooth(end-endNum,n),'ro');
            plot(newTime(begNum:end-endNum),angAccVector(:,n),'g');
        end
        figures(6)=fig6;
    end
end