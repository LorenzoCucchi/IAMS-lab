clear all
close all
clc

load('dataA24.mat')

a_i=PI.a;
e_i=PI.e
i_i=PI.i;
OM_i=PI.OM;
om_i=PI.om;
a_f=PF.a;
e_f=PF.e;
i_f=PF.i;
OM_f=PF.OM;
om_f=PF.om;
mu=398600


DV_mat = [];
de = .001;
e_vect = [e_i:de :0.99];

for e_1 = e_vect (1):de:e_vect (end)
% **********************
% DIMENSION CHANGE
[ DeltaV_ecc , om_1 , th_1 , a_1] = ChangeOrbitShape (a_i , e_i, i_i , OM_i , om_i , i_i , OM_i , e_1 , mu);

% PLANE CHANGE
[ DeltaV_plane , th_PC ,om_2] = change_plane (a_1 , e_1 ,i_i , OM_i , om_1 , i_f , OM_f , mu);

% PERIAPSIS ARGUMENT CHANGE
if(abs(om_f-om_2)>(pi/2))
    om_3=om_f+pi;
    tipe = 3;
else
    om_3=om_f;
    tipe =2;
end

[ DeltaV_periArg , th_peri_i , th_peri_f ] =Change_w (a_1 , e_1 , om_2 , om_3 , th_PC);

% BITANGENT TRANSFER
[ DeltaV_bitg , DeltaV_bitg1 , DeltaV_bitg2 , a_t ,e_t ] = Bitangent_Transfer (tipe,e_1 , a_1 , e_f, a_f , mu);

DeltaV_vec = [ DeltaV_ecc DeltaV_plane DeltaV_periArg DeltaV_bitg]' ;


DV_mat = [ DV_mat DeltaV_vec ];
% **********************
end

[ DeltaV_TOT , k] = min( sum(DV_mat ,1)); % least sum of columns =deltaVs_for_each_maneuver
DeltaV_vec = DV_mat(:,k);
e_1 = e_vect(k);

myFig = figure ;
plot (e_vect , sum( DV_mat ,1) ,'b','LineWidth', 1);
grid on
hold on
prova=abs(min(sum(DV_mat,1)))
plot ( e_vect(k), min(sum(DV_mat,1) ),'db', 'MarkerSize',8);
e_vect(k)
xlabel ('e [-]')
ylabel ('\ Deltav [km/s]')
legend ('\ Deltav_ {tot}','e opt .')


