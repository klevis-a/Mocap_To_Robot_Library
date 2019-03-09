function p=generateVelocityPoly(tf,v0,a0)
    % tf - final time - note this can be negative
    %
    % v0 - velocity initial condition
    %
    % a0 - acceleration initial conditions
    %
    % velocity polynomial is v(t)=b0+b1*t+b2*t^2+b3*t^3
    % based on my notebook, b0=v0, b1=a0 and we are solving for b2,b3
    
    A=[tf^2  tf^3; ...
       2*tf  3*tf^2];
    b=[-v0-a0*tf; -a0];
    x=A\b;
    a2=x(1);
    a3=x(2);
    p=[a3 a2 a0 v0];
end
