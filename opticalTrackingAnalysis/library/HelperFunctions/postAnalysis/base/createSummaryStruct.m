function summaryStruct=createSummaryStruct()
    summaryStruct=struct;
    summaryStruct.pose=struct;
    summaryStruct.pose.position=struct;
    summaryStruct.pose.rotation=struct;
    summaryStruct.pose.euler=struct;
    summaryStruct.pose.euler.yxz=struct;
    summaryStruct.velocity=struct;
    summaryStruct.velocity.linear=struct;
    summaryStruct.velocity.angular=struct;
    summaryStruct.velocity.euler=struct;
    summaryStruct.velocity.euler.yxz=struct;
    summaryStruct.acceleration=struct;
    summaryStruct.acceleration.linear=struct;
    summaryStruct.acceleration.angular=struct;
    summaryStruct.acceleration.euler=struct;
    summaryStruct.acceleration.euler.zyz=struct;
    summaryStruct.acceleration.euler.yxz=struct;
end