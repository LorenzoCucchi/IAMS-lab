function [DeltaV_T1, DeltaV_T2, a_T, e_T, i_T, OM_T, th_T_i, th_T_f] = directTransfer(a_i, e_i, i_i, OM_i, om_i, th_i,    om_T,   a_f, e_f, i_f, OM_f, om_f, th_f,   mu)

if nargin == 13
    mu = 398600.44;
end

I = [1 0 0]';
J = [0 1 0]';
K = [0 0 1]';

[rr_i,v_i] = Param2rv(a_i,e_i,i_i,OM_i,om_i,th_i, mu);
[rr_f,v_f] = Param2rv(a_f,e_f,i_f,OM_f,om_f,th_f, mu);
r_i = norm(rr_i);
r_f = norm(rr_f);


h_vers = cross(rr_i, rr_f)/norm(cross(rr_i, rr_f));

i_T = acos( dot(K,h_vers) );
N_T = cross(K,h_vers)/norm(cross(K,h_vers));

if(N_T(2)>=0)
    OM_T = acos(N_T(1));
elseif(N_T(2)<0)
    OM_T = 2*pi-acos(N_T(1));
end




% Rotation matrices: Earth-Centered Inertial --> Perifocal   (ECI->PF)
R_om = [cos(om_T)  sin(om_T)    0   ;
        -sin(om_T) cos(om_T)    0   ;
           0        0       1   ];
       
R_i  = [   1        0       0   ;
           0     cos(i_T)   sin(i_T);
           0    -sin(i_T)   cos(i_T)];
       
R_OM = [cos(OM_T)  sin(OM_T)    0   ;
        -sin(OM_T) cos(OM_T)    0   ;
           0        0       1   ];

R313 = R_om * R_i * R_OM; %  ECI --> PF  (i.e. x_PF = R313*x_ECI)
       
% PF->ECI Transformation (inverse of R313)
e_T_vers = R313' * I;
%quiver3(0,0,0,e_T_vers(1), e_T_vers(2), e_T_vers(3),15000, '-g', 'LineWidth',1.5, 'MaxHeadSize', 10);


th_T_i = acos( dot(rr_i/r_i,e_T_vers) );  
th_T_f = acos( dot(rr_f/r_f,e_T_vers) );
e_T = (r_f - r_i) / ( r_i*cos(th_T_i) - r_f*cos(th_T_f) );
a_T = r_i * (1+e_T*cos(th_T_i)) / (1-e_T^2);

% Check if radial velocity is negative (i.e. we are moving from A to P)
 [~,v_T_i] = Param2rv(a_T,e_T,i_T,OM_T,om_T,th_T_i, mu);
vr = dot(v_T_i,rr_i)/r_i;
if vr<0
    th_T_i = 2*pi - th_T_i;
    [~,v_T_i] = Param2rv(a_T,e_T,i_T,OM_T,om_T,th_T_i, mu);
end
 [~,v_T_f] = Param2rv(a_T,e_T,i_T,OM_T,om_T,th_T_f, mu);
vr = dot(v_T_f,rr_f)/r_f;
if vr<0
    th_T_f = 2*pi - th_T_f;
    [~,v_T_i] = Param2rv(a_T,e_T,i_T,OM_T,om_T,th_T_i, mu);
end

[~,v_T_i] = Param2rv(a_T,e_T,i_T,OM_T,om_T,th_T_i, mu);
[~,v_T_f] = Param2rv(a_T,e_T,i_T,OM_T,om_T,th_T_f, mu);



DeltaV_T1 = sqrt( norm(v_i)^2 + norm(v_T_i)^2 - 2*dot(v_i,v_T_i) );
DeltaV_T2 = sqrt( norm(v_T_f)^2 + norm(v_f)^2 - 2*dot(v_T_f,v_f) );


end