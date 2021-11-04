function [delta_tot, dv_1, dv_2, a_2, e_2] = Bitangent_Transfer(tipe, e_1, a_1, e_3, a_3, mu)
% This function actuate a bitangent transfer between two orbits in apsidal points
%
% Imput arguments:
% %-----------------------------------------------------
%
% tipe "1" = P1 to A2
% tipe "2" = A1 to P2
% tipe "3" = P1 to P2
% tipe "4" = P1 to P2
% e_1           [1x1]    initial eccentricity                          [-]
% a_1           [1x1]    initial semi-major axis                       [km]
% e_3           [1x1]    terminal eccentricity                         [-]
% a_3           [1x1]    terminal semi-major axis                      [km]
% mu            [1x1]    standard gravitaional parameter               [m^3/s^2]
%
% Output arguments:
%----------------------------------------------------
% delta_tot   [1x1]    total velocity difference on manoeuvr    [km/s]
% dv_1        [1x1]    initial orbit transfer                   [rad]
% dv_2        [1x1]    final orbit transfer point               [rad]
% a_2         [1x1]    initial semi-major axis                  [km]
% e_2         [1x1]    terminal eccentricity                    [-]
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















