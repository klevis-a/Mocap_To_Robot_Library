function error=DetermineError(s_i,e_i,signal)
    makeUnit = @(x) x./sqrt(sum(x.^2,2));
    %locations of starting and ending index
    s_p=signal(s_i,:);
    e_p=signal(e_i,:);
    %vector between those points
    vector_b_points=e_p-s_p;
    points_between = signal(s_i+1:e_i-1,:)-s_p;
    %unit vector in direction between those points
    vector_b_points_u=makeUnit(vector_b_points);
    %projection matrix - this projects any vectors onto vector_b_points_u
    linear_projection_operator = vector_b_points_u'*vector_b_points_u;
    orth_projection_operator = eye(3)-linear_projection_operator;
    orth_projection = orth_projection_operator*points_between';
    error = sqrt(sum(orth_projection.^2));
end