% Transformation from Cartesan state to orbital elements
% 
% Imput arguments:
%----------------------------------------------------
% rr       [3x1]    position vector           [km]
% vv       [3x1]    velocity vector           [km/s]
% mu       [1x1]    gravitational parameter   [km^3/s^2]
%
%-----------------------------------------------------
% Output arguments:
% a           [1x1]    semi-major axis     [km]
% h           [1x1]    angular momentum    [kg*m^2/s]
% e           [1x1]    eccentricity        [-]
% i           [1x1]    inclination         [rad]
% OM          [1x1]    RAAN                [rad]
% om          [1x1]    perimeter anomaly   [rad]
% theta       [1x1]    true anomaly        [rad] 
function [a,h,e,i,OM,om,theta] = Orbita_parametres (rr,vv,mu)

if nargin == 2
    mu = 398600.44;
end

%modulo di r e v
r  = norm(rr)
v  = norm(vv)

%calcolo a 
a=1/(2/r-(v.^2)./mu);

%calcolo e
h_vec = cross(rr, vv);
h = norm(h_vec);

c1 = cross(vv, h_vec);
e_vec = 1/mu*(c1 - mu*(rr/r) );
e = norm(e_vec);

%calcolo i
k_vec = [0; 0; 1];
k = norm(k_vec);
c2 = dot(h_vec,k_vec);
i = acos(c2./h*k);
i_grad = rad2deg(i);

%calcolo OM
c3 = cross(k_vec, h_vec);
n_vec = c3./norm(c3);

I_vec = [1; 0; 0];
c4 = dot(I_vec,n_vec);

%controllo segno di c4
if n_vec(2) > 0
    OM = acos(c4);
    OM_grad = rad2deg(OM);
    
else
    OM = 2*pi-acos(c4);
    OM_grad = rad2deg(OM);
end

%calcolo om
c5 = dot(e_vec, k_vec);
c6 = dot(n_vec, e_vec);

%controllo segno di c5    
if c5 > 0
    om = acos(c6./e);
    om_grad = rad2deg(om);
    
else
    om = -acos(c6./e) + 2*pi;
    om_grad = rad2deg(om);
end

%calcolo theta
c7 = dot(vv, rr);
c8 = dot(rr, e_vec);

%controllo segno di c7    
if c7 > 0
    theta = acos(c8./(r*e));
    TH_grad = rad2deg(theta);
    
else
    theta = -acos(c8./(r*e)) + 2*pi;
    TH_grad = rad2deg(theta);
end

end


















