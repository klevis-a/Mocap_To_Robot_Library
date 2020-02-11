function [cs,rb]=determineCsRb(measure)
    if strcmp(measure{2},'linear') || strcmp(measure{2},'position')
        cs='linCS';
        rb='linRB';
    elseif strcmp(measure{2},'angular') || strcmp(measure{2},'rotation')
        cs='rotCS';
        rb='rotRB';
    else
        cs='eulerCS';
        rb='eulerRB';
    end
end