function [delta_time, t_1, t_2, orbital_period] = tempi(a,e,theta_1,theta_2,mu)

% The output is the time between two points

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
