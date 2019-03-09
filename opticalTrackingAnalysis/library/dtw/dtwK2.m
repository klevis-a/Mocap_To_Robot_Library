function [min_distance, path] = dtwK2(x,y,dfcn,x1,y1,dfcn2)
    numX=size(x,2);
    numY=size(y,2);
    
    dist = zeros(numY,numX);
    dist1 = zeros(numY,numX);
    
    for i=1:numY
        for j=1:numX
            dist(i,j)=dfcn(y(:,i),x(:,j));
            dist1(i,j)=dfcn2(y1(:,i),x1(:,j));
        end
    end
    
    dist=reshape(tiedrank(dist(:)),size(dist));
    dist1=reshape(tiedrank(dist1(:)),size(dist1));
    
    dist = max(cat(3,dist,dist1),[],3);
    
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