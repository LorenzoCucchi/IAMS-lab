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
mu=398600;


DV_mat = [];
r_p_f = a_f*(1-e_f);
dr_aT_vec = 1;
r_aT_vec = [r_p_f:dr_aT_vec:50000];

for r_aT = r_aT_vec(1):dr_aT_vec:r_aT_vec(end)

% **********************


% PLANE CHANGE
[ DeltaV_plane , th_PC ,om_2] = change_plane (a_i , e_i ,i_i , OM_i , om_i , i_f , OM_f , mu);

% PERIAPSIS ARGUMENT CHANGE
if(abs(om_f-om_2)>(pi/2))
    om_3=om_f+pi;
    tipe = 3;
else
    om_3=om_f;
    tipe =2;
end

[ DeltaV_periArg , th_peri_i , th_peri_f ] =Change_w (a_i , e_i , om_2 , om_3 , th_PC);

% BIELLIPTIC TRANSFER
[ DeltaV_biell , DeltaV1 , DeltaV2 , DeltaV3 , a_T1 , a_T2 , e_T1, e_T2 ] = biellBitang (a_i , e_i , a_f , e_f , r_aT , mu);


DeltaV_vec = [ DeltaV_plane DeltaV_periArg DeltaV1 DeltaV2 DeltaV3]' ;


DV_mat = [ DV_mat DeltaV_vec ];
% **********************
end


DVNormalizer = sum ( DV_mat (: ,1) ,1);
plot ( r_aT_vec , sum ( DV_mat ,1) / DVNormalizer ,'r','LineWidth', 1);
grid on
hold on
[ DeltaV_TOT , k] = min( sum (DV_mat ,1)); % least sum ofcolumns = deltaVs_for_each_maneuver
plot ( r_aT_vec (k), DeltaV_TOT / DVNormalizer , 'dr', 'MarkerSize', 8)

DV_mat_max = max ( DV_mat (3: end ,:));

DVNormalizer = DV_mat_max (1);
plot ( r_aT_vec , DV_mat_max / DVNormalizer ,'b','LineWidth',1);

[ DeltaV_TOT , k] = min( DV_mat_max );
DeltaV_vec = DV_mat (:,k);
r_aT = r_aT_vec (k)
DV_mat_max = max ( DV_mat (3: end ,k));

plot ( r_aT_vec (k), DV_mat_max / DVNormalizer , 'db','MarkerSize', 8)
legend ('Normalized  Deltav_ {tot }( r_{a,t}) ', ' Deltav_ {tot } opt.', 'Normalized max ( Deltav_3 ,  Deltav_4 , Deltav_5 )', 'max ( Deltav_3 ,  Deltav_4 ,  Deltav_5 )opt .', 'Location ', 'northwest')
xlabel ('r_{a,t} [km]')
ylabel ('Normalized  Deltav')


hold off


%% change of plan,w,biell
    
    orb(1,1)=PI.a;
    orb(1,2)=PI.e;
    orb(1,3)=PI.i;
    orb(1,4)=PI.OM;
    orb(1,5)=PI.om;
    orb(1,6)=PI.theta;

   
    
    
    orb(2,:)=orb(1,:);
    orb(2,4)=PF.OM;
    orb(2,3)=PF.i;
    [orb(2,8),orb(1,7),orb(2,5)] = change_plane(orb(1,1),orb(1,2),orb(1,3),orb(1,4),orb(1,5),orb(2,3),orb(2,4));
    orb(2,6)=orb(1,7);
    
    [orb(1,12), orb(1,13), orb(1,14), orb(1,15)] = Theta2t(orb(1,1),orb(1,2),orb(1,6),orb(1,7));

    if(abs(om_f-om_2)>(pi/2))
        orb(3,5)=PF.om+pi;
    else
        orb(3,5)=PF.om
    end
    
    
      
    % change of w    %conviene utilizzare il punto B nel nostro caso e
    % utilizzare il TO(1).theta_2 nel change of plan e il TO(2).theta_2 per
    % ottenere il tempo minore possibile
    orb(3,1)=orb(2,1);
    orb(3,2)=orb(2,2);
    orb(3,3)=orb(2,3);
    orb(3,4)=orb(2,4);
    [orb(3,8), orb(2,7), orb(3,6)] = Change_w(orb(3,1), orb(3,2), orb(2,5), orb(3,5),orb(2,6));
    
    [orb(2,12), orb(2,13), orb(2,14), orb(2,15)] = Theta2t(orb(2,1), orb(2,2),orb(2,6),orb(2,7));
    
    
    
    % bitangent transfer 
    orb(4,:)=orb(3,:);
    orb(4,5)=orb(4,5)+pi;
    orb(4,6)=0;
    orb(3,7)=pi;
    orb(4,7)=pi;
    orb(5,:)=orb(3,:);
    orb(5,5)=orb(5,5)+pi;
    orb(5,6)=pi;
    orb(5,7)=0;
    orb(5,8)=0;
    [ orb(4,8), orb(4,9), orb(4,10), orb(4,11), orb(4,1), orb(5,1), orb(4,2), orb(5,2)] = biellBitang (PI.a ,PI.e , PF.a , PF.e , r_aT , mu);
    

    [orb(3,12), orb(3,13), orb(3,14), orb(3,15)] = Theta2t(orb(3,1), orb(3,2),orb(3,6),orb(3,7));
    [orb(4,12), orb(4,13), orb(4,14), orb(4,15)] = Theta2t(orb(4,1),orb(4,2),orb(4,6),orb(4,7));
    [orb(5,12), orb(5,13), orb(5,14), orb(5,15)] = Theta2t(orb(5,1),orb(5,2),orb(5,6),orb(5,7));
    
%     
%     
%     % arrival at final point
    orb(6,1)=PF.a;
    orb(6,2)=PF.e;
    orb(6,3)=PF.i;
    orb(6,4)=PF.OM;
    orb(6,5)=PF.om;
    orb(6,6)=0;
    orb(6,7)=PF.theta;
    [orb(6,12), orb(6,13), orb(6,14), orb(6,15)] = Theta2t(orb(6,1),orb(6,2),orb(6,6),orb(6,7));

    plotOrbit(orb,0.1)

    results = orb;
    results(7,8)=sum(orb(:,8));   
    results(7,12)=sum(orb(:,12));
    seconds(results(7,12))
