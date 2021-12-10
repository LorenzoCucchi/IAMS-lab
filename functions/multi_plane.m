close all
clear all
load("dataA24.mat")
r_aT=13460.414;

orb(1,1)=PI.a;
    orb(1,2)=PI.e;
    orb(1,3)=PI.i;
    orb(1,4)=PI.OM;
    orb(1,5)=PI.om;
    orb(1,6)=PI.theta;

   delta_i = (PF.i-orb(1,3))/3;
   delta_OM = (PF.OM-orb(1,4))/3;
    
   orb(2,:)=orb(1,:);
   orb(2,9)=0;
    orb(2,10)=0;
    orb(2,11)=0;
    orb(2,4)=orb(1,4)+delta_OM;
    orb(2,3)=orb(1,3)+delta_i;
    [orb(2,8),orb(1,7),orb(2,5)] = change_plane(orb(1,1),orb(1,2),orb(1,3),orb(1,4),orb(1,5),orb(2,3),orb(2,4),398600.44,1);
    orb(1,7)=orb(1,7);
    orb(2,6)=orb(1,7); 
    
    % bitangent transfer 
    orb(3,:)=orb(2,:);
    orb(3,5)=orb(3,5)+pi;
    orb(3,6)=0;
    orb(2,7)=pi;
    orb(3,7)=pi;
    orb(5,:)=orb(2,:);
    orb(5,3)=orb(3,3)+delta_i;
    orb(5,4)=orb(3,4)+delta_OM;
    orb(5,5)=orb(3,5);
    orb(5,6)=pi;
    orb(5,7)=0;
    orb(5,8)=0;
    [ orb(3,8), orb(3,9), orb(3,10), orb(3,11), orb(3,1), orb(5,1), orb(3,2), orb(5,2)] = biellBitang (PI.a ,PI.e , PF.a , PF.e , r_aT ,398600.44);
%     
% 
    [orb(1,13), orb(1,13), orb(1,14), orb(1,15)] = Theta2t(orb(1,1), orb(1,3),orb(1,6),orb(1,7));
    [orb(3,13), orb(3,13), orb(3,14), orb(3,15)] = Theta2t(orb(3,1),orb(3,3),orb(3,6),orb(3,7));
%     
%     
% %     
% %     
% %


    orb(4,:)=orb(3,:);
    orb(4,9)=0;
    orb(4,10)=0;
    orb(4,11)=0;
    orb(4,4)=orb(4,4)+delta_OM;
    orb(4,3)=orb(4,3)+delta_i;
    [orb(4,8),orb(3,7),orb(4,5)] = change_plane(orb(3,1),orb(3,2),orb(3,3),orb(3,4),orb(3,5),orb(4,3),orb(4,4),398600.44,0);
    orb(5,5)=orb(4,5);
    orb(3,7)=orb(3,7);
    orb(4,6)=orb(3,7);


    orb(6,:)=orb(5,:);
    orb(6,9)=0;
    orb(6,10)=0;
    orb(6,11)=0;
    orb(6,4)=PF.OM;
    orb(6,3)=PF.i;
    [orb(6,8),orb(5,7),orb(6,5)] = change_plane(orb(5,1),orb(5,2),orb(5,3),orb(5,4),orb(5,5),orb(6,3),orb(6,4),398600.44,1);
    %orb(6,5)=orb(5,5);
    orb(5,7)=orb(5,7);
    orb(6,6)=orb(5,7);
%     [orb(3,12), orb(3,13), orb(3,14), orb(3,15)] = Theta2t(orb(3,1),orb(3,2),orb(3,6),orb(3,7));
%     orb(4,5)=orb(3,5);
% 
    if(abs(PF.om-orb(6,5))>(pi/2))
        orb(7,5)=PF.om+pi;
    else
        orb(7,5)=PF.om;
    end
%     
%     
%       
%     % change of w    %conviene utilizzare il punto B nel nostro caso e
%     % utilizzare il TO(1).theta_2 nel change of plan e il TO(2).theta_2 per
%     % ottenere il tempo minore possibile
    orb(7,1)=orb(6,1);
    orb(7,2)=orb(6,2);
    orb(7,3)=orb(6,3);
    orb(7,4)=orb(6,4);
    orb(7,7)=0;
    [orb(7,8), orb(6,7), orb(7,6)] = Change_w(orb(7,1), orb(7,2), orb(6,5), orb(7,5),orb(6,6));
    
    
    
%     
%     [orb(4,12), orb(4,13), orb(4,14), orb(4,15)] = Theta2t(orb(4,1),orb(4,2),orb(4,6),orb(4,7));
%     [orb(5,12), orb(5,13), orb(5,14), orb(5,15)] = Theta2t(orb(5,1),orb(5,2),orb(5,6),orb(5,7));
% 
% 
% % arrival at final point
    orb(8,1)=PF.a;
    orb(8,2)=PF.e;
    orb(8,3)=PF.i;
    orb(8,4)=PF.OM;
    orb(8,5)=PF.om;
    orb(8,6)=0;
    orb(8,7)=PF.theta;
%     [orb(8,12), orb(8,13), orb(8,14), orb(8,15)] = Theta2t(orb(8,1),orb(8,2),orb(8,6),orb(8,7));

    plotOrbit(orb,0.01)

    results = orb;
    results(9,8)=sum(orb(:,8));   
    results(9,12)=sum(orb(:,12));
    seconds(results(9,12))

      r = results_csv(results);
