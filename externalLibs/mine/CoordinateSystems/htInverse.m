function inv=htInverse(ht)
    %computes the inverse of a homoegeneous transformation matrix
    inv = zeros(4,4);
    inv(1:3,1:3)=ht(1:3,1:3)';
    inv(4,4)=1;
    inv(1:3,4)=-ht(1:3,1:3)'*ht(1:3,4);
end