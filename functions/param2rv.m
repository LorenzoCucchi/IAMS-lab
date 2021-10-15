function [r_vec,v_vec] = param2rv(a,e,i,OH,w,TH,mu)
tic
if nargin == 6
    mu = 398600.44;
end

p = a*(1-e^2);
r = p/(1+e*cos(TH));

% matrici di rotazione da perifocale a geocentrica
OH_mat = [cos(OH) sin(OH) 0;
          -sin(OH) cos(OH) 0;
          0 0 1];
      
i_mat = [1 0 0;
         0 cos(i) sin(i); 
         0 sin(i) cos(i)]
     
w_mat = [cos(w) sin(w) 0; 
         -sin(w) cos(w) 0; 
         0 0 1];

x_pf = [ (p*cos(TH)./(1+e*cos(TH))) ; (p*sin(TH))./(1+e*cos(TH)) ; 0 ];
 
v_pf = [-sqrt(mu./p)*sin(TH); sqrt(mu./p)*(e+cos(TH));0];

T_ge2pf =  w_mat*i_mat*OH_mat;
T_pf2ge = T_ge2pf';

r_vec = T_pf2ge*x_pf;
v_vec = T_pf2ge*v_pf;
toc
end
