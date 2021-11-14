function [dV, theta_i, theta_f] = Change_w(a, e, w1, w2, theta ,mu)
% This function changes the pericenter anomaly returning the deltaV,
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


Deltaom = abs(w2 - w1) ;

thi1 = Deltaom/2;
thi2 = pi + Deltaom/2;

thf1 = 2* pi - Deltaom /2;
thf2 = pi - Deltaom /2;


p = a*(1 -e^2);

dV = 2 * sqrt (mu/p) * e * abs( sin ( Deltaom /2));


thi = [ thi1 thi2 ]';
thf = [ thf1 thf2 ]';


th_1 = wrapTo2Pi ( thi(1));
th_2 = wrapTo2Pi ( thi(2));
th_PC = wrapTo2Pi ( theta );

dist1 = th_1 - th_PC;
dist2 = th_2 - th_PC;

if ( dist1 < dist2 )
chosenTh = 1;
if ( dist1 * dist2 < 0)  % particular case
chosenTh = 2;

end
else
chosenTh = 2;
if ( dist1 * dist2 < 0)  % particular case
chosenTh = 1;
end
end



theta_i = wrapTo2Pi(thi(chosenTh));
theta_f = wrapTo2Pi(thf(chosenTh));


end