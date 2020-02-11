function mmdegStruct=convertTommdeg(calcStruct)
    %now convert to mm and deg (position)
    mmdegStruct.pose.position.vector=calcStruct.pose.position.vector*1000;
    mmdegStruct.pose.rotation.vector=rad2deg(calcStruct.pose.rotation.vector);
    mmdegStruct.pose.position.scalar=calcStruct.pose.position.scalar*1000;
    mmdegStruct.pose.rotation.scalar=rad2deg(calcStruct.pose.rotation.scalar);
    mmdegStruct.pose.euler.zyz.vector=rad2deg(calcStruct.pose.euler.zyz.vector);
    mmdegStruct.pose.euler.yxz.vector=rad2deg(calcStruct.pose.euler.yxz.vector);
    
    %now convert to mm and deg (velocity)
    mmdegStruct.velocity.linear.vector=calcStruct.velocity.linear.vector*1000;
    mmdegStruct.velocity.linear.scalar=calcStruct.velocity.linear.scalar*1000;
    mmdegStruct.velocity.angular.vector=rad2deg(calcStruct.velocity.angular.vector);
    mmdegStruct.velocity.angular.scalar=rad2deg(calcStruct.velocity.angular.scalar);
    mmdegStruct.velocity.euler.zyz.vector=rad2deg(calcStruct.velocity.euler.zyz.vector);
    mmdegStruct.velocity.euler.yxz.vector=rad2deg(calcStruct.velocity.euler.yxz.vector);
    mmdegStruct.velocity.axial=calcStruct.velocity.axial*1000;
    
    %now convert to mm and deg (acceleration)
    mmdegStruct.acceleration.linear.vector=calcStruct.acceleration.linear.vector*1000;
    mmdegStruct.acceleration.linear.scalar=calcStruct.acceleration.linear.scalar*1000;
    mmdegStruct.acceleration.angular.vector=rad2deg(calcStruct.acceleration.angular.vector);
    mmdegStruct.acceleration.angular.scalar=rad2deg(calcStruct.acceleration.angular.scalar);
    mmdegStruct.acceleration.euler.zyz.vector=rad2deg(calcStruct.acceleration.euler.zyz.vector);
    mmdegStruct.acceleration.euler.yxz.vector=rad2deg(calcStruct.acceleration.euler.yxz.vector);
end