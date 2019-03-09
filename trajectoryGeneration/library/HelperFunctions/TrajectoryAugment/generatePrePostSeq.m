function [preSeq,postSeq]=generatePrePostSeq(prePoly,postPoly,tbf,taf,tb,ta)
    preSeq=generateSequence(prePoly,tbf,fliplr(tb));
    preSeq=flipud(preSeq);
    postSeq=generateSequence(postPoly,taf,ta);
end
