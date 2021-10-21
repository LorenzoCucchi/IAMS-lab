function [T_ge2pf] = ge2pf(i,OM,om)

% matrici di rotazione da perifocale a geocentrica
OM_mat = [cos(OM) sin(OM) 0;
          -sin(OM) cos(OM) 0;
          0 0 1];
      
i_mat = [1 0 0;
         0 cos(i) sin(i); 
         0 sin(i) cos(i)]
     
w_mat = [cos(om) sin(om) 0; 
         -sin(om) cos(om) 0; 
         0 0 1];

T_ge2pf =  w_mat*i_mat*OM_mat;