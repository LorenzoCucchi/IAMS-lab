function [ DeltaV , om_t , th_t , a_t] = ChangeOrbitShape (a_i ,e_i , i_i , OM_i , om_i , i_t , OM_t , e_t , mu)
% This function change the orbital plane (Omega,i) and the shape of the
% orbit (eccentricity vector) with a single impulse.
% 
% 
% Imput arguments:
% ---------------------------------------------------------------------
%
% a_i           [1x1]    initial semi-major axis                 [km]
% e_i           [1x1]    initial eccentricity                    [-]
% i_i           [1x1]    initial inclination                     [rad]
% OM_i          [1x1]    initial RAAN                            [rad]
% om_i          [1x1]    initial perimeter anomaly               [rad]
% i_t           [1x1]    terminal inclination                    [rad]
% OM_t          [1x1]    terminal RAAN                           [rad]
% e_t           [1x1]    terminal eccentricity                   [-]
% mu            [1x1]    standard gravitaional parameter         [m^3/s^2]
%
% Output arguments:
%---------------------------------------------------------------------
% DeltaV        [1x1]    velocity difference                    [km/s]
% om_t          [1x1]    terminal perimeter anomaly             [rad]
% th_t          [1x1]    terminal true anomaly                  [rad]
% a_t           [1x1]    terminal semi-major axis               [km]
%
% 

if nargin == 4
    mu = 398600.44;
end

DeltaOM = OM_t - OM_i ;
Deltai = i_t - i_i ;

if DeltaOM *Deltai >0
    alpha = acos (cos( i_i )*cos ( i_t) + sin( i_i )*sin( i_t )* cos (DeltaOM ));
    cosu1 = -( cos (i_t)-cos( alpha )* cos (i_i))/( sin( alpha )* sin (i_i ));
    cosu2 = ( cos (i_i)-cos ( alpha )*cos ( i_t))/( sin( alpha )* sin (i_t ));
    sinu1 = sin ( DeltaOM )/sin( alpha )* sin (i_t );
    sinu2 = sin ( DeltaOM )/sin( alpha )* sin (i_i );
    u1 = atan2 (sinu1 , cosu1 );
    u2 = atan2 (sinu2 , cosu2 );
    th_t = u1 - om_i ;
    om_t = u2 - th_t ;
else
    alpha = acos (cos( i_i )*cos ( i_t) + sin( i_i )*sin( i_t )* cos (DeltaOM ));
    cosu1 = (cos (i_t)-cos ( alpha )*cos ( i_i))/( sin( alpha )* sin (i_i ));
    cosu2 = -( cos (i_i)-cos( alpha )* cos (i_t))/( sin( alpha )* sin (i_t ));
    sinu1 = sin ( DeltaOM )/sin( alpha )* sin (i_t );
    sinu2 = sin ( DeltaOM )/sin( alpha )* sin (i_i );
    u1 = atan2 (sinu1 , cosu1 );
    u2 = atan2 (sinu2 , cosu2 );
    th_t = 2* pi - (u1 + om_i );
    om_t = 2* pi - (u2 + th_t );
end

p_i = a_i *(1 - e_i ^2);
p_t = p_i *(1+ e_t ) /(1+ e_i *cos( th_t ));
a_t = p_t /(1 - e_t ^2);

om_t = om_i + th_t ;
[~, v_i ] = param2rv (a_i ,e_i ,i_i ,OM_i ,om_i ,th_t , mu);
[~, v_t ] = param2rv (a_t ,e_t ,i_i ,OM_i ,om_t ,0, mu);


DeltaV = sqrt ( norm ( v_i)^2 + norm (v_t)^2 - 2* dot (v_i , v_t ));

end