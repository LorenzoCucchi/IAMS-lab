%% DIRECT TRANSFER


clear all
close all
clc

load('dataA24.mat')

mu=398600.44;
      
    
DV_mat = [];
Dt_mat = [];
dom_T = 0.1*pi/180
%om_T_vect = ([deg2rad(0):dom_T:deg2rad(360)]);
om_T_vect = ([deg2rad(100):dom_T:deg2rad(300)]);

    
for om_T = om_T_vect(1):dom_T:om_T_vect(end)
    
    [DeltaV_T1, DeltaV_T2, a_T, e_T, i_T, OM_T, th_T_i, th_T_f] = directTransfer(PI.a, PI.e, PI.i, PI.OM, PI.om, PI.theta,    om_T,   PF.a, PF.e, PF.i, PF.OM, PF.om, PF.theta,   mu);

    % DELTA V
    DeltaV_vec = [DeltaV_T1 DeltaV_T2]';
    DV_mat = [DV_mat DeltaV_vec];

    % TRANSFER TIME
    t1 = Theta2t(a_T,e_T,mu,th_T_i,th_T_f);
    Deltat = t1;
    
    Deltat_vec = [t1]';
    Dt_mat = [Dt_mat Deltat_vec];
    
end


[~, k] = min( sum(DV_mat,1) ) % least sum of columns=deltaVs_for_each_maneuver
[~, ke] = min(Dt_mat)  
% DELTA V
DeltaV_vec = DV_mat(:,ke)
DeltaV_TOT = sum(DeltaV_vec)
om_T = om_T_vect(k)



    plot(rad2deg(om_T_vect), sum(DV_mat,1), 'b', 'LineWidth', 1);
    plot(rad2deg(om_T_vect), Dt_mat,'r','LineWidth',1)
    grid on
    hold on
    plot(rad2deg(om_T_vect(k)), min( sum(DV_mat,1) ), 'db', 'MarkerSize', 8);
    plot(rad2deg(om_T_vect(ke)), min(Dt_mat ), 'db', 'MarkerSize', 8);
    xlabel('\omega_t   [deg]')
    ylabel('\Deltav   [km/s]')
    legend('\Deltav_{tot}','\omega_t opt.')
    
  



    %**********************
        [DeltaV_T1, DeltaV_T2, a_T, e_T, i_T, OM_T, th_T_i, th_T_f] = directTransfer(PI.a, PI.e, PI.i, PI.OM, PI.om, PI.theta,    om_T,   PF.a, PF.e, PF.i, PF.OM, PF.om, PF.theta,   mu);
    %**********************

%rad2deg(th_T_i)
%rad2deg(th_T_f)
% TRANSFER TIME
%t1 = Theta2t(a_T,e_T,mu,th_T_i,th_T_f);
%Deltat = t1

%Deltat_vec = [t1]

%%
om_T = deg2rad(om_T_vect(ke));
% for om_T=0:1:360
% om_T=deg2rad(om_T)
orb(1,1)=PI.a;
orb(1,2)=PI.e;
orb(1,3)=PI.i;
orb(1,4)=PI.OM;
orb(1,5)=PI.om;
orb(1,6)=PI.theta-0.001;
orb(1,7)=PI.theta;


[orb(2,9),orb(2,10), orb(2,1), orb(2,2), orb(2,3), orb(2,4), orb(2,6), orb(2,7)] = directTransfer(PI.a, PI.e, PI.i, PI.OM, PI.om, PI.theta,   om_T,   PF.a, PF.e, PF.i, PF.OM, PF.om, PF.theta,   mu);
orb(2,5)=om_T;
[orb(2,12), orb(2,13), orb(2,14), orb(2,15)] = Theta2t(orb(2,1),orb(2,2),orb(2,6),orb(2,7));

orb(3,1)=PF.a;
orb(3,2)=PF.e;
orb(3,3)=PF.i;
orb(3,4)=PF.OM;
orb(3,5)=PF.om;
orb(3,6)=PF.theta-0.001;
orb(3,7)=PF.theta;

plotOrbit(orb,0.001)


results = orb;
results(4,8)=orb(2,9)+orb(2,10);
results(4,12)=orb(2,12);
orb(2,12);

r = results_csv(results);
% figure(2)
% plot(rad2deg(om_T),orb(2,2),'*');
% hold on
% figure(3)
% plot(rad2deg(om_T),results(4,8),'b')
% hold on

%end
