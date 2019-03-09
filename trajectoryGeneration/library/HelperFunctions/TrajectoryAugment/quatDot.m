function dqdt=quatDot(w,q)
    dqdt=double(0.5*quaternion(w')*quaternion(q));
end
