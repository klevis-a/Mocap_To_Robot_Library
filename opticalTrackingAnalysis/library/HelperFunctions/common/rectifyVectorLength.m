function recVec=rectifyVectorLength(vector,newLength,fillFunction)
    recVec=[vector fillFunction(1,newLength-length(vector))];
end
