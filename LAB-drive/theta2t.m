function [t] = theta2t (a,e,mu ,t1 , th_v )

t = [t1];

for i =1: length (th_v)-1

    th_1 = wrapTo2Pi ( th_v (i));
    th_2 = wrapTo2Pi ( th_v (i+1));
    
    % Initial eccentric anomaly
    E1 = 2 * atan ( tan( th_1 /2) * sqrt ((1 - e) /(1 + e)));
    
    if E1 < 0
        E1 = E1 + 2 * pi;
    end
    
    % Final eccentric anomaly
    E2 = 2 * atan ( tan( th_2 /2) * sqrt ((1 - e) /(1 + e)));
    
    if E2 < 0
        E2 = E2 + 2 * pi;
    end
    
    % Mean anomalies ( initial and final )
    M1 = E1 - e * sin(E1);
    
    M2 = E2 - e * sin(E2);
    
    % Mean angular rate
    n = sqrt (mu/a ^3) ;
    
    % M = n*t
    delta_t = (M2 - M1)/n;
    
    if delta_t < 0
        T = 2 * pi * sqrt (a ^3/ mu);
        delta_t = delta_t + T;
    end
    
    % Update time - vector
    t = [t; t( end )+ delta_t ];

end

end