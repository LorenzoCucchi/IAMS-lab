function [delta_V,delta_V2,TH_i,TH_i2,w_f,alpha,u_1,u_2] = change_plane(a,e,i_i,OH_i,w_i,i_f,OH_f,mu)

% INPUT

% a = semiaxis initial orbit                                   [km]
% e = eccentricity initial orbit 
% i_i = initial orbit inclination                              [rad]
% OH_i = longitude of ascending node of the initial orbit      [rad]
% w_i = Anomaly of the perigee of the initial orbit            [rad]
% i_f = finalorbit inclination                                 [rad]
% OH_f = longitude of ascending node of the final orbit        [rad]


% OUTPUT

% delta_V = cost of the Maneuver
% TH_i = maneuvre point position on the initial orbit          [rad]
% w_f = Anomaly of the perigee of the final orbit,
    % caused by changin the plane                              [rad]
    

if nargin == 7
    mu = 398600.44;
end

% Difference between the two longitude of ascending nodes and the two
% inclinations 

delta_OH = OH_f - OH_i;
delta_i = i_f - i_i;
p = a*(1-e^2);


% Check the case we are in

alpha = acos(cos(i_i)*cos(i_f)+sin(i_i)*sin(i_f)*cos(delta_OH));

cos_u_1 = (cos(alpha)*cos(i_i)-cos(i_f))/(sin(alpha)*sin(i_i));
cos_u_2 = (cos(i_i)-cos(alpha)*cos(i_f)/(sin(alpha)*sin(i_f));
sin_u_1 = sin(i_f)*(sin(delta_OH)/sin(alpha));
sin_u_2 = sin(i_i)*(sin(delta_OH)/sin(alpha));

if delta_OH > 0
    if delta_i >= 0

       u_1 = atan2(sin_u_1,cos_u_1);
       u_2 = atan2(sin_u_2,cos_u_2);
       
       TH_i = u_1 - w_i;
       w_f = u_2 - TH_i;
       
    else
        
       u_1 = atan2(sin_u_1,-cos_u_1);
       u_2 = atan2(sin_u_2,-cos_u_2);
       
       TH_i = 2*pi - u_1 - w_i;
       w_f = 2*pi - u_2 - TH_i;
        
    end
    
else
    
    if delta_i < 0
        
       u_1 = atan2(sin_u_1,cos_u_1);
       u_2 = atan2(sin_u_2,cos_u_2);
       
       TH_i = u_1 - w_i;
       w_f = u_2 - TH_i;
    
    else
     
       u_1 = atan2(sin_u_1,-cos_u_1);
       u_2 = atan2(sin_u_2,-cos_u_2);
       
       TH_i = 2*pi - u_1 - w_i;
       w_f = 2*pi - u_2 - TH_i;
        
    end
    
end

%  Start the change

v_teta = sqrt(mu/p)*(1+e*cos(TH_i));
TH_i2 = TH_i + pi;

v_teta_2 = sqrt(mu/p)*(1+e*cos(TH_i2));

delta_V = 2*v_teta*abs(sin(alpha/2));

delta_V2 = 2*v_teta_2*abs(sin(alpha/2));



end


        
        
        
        
        
        
        
        