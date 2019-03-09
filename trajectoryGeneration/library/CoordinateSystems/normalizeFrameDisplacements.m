function frames=normalizeFrameDisplacements(frames)
    frames(1:3,4,:)=frames(1:3,4,:)-frames(1:3,4,1);
end