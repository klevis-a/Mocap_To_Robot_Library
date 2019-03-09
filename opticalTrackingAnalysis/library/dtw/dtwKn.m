function [min_distance, path] = dtwKn(x,y,dfcn)
    numSignals=length(x);
    numX=size(x{1},2);
    numY=size(y{1},2);
    
    dist = zeros(numY,numX,numSignals);
    
    for n=1:numSignals
        curDistFunc=dfcn{n};
        curXSignal=x{n};
        curYSignal=y{n};
        for i=1:numY
            for j=1:numX
                dist(i,j,n)=curDistFunc(curYSignal(:,i),curXSignal(:,j));
            end
        end
    end
    
    for n=1:numSignals
        currentDist=squeeze(dist(:,:,n));
        dist(:,:,n)=reshape(tiedrank(currentDist(:)),size(currentDist));
    end
    
    dist = max(dist,[],3);
    
    ac=zeros(numY,numX);
    ac(1,1)=dist(1,1);
    
    for i=2:numY
        ac(i,1)=dist(i,1)+ac(i-1,1);
    end
    
    for i=2:numX
        ac(1,i)=dist(1,i)+ac(1,i-1);
    end
    
    for i=2:numY
        for j=2:numX
            ac(i,j)=dist(i,j)+min([ac(i-1,j-1), ac(i-1,j), ac(i,j-1)]);
        end
    end
    
    path=[numX, numY];
    
    i=numY;
    j=numX;
    
    while i>1 || j>1
        if i==1
            j=j-1;
        elseif j==1
            i=i-1;
        else
            if ac(i-1,j)==min([ac(i-1,j-1) ac(i-1,j) ac(i,j-1)])
                i=i-1;
            elseif ac(i,j-1)==min([ac(i-1,j-1) ac(i-1,j) ac(i,j-1)])
                j=j-1;
            else
                i=i-1;
                j=j-1;
            end
        end
        path=[path; [j i]];
    end
    
    min_distance=0;
    for n=1:size(path,1)
        min_distance=min_distance+dist(path(n,2),path(n,1));
    end
    path=flipud(path);
end