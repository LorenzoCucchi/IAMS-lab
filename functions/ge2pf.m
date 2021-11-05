function [T_ge2pf] = ge2pf(i,OM,om)
% rotation matrix from perifocal reference system to geocentric reference
% system
%
% Imput arguments:
% -------------------------------------------------------------------
%
% i           [1x1]    inclination                        [rad]
% OM          [1x1]    RAAN                               [rad]
% om          [1x1]    perimeter anomaly                  [rad]
%
% Output arguments:
%--------------------------------------------------------------------
% T_ge2pf     [3x3]   rotation matrix                     [-]
% 
%
OM_mat = [cos(OM) sin(OM) 0; -sin(OM) cos(OM) 0; 0 0 1];
      
i_mat = [1 0 0; 0 cos(i) sin(i); 0 sin(i) cos(i)];
     
w_mat = [cos(om) sin(om) 0; -sin(om) cos(om) 0; 0 0 1];

T_ge2pf =  w_mat*i_mat*OM_mat;