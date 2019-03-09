function Rortho=orthoNormalProject(R)
    [U,~,V]=svd(R);
    Rortho = U*V'; % Drop the diagonal
end