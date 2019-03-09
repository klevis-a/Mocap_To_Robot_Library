function framesWithIdentity=prependIdentity(frames)
    framesWithIdentity=cat(3,eye(4),frames);
end