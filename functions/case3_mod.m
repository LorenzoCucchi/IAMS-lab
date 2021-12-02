close all
clear all
clc


%%
% orbit matrix [1,2,3, 4, 5,  6,  7,    8,  9, 10, 11, 12, 13, 14, 15]
% orbit matrix [a,e,i,OM,om,th1,th2,dVtot,dV1,dV2,dV3, dT, t1, t2, T ]

load('dataA24.mat')



%% change of e,plan,w,bitan

    orb(1,1)=PI.a;
    orb(1,2)=PI.e;
    orb(1,3)=PI.i;
    orb(1,4)=PI.OM;
    orb(1,5)=PI.om;
    orb(1,6)=PI.theta;

    % aux
    orb(2,:)=orb(1,:);
    orb(2,2)=0.0976433;
    [orb(2,9),orb(2,5) , orb(1,7), orb(2,1)] = ChangeOrbitShape (orb(1,1), orb(1,2), orb(1,3), orb(1,4), orb(1,5), orb(1,3) , orb(1,4) , orb(2,2));
    orb(2,6)=0;   
    orb(1,7)=PI.theta+0.01;
    
    
    
    orb(3,:)=orb(2,:);
    orb(3,4)=PF.OM;
    orb(3,3)=PF.i;
    [~,orb(2,7),orb(3,5)] = change_plane(orb(2,1),orb(2,2),orb(2,3),orb(2,4),orb(2,5),PF.i,PF.OM);
    orb(3,6)=orb(2,7);
    orb(3,9)=0;
    

    % direct
    [orb(2,9), orb(2,10), orb(2,1), orb(2,2), orb(2,3), orb(2,4), orb(2,6), orb(2,7)] = directTransfer(orb(1,1), orb(1,2), orb(1,3), orb(1,4), orb(1,5), PI.theta,    0,   orb(3,1), orb(3,2), orb(3,3), orb(3,4), orb(3,5), orb(3,6));
  
    % 1,2,3 times
    [orb(1,12), orb(1,13), orb(1,14), orb(1,15)] = Theta2t(PI.a,PI.e,PI.theta,orb(1,7));
    [orb(2,12), orb(2,13), orb(2,14), orb(2,15)] = Theta2t(orb(2,1),orb(2,2),orb(2,6),orb(2,7));
    [orb(3,12), orb(3,13), orb(3,14), orb(3,15)] = Theta2t(orb(3,1),orb(3,2),orb(3,6),orb(3,7));


    % change of w    %conviene utilizzare il punto B nel nostro caso e
    % utilizzare il TO(1).theta_2 nel change of plan e il TO(2).theta_2 per
    % ottenere il tempo minore possibile
    orb(4,1)=orb(3,1);
    orb(4,2)=orb(3,2);
    orb(4,3)=orb(3,3);
    PF.om-orb(3,5)
    orb(4,4)=orb(3,4);
    orb(4,5)=PF.om+pi;
    [orb(4,9), orb(3,7), orb(4,6)] = Change_w(orb(4,1), orb(4,2), orb(3,5), orb(4,5),orb(3,6));
    
    [orb(3,12), orb(3,13), orb(3,14), orb(3,15)] = Theta2t(orb(3,1), orb(3,2),orb(3,6),orb(3,7));
    
    
    % bitangent transfer 
    orb(5,3)=orb(4,3);
    orb(5,4)=orb(4,4);
    orb(5,5)=orb(4,5);
    orb(5,6)=pi;
    orb(4,7)=pi;
    [orb(5,8), orb(5,9), orb(5,10), orb(5,1), orb(5,2)] = Bitangent_Transfer(3, orb(4,2), orb(4,1), PF.e, PF.a);
    orb(5,7)=pi+PF.theta;
    [orb(4,12), orb(4,13), orb(4,14), orb(4,15)] = Theta2t(orb(4,1),orb(4,2),orb(4,6),orb(4,7));
    
%     
%     % arrival at final point
    orb(6,1)=PF.a;
    orb(6,2)=PF.e;
    orb(6,3)=PF.i;
    orb(6,4)=PF.OM;
    orb(6,5)=PF.om;
    orb(6,6)=0;
    orb(6,7)=PF.theta;
     [orb(5,12), orb(5,13), orb(5,14), orb(5,15)] = Theta2t(orb(5,1),orb(5,2),orb(5,6),orb(5,7));

    % dV sum
    orb(:,8) = orb(:,9) + orb(:,10) + orb(:,11);
    
    plotOrbit(orb,0.01)

    results = orb;
    results(7,8)=sum(orb(:,8));   
    results(7,12)=sum(orb(:,12));
    minutes(seconds(results(7,12)))
   