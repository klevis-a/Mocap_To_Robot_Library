function endpoints=findSequencesWithinVector(data)
    if(isempty(data))
        endpoints=zeros(2,1);
        return;
    end
    a=diff(data);
    b=find([a' inf]>1);
    lengths=diff([0 b]); %length of the sequences
    ends=cumsum(lengths); %endpoints of the sequences
    starts=ends-lengths+1;
    endpoints=zeros(2,length(starts));
    endpoints(1,:)=data(starts);
    endpoints(2,:)=data(ends);
end
