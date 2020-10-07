function moi_displaced=MoI_displace(moi,m,q)
    moi_displaced=moi+m*(norm(q)^2*eye(3)-outerProduct(q,q));
end