function [a,h,e,i_rad,OH_rad,w_rad,TH_rad] = Orbita_parametres (r_vec,v_vec,mu)

if nargin == 2
    mu = 398600.44;
end

%modulo di r e v
r  = norm(r_vec)
v  = norm(v_vec)

%calcolo semiasse 
a=1/(2/r-(v.^2)./mu);

h_vec = cross(r_vec, v_vec);
h = norm(h_vec);

c1 = cross(v_vec, h_vec);
e_vec = 1/mu*(c1 - mu*(r_vec/r) );
e = norm(e_vec);

k_vec = [0; 0; 1];
k = norm(k_vec);
c2 = dot(h_vec,k_vec);
i_rad = acos(c2./h*k);
i_grad = rad2deg(i_rad);

c3 = cross(k_vec, h_vec);
n_vec = c3./norm(c3);

I_vec = [1; 0; 0];
c4 = dot(I_vec,n_vec);

%controllo segno di c4
if n_vec(2) > 0
    OH_rad = acos(c4);
    OH_grad = rad2deg(OH_rad);
    
else
    OH_rad = 2*pi-acos(c4);
    OH_grad = rad2deg(OH_rad);
end

c5 = dot(e_vec, k_vec);
c6 = dot(n_vec, e_vec);

%controllo segno di c5    
if c5 > 0
    w_rad = acos(c6./e);
    w_grad = rad2deg(w_rad);
    
else
    w_rad = -acos(c6./e) + 2*pi;
    w_grad = rad2deg(w_rad);
end


c7 = dot(v_vec, r_vec);
c8 = dot(r_vec, e_vec);

%controllo segno di c7    
if c7 > 0
    TH_rad = acos(c8./(r*e));
    TH_grad = rad2deg(TH_rad);
    
else
    TH_rad = -acos(c8./(r*e)) + 2*pi;
    TH_grad = rad2deg(TH_rad);
end

end


















