function mat=outerProduct(u,v)
    mat=zeros(size(u,1),size(v,2));
    for i=1:length(u)
        for j=1:length(v)
            mat(i,j)=u(i)*v(j);
        end
    end
end
