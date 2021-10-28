close all
clear all
clc


load('dataA24.mat')



%% change of plan,w,shape 

    % change of plan
    [TO(1).delta_V,TO(1).theta_1,TO(1).om_f] = change_plane(PI.a,PI.e,PI.i,PI.OM,PI.om,PF.i,PF.OM);
    [TO(1).delta_time(1), TO(1).t_1(1), TO(1).t_2(1), TO(1).orbital_period(1)] = tempi(PI.a,PI.e,PI.theta,TO(1).theta_1);
    
    % change of w    %conviene utilizzare il punto B nel nostro caso e
    % utilizzare il TO(1).theta_2 nel change of plan e il TO(2).theta_2 per
    % ottenere il tempo minore possibile
    [TO(2).delta_V, TO(2).theta_1, TO(2).theta_2] = change_w(PI.a, PI.e, PI.om, PF.om);
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


