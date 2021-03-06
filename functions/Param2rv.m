function [rr,vv] = Param2rv(a,e,i,OM,om,theta,mu)
% Transformation from Cartesan state to orbital elements
% 
% Imput arguments:
% -----------------------------------------------------
%
% a           [1x1]    semi-major axis                    [km]
% e           [1x1]    eccentricity                       [-]
% i           [1x1]    inclination                        [rad]
% OM          [1x1]    RAAN                               [rad]
% om          [1x1]    perimeter anomaly                  [rad]
% theta       [1x1]    true anomaly                       [rad]
% mu          [1x1]    standard gravitaional parameter    [m^3/s^2]
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

% x_pf = [ (p*cos(theta)./(1+e*cos(theta))) ; (p*sin(theta))./(1+e*cos(theta)) ; 0 ];
%  
% v_pf = [-sqrt(mu./p)*sin(theta); sqrt(mu./p)*(e+cos(theta));0];
% 
% T_pf2ge = (ge2pf(i,OM,om))';
% 
% rr = T_pf2ge*x_pf;
% vv = T_pf2ge*v_pf;

r_PF = r * [cos(theta), sin(theta), 0]'; % Position vector [km]
v_PF = sqrt (mu/p) * [- sin(theta), (e+cos(theta)), 0]'; % Velocity

R_om = [ cos(om) sin(om) 0 ; -sin(om) cos(om) 0 ; 0 0 1 ];
R_i = [ 1 0 0 ; 0 cos(i) sin(i); 0 -sin(i) cos(i)];
R_OM = [ cos(OM) sin(OM) 0 ; -sin(OM) cos(OM) 0 ; 0 0 1 ];
R313 = R_om * R_i * R_OM ; % ECI --> PF (i.e. x_PF = R313 *x_ECI )

% PF ->ECI Transformation ( inverse of R313 )
rr = R313'* r_PF ;
vv = R313'* v_PF ;

end
