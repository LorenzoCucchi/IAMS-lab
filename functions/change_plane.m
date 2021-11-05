function [delta_V,TH_i,om_f] = change_plane(a,e,i_i,OM_i,om_i,i_f,OM_f,mu)

% INPUT
%----------------------------------------------------
% a = semiaxis initial orbit                                   [km]
% e = eccentricity initial orbit                               [-]
% i_i = initial orbit inclination                              [rad]
% OH_i = longitude of ascending node of the initial orbit      [rad]
% w_i = Anomaly of the perigee of the initial orbit            [rad]
% i_f = finalorbit inclination                                 [rad]
% OH_f = longitude of ascending node of the final orbit        [rad]
%
%
% OUTPUT
%----------------------------------------------------
% delta_V = cost of the Maneuver
% TH_i = maneuvre point position on the initial orbit          [rad]
% w_f = Anomaly of the perigee of the final orbit,
% caused by changin the plane                                  [rad]
    

if nargin == 7
    mu = 398600.44;
end

% Difference between the two longitude of ascending nodes and the two
% inclinations 

delta_OM = OM_f - OM_i;
delta_i = i_f - i_i;
p = a*(1-e^2);


% Check the case we are in

alpha = acos(cos(i_i)*cos(i_f)+sin(i_i)*sin(i_f)*cos(delta_OM));

cos_u_1 = (cos(alpha)*cos(i_i)-cos(i_f))/(sin(alpha)*sin(i_i));
cos_u_2 = (cos(i_i)-cos(alpha)*cos(i_f))/(sin(alpha)*sin(i_f));
sin_u_1 = sin(i_f)*(sin(delta_OM)/sin(alpha));
sin_u_2 = sin(i_i)*(sin(delta_OM)/sin(alpha));

if delta_OM*delta_i >=0 
    
       u_1 = atan2(sin_u_1,cos_u_1);
       u_2 = atan2(sin_u_2,cos_u_2);
       
       TH_i = u_1 - om_i;
       om_f = u_2 - TH_i;
       
else
        
       u_1 = atan2(sin_u_1,-cos_u_1);
       u_2 = atan2(sin_u_2,-cos_u_2);
       
       TH_i = 2*pi - u_1 - om_i;
       om_f = 2*pi - u_2 - TH_i;
    
end


if cos(TH_i)>0
    TH_i=TH_i+pi;
end

TH_i = wrapTo2Pi(TH_i);
v_teta = sqrt(mu/p)*(1+e*cos(TH_i));



delta_V = 2*v_teta*abs(sin(alpha/2));




end


        
        
        
        
        
        
        
        