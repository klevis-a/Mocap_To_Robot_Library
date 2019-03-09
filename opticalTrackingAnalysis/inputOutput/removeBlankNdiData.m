function data=removeBlankData(data)
    data(all(data<-3E28,2),:)=[];
end