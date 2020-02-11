function writeFramesFile(tb,frames,file)
    %unfold the frames, i.e. go from 4x4 to 16x1
    unfoldedFrames=reshape(permute(frames, [3 2 1]),[],16);
    
    %write the frames
    dlmwrite(file, [tb unfoldedFrames], 'delimiter', ',','precision',10);
end