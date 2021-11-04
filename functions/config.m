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
    
    [orb(1,12), orb(1,13), orb(1,14), TO(1).orbital_period(1)] = Theta2t(PI.a,PI.e,PI.theta,orb(1,7));
    
    % change of w    %conviene utilizzare il punto B nel nostro caso e
    % utilizzare il TO(1).theta_2 nel change of plan e il TO(2).theta_2 per
    % ottenere il tempo minore possibile
    orb(3,1)=orb(2,1);
    orb(3,2)=orb(2,2);
    orb(3,3)=orb(2,3);
    orb(3,4)=orb(2,4);
    orb(3,5)=PF.om;
    [orb(3,8), orb(2,7), orb(3,6)] = Change_w(PI.a, PI.e, PI.om, PF.om,orb(2,6))
    orb(2,7)=orb(2,7)+pi;
    [orb(2,12), orb(2,13), orb(2,14), TO(2).orbital_period] = Theta2t(PI.a,PI.e,orb(2,6),orb(2,7));
    

    %change of shape
    tipe = 1;
    switch tipe
    case 1
        orb(4,6) = 0;
        orb(4,7) = pi;
    case 2
        orb(4,6) = pi;
        orb(4,7) = 0;
    case 3
        orb(4,6) = pi;
        orb(4,7) = pi;
    case 4
        orb(4,6) = 0;
        orb(4,7) = 0;  
    end

    orb(4,3)=orb(3,3);
    orb(4,4)=orb(3,4);
    orb(4,5)=orb(3,5);
    [orb(4,8), orb(4,9), orb(4,10), orb(4,1), orb(4,2)] = Bitangent_Transfer(tipe, PI.e, PI.a, PF.e, PF.a);
    [TO(3).delta_time(1), TO(3).t_1, TO(3).t_2, TO(3).orbital_period] = tempi(PI.a,PI.e,TO(2).theta_2,TO(3).theta_1);
    [TO(3).delta_time(2), TO(3).t_1, TO(3).t_2, TO(3).orbital_period] = tempi(TO(3).a_2,TO(3).e_2,TO(3).theta_1,TO(3).theta_2);


