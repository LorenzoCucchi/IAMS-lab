function [a, e, i, OM , om , th] = car2par (rr ,vv ,mu)


% Trasformation from cartesian coordinates to Keplerian parameters
%
% ----------------------------------------------------------
%
% Input arguments :
% rr [3 x1] position vector ( ECI ) [km]
% vv [3 x1] velocity vector ( ECI ) [km/s]
% mu [1 x1] gravitational parameter [km ^3/s^2]
%
% ----------------------------------------------------------
%
% Output arguments :
% a [1 x1] semi - major axis [km]
% e [1 x1] eccentricity [-]
% i [1 x1] inclination [ rad ]
% OM [1 x1] RAAN [ rad ]
% om [1 x1] pericenter anomaly [rad ]
% th [1 x1] true anomaly [rad ]
%
% ----------------------------------------------------------

% 1. Moduli di posizione e velocita ’
r = norm (rr);
v = norm (vv);

% 2. Energia meccanica specifica e semiasse maggiore

eps = 1/2* v^2- mu/r;
a = -mu /(2* eps );

% 3. Vettore momento angolare specifico
hh = cross (rr ,vv);
h = norm (hh);

% 4. Vettore eccentricita ’ ed eccentricita ’
ee = cross (vv ,hh)/mu - rr/r;
e = norm (ee);

% 5. Inclinazione
i = acos (hh (3) /h);

% 6. Linea dei nodi
% definisco il versore k
kk = [0 0 1]';
nn = cross (kk ,hh)/ norm ( cross (kk ,hh));

% 7. Ascensione retta del nodo ascendente ( RAAN )
if(nn (2) >0)
OM = acos (nn (1) );
elseif (nn (2) <0)
OM = 2*pi - acos (nn (1) );
end

% 8. Anomalia del pericentro
if(ee (3) >0)
om = acos (dot (nn ,ee)/e);
elseif (ee (3) <0)
om = 2*pi - acos (dot(nn ,ee)/e);
end

% 9. Anomalia vera
% definisco la velocita * radiale vr
vr = dot (vv ,rr)/r;
if(vr >0)
th = acos (dot (rr ,ee)/(r*e));
elseif (vr <0)
th = 2*pi - acos (dot(rr ,ee)/(r*e));
end

end