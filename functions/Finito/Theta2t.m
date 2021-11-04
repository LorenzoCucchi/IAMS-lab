function [delta_time, t_1, t_2, orbital_period] = Theta2t(a,e,theta_1,theta_2,mu)
% The main output is the time difference between two points on the orbit
% 
% 
% Imput arguments:
% -------------------------------------------------------
%
% a             [1x1]      semi-major axis                             [km]
% e             [1x1       eccentricity                                [-]
% theta_1       [1x1]      intitial true anomaly                       [rad]
% theta_2       [1x1]      terminal true anomaly                       [rad]
% mu            [1x1]      standard gravitaional parameter             [m^3/s^2]
%
% Output arguments:
%-----------------------------------------------------------
% delta_time             [1x1]    time difference between theta_1 and theta_2    [s]
% t_1                    [1x1]    time at theta_1                                [s]
% t_2                    [1x1]    time at theta_2                                [s]
% orbital period         [1x1]    terminal true anomaly                          [rad]
%
% 


if nargin == 4
    mu = 398600.44;
end

    E_1 = 2*atan(sqrt((1-e)/(1+e))*tan(theta_1/2));
    E_2 = 2*atan(sqrt((1-e)/(1+e))*tan(theta_2/2));

    t_1 = sqrt((a^3)/mu)*(E_1-e*sin(E_1));
    t_2 = sqrt((a^3)/mu)*(E_2-e*sin(E_2));

    orbital_period = (2*pi/sqrt(mu))*a^(3/2);

    delta_time = t_2 - t_1;

    if delta_time < 0
        delta_time = delta_time + orbital_period;
    end


end
