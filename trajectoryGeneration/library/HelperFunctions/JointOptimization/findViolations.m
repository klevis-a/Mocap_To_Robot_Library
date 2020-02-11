function violationSummary=findViolations(velper)
    violationSummary=[];
    violCount=length(find(velper>0.99));
    if(violCount>0)
        violationSummary(1)=violCount;
        violationSummary(2)=max(max(velper));
    end
end
