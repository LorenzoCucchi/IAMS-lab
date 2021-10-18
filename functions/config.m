close all
clear all
clc


load('dataA24.mat')



%% change of plan,w,shape 

    [TO(1).delta_V,TO(1).delta_V2,TO(1).theta_1,TO(1).theta_2,TO(1).om_f,TO(1).alpha,TO(1).u_1,TO(1).u_2] = change_plane(PI.a,PI.e,PI.i,PI.OM,PI.om,PF.i,PF.OM);
    [TO(1).delta_time, TO(1).t_1, TO(1).t_2, TO(1).orbital_period] = tempi(PI.a,PI.e,PI.theta,TO(1).theta_2);
    [TO(2).delta_V, TO(2).theta_1, TO(2).theta_2] = change_w(PI.a, PI.e, PI.om, PF.om);
    [TO(2).delta_time, TO(2).t_1, TO(2).t_2, TO(2).orbital_period] = tempi(PI.a,PI.e,TO(1).theta_2,TO(2).theta_2);
    tipe = 1;
    [TO(3).delta_V, TO(3).dv_1, TO(3).dv_2, TO(3).a_2, TO(3).e_2] = biell(tipe, PI.e, PI.a, PF.e, PF.a);

    

