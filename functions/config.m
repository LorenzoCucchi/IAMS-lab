close all
clear all
clc


%%
% orbit matrix [1,2,3, 4, 5,  6,  7,    8,  9, 10, 11, 12, 13, 14]
% orbit matrix [a,e,i,OM,om,th1,th2,dVtot,dV1,dV2,dV3, dT, t1, t2]

load('dataA24.mat')



%% change of plan,w,shape 

    orb(1,1)=PI.a;
    orb(1,2)=PI.e;
    orb(1,3)=PI.i;
    orb(1,4)=PI.OM;
    orb(1,5)=PI.om;
    orb(1,6)=PI.theta;

    % change of plan
    orb(2,:)=orb(1,:);
    orb(2,4)=PF.OM;
    orb(2,3)=PF.i
    [orb(2,8),orb(1,7),orb(2,5)] = change_plane(PI.a,PI.e,PI.i,PI.OM,PI.om,PF.i,PF.OM)
    orb(1,7)=orb(1,7)-2*pi;
    orb(2,6)=orb(1,7);
    
    [orb(1,12), orb(1,13), orb(1,14), TO(1).orbital_period(1)] = tempi(PI.a,PI.e,PI.theta,orb(1,7));
    
    % change of w    %conviene utilizzare il punto B nel nostro caso e
    % utilizzare il TO(1).theta_2 nel change of plan e il TO(2).theta_2 per
    % ottenere il tempo minore possibile
    [TO(2).delta_V, TO(2).theta_1, TO(2).theta_2] = change_w_prova(PI.a, PI.e, PI.om, PF.om,TO(1).t_2(1));
    [TO(2).delta_time(1), TO(2).t_1, TO(2).t_2, TO(2).orbital_period] = tempi(PI.a,PI.e,TO(1).theta_1,TO(2).theta_1);
    [TO(2).delta_time(2), TO(2).t_1, TO(2).t_2, TO(2).orbital_period] = tempi(PI.a,PI.e,TO(1).theta_1,TO(2).theta_2);

    %change of shape
    tipe = 1;
    switch tipe
    case 1
        TO(3).theta_1 = 0;
        TO(3).theta_2 = pi;
    case 2
        TO(3).theta_1 = pi;
        TO(3).theta_2 = 0;
    case 3
        TO(3).theta_1 = pi;
        TO(3).theta_2 = pi;
    case 4
        TO(3).theta_1 = 0;
        TO(3).theta_2 = 0;  
    end


    [TO(3).delta_V, TO(3).dv_1, TO(3).dv_2, TO(3).a_2, TO(3).e_2] = biell(tipe, PI.e, PI.a, PF.e, PF.a);
    [TO(3).delta_time(1), TO(3).t_1, TO(3).t_2, TO(3).orbital_period] = tempi(PI.a,PI.e,TO(2).theta_2,TO(3).theta_1);
    [TO(3).delta_time(2), TO(3).t_1, TO(3).t_2, TO(3).orbital_period] = tempi(TO(3).a_2,TO(3).e_2,TO(3).theta_1,TO(3).theta_2);


