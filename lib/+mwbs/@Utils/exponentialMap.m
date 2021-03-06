function angle2R = exponentialMap(theta)
% exponentialMap Returns the rotation matrix given the angle theta

n = norm(theta);

if n < 1e-6
    angle2R = eye(3);
    return
end

theta_norm = theta / n;
angle2R = eye(3) + sin(n) * mwbs.Utils.skew(theta_norm) + (1 - cos(n)) * mwbs.Utils.skew(theta_norm) * mwbs.Utils.skew(theta_norm);

end
