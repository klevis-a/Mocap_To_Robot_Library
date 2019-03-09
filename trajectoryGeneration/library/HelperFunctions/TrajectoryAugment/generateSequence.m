function aSequence=generateSequence(aPoly,tf,t)
	aSequence=zeros(length(t),3);
	for n=1:3
        tfi=find(t==tf(n));
		aSequence(1:tfi,n)=polyval(aPoly(n,:),t(1:tfi));
        aSequence(tfi+1:end,n)=aSequence(tfi,n);
	end
end
