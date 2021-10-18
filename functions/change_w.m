function [dV, teta1, teta2] = change_w(a, e, w1, w2, mu)




if nargin == 4
    mu = 398600.44;
end


dw = w2 - w1;

point = input('Choose whether to make the manoeuvre at the point A or B\n', 's');


%Cas dw>0

if dw > 0
    if point == 'A'
        
       teta1 = dw/2;
       teta2 = 2*pi-dw/2;
       
    else
        
        teta1 = dw/2 + pi;
        teta2 = pi - dw/2;
        
    end
    
    p = a*(1-norm(e)^2);
    
    Vteta1 = sqrt(mu/p)*(1+e*cos(dw/2));
    Vteta2 = sqrt(mu/p)*(1+e*cos(2*pi-dw/2));
    
    Vr1 = sqrt(mu/p)*e*sin(dw/2);
    Vr2 = -sqrt(mu/p)*e*sin(dw/2);
    
    dV = 2*abs(Vr1);
    
%Case dw<0

else
    
    if point == 'A'
        
        teta1 = dw/2 + 2*pi;
        teta2 = - dw/2;
        
    else
        
        teta1 = dw/2 + pi;
        teta2 = pi - dw/2;
        
    end
    
    p = a*(1-norm(e)^2);
    
    
    Vteta1 = sqrt(mu/p)*(1+e*cos(-dw/2));
    Vteta2 = sqrt(mu/p)*(1+e*cos(2*pi+dw/2));
    
    Vr1 = sqrt(mu/p)*e*sin(-dw/2);
    Vr2 = -sqrt(mu/p)*e*sin(-dw/2);
    
    dV = 2*abs(Vr1);    
        
        
end

        
        
        
        
        
        
        
        