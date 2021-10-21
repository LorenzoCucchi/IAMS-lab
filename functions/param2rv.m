function [rr,vv] = param2rv(a,e,i,OM,om,theta,mu)
% Transformation from Cartesan state to orbital elements
% 
% Imput arguments:
% %-----------------------------------------------------
%
% a           [1x1]    semi-major axis     [km]
% e           [1x1]    eccentricity        [-]
% i           [1x1]    inclination         [rad]
% OM          [1x1]    RAAN                [rad]
% om          [1x1]    perimeter anomaly   [rad]
% theta       [1x1]    true anomaly        [rad]
%
% Output arguments:
%----------------------------------------------------
% rr       [3x1]    position vector           [km]
% vv       [3x1]    velocity vector           [km/s]
% 
%
%
% 


if nargin == 6
    mu = 398600.44;
end

p = a*(1-e^2);
r = p/(1+e*cos(theta));

x_pf = [ (p*cos(theta)./(1+e*cos(theta))) ; (p*sin(theta))./(1+e*cos(theta)) ; 0 ];
 
v_pf = [-sqrt(mu./p)*sin(theta); sqrt(mu./p)*(e+cos(theta));0];

T_pf2ge = (ge2pf(i,OM,om))';

rr = T_pf2ge*x_pf;
vv = T_pf2ge*v_pf;

end
