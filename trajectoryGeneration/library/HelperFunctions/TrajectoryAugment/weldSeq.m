function seq=weldSeq(preSeq,origSeq,postSeq)
    seq=[preSeq(1:end-1,:);origSeq;postSeq(2:end,:)];
end
