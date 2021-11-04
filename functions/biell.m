function [delta_tot, dv_1, dv_2, a_2, e_2] = biell(tipe, e_1, a_1, e_3, a_3, mu)
% (da modificare)This function changes the pericenter anomaly returning the deltaV,
% the transfer point theta1 and the converted point theta2 on the final
% orbit due to the change of the pericenter anomaly. 
% 
% Imput arguments:
% %-----------------------------------------------------
%
% a           [1x1]    semi-major axis                       [km]
% e           [1x1]    eccentricity                          [-]
% w1          [1x1]    first pericenter anomaly              [rad]
% w2          [1x1]    final pericenter anomaly              [rad]
% theta       [1x1]    true anomaly of the starting point    [rad]
% mu          [1x1]    standard gravitaional parameter       [m^3/s^2]
%
% Output arguments:
%----------------------------------------------------
% dV          [3x1]    velocity difference          [km]
% theta_i     [1x1]    initial orbit transfer       [rad]
% theta_f     [1x1]    final orbit transfer point   [rad]
%
%
% 
if nargin == 5
    mu = 398600.44;
end

if e_1 == 1
    r_p_1 = a_1;
    r_a_1 = a_1;
else
    r_p_1 = a_1*(1-e_1);
    r_a_1 = a_1*(1+e_1);
end

if e_3 == 1
    r_p_3 = a_3;
    r_a_3 = a_3;
else 
    r_p_3 = a_3*(1-e_3);
    r_a_3 = a_3*(1+e_3);
end

p_1 = r_p_1*(1+e_1);
p_2 = r_a_3*(1-e_3);


switch tipe
    case 1
        %case 1, the orbit are non crossing. Transfer between fist perigee
        %and second apogee
        
        e_2 = (r_a_3-r_p_1)/(r_a_3+r_p_1);
        a_2 = (r_p_1+r_a_3)/2;
        
        dv_1 = sqrt(2*mu*((1/r_p_1)-(1/(2*a_2))))-sqrt(2*mu*((1/r_p_1)-(1/(2*a_1))));
        dv_2 = sqrt(2*mu*((1/r_a_3)-(1/(2*a_3))))-sqrt(2*mu*((1/r_a_3)-(1/(2*a_2))));
        
        delta_tot = abs(dv_1) + abs(dv_2);
        
    case 2
        %case 1, the orbit are non crossing. Transfer between inital apogee
        %to second perigee
        
        a_2 = (r_a_1+r_p_3)/2;
        e_2 = (r_a_1-r_p_3)/(r_a_1+r_p_3);
        
        dv_1 = sqrt(2*mu*((1/r_a_1)-(1/(2*a_2))))-sqrt(2*mu*((1/r_a_1)-(1/(2*a_1))));
        dv_2 = sqrt(2*mu*((1/r_p_3)-(1/(2*a_3))))-sqrt(2*mu*((1/r_p_3)-(1/(2*a_2))));
        
        delta_tot = abs(dv_1) + abs(dv_2);
        
    case 3
        % orbits crossing. between apogees
        
        a_2 = (r_a_1+r_a_3)/2;
        e_2 = (r_a_1-r_a_3)/(r_a_1+r_a_3);
        
        dv_1 = sqrt(2*mu*((1/r_a_1)-(1/(2*a_2))))-sqrt(2*mu*((1/r_a_1)-(1/(2*a_1))));
        dv_2 = sqrt(2*mu*((1/r_a_3)-(1/(2*a_3))))-sqrt(2*mu*((1/r_a_3)-(1/(2*a_2))));
        
        delta_tot = abs(dv_1) + abs(dv_2);

    case 4
        % orbits crossing. between perigees
        
        a_2 = (r_p_1+r_p_3)/2;
        e_2 = (r_p_1-r_p_3)/(r_p_1+r_p_3);
        
        dv_1 = sqrt(2*mu*((1/r_p_1)-(1/(2*a_2))))-sqrt(2*mu*((1/r_p_1)-(1/(2*a_1))));
        dv_2 = sqrt(2*mu*((1/r_p_3)-(1/(2*a_3))))-sqrt(2*mu*((1/r_p_3)-(1/(2*a_2))));
        
        delta_tot = abs(dv_1) + abs(dv_2);


end

end















