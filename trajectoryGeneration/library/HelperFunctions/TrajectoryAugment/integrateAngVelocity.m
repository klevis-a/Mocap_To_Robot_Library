function [quatSeq,tSolved]=integrateAngVelocity(angVelPoly,initCond,tall,tcond)
    %here we have to solve a system of coupled nonlinear PDEs in order to
    %integrate
    qdot = @(t,q) quatDot(evalAngVel(angVelPoly,t,tcond), q);
    [tSolved,quatSeq]=ode45(qdot,tall,initCond');
end
