close all
clear all

set (0, 'defaultTextInterpreter', 'tex' )
set (0, 'DefaultAxesFontSize', 12)

mu = 398600.44; %[km ^3/ s ^2]
dth = pi /180; % True anomaly step size [rad ]
speed = 3000; % time multiplier for simulating the dynamics

load('dataA24.mat')

global tLast ;
global globe ;
global myMovie ;
global myFig ;
global captureMovie ;
global createPDF ;
global playAfterCapture ;
global fps;
global timeBox ;
global plotActive ;
global maneuvCount ;
global legendInf ;
global legendObjs ;
global generate3DPDF ;

tLast = 0;
myMovie = struct ('cdata' ,[],'colormap' ,[]);

captureMovie = 0;
createPDF = 1;
playAfterCapture = 0;
fps = 24;
plotActive = 1;
if (~ plotActive )
createPDF = 0;
end
generate3DPDF = 0;

g = 34 % Group number

% force short theta step size , otherwise we would obtain irregular time steps
if captureMovie
dth = 0.1* pi /180
end

%% PARKING AND TARGET ORBIT CHARACTERIZATION

% DATA_g = DATA (g ,:)'
% 
% R0 = DATA_g (1:3) ;
% V0 = DATA_g (4:6) ;

% ***************************************************
R0 = 10^3*[ -348.33555 -3161.2989 7933.7446]';
V0 = [6.1950 -3.3790 -0.2517]';
% ***************************************************

% initial orbit
[a_i , e_i , i_i , OM_i , om_i , th_i ] = car2par (R0 ,V0 ,mu);
p_i = a_i *(1 - e_i ^2) ;
T_i = 2* pi* sqrt ( a_i ^3/ mu);
T_i = sec2HM (T_i )
r_i = norm (R0);
v_i = norm (V0);
eps_i = 1/2* v_i ^2- mu/r_i;

% final orbit
a_f = DATA_g (7); e_f = DATA_g (8); i_f = DATA_g (9);
OM_f = DATA_g (10) ; om_f = DATA_g (11) ; th_f = DATA_g (12);


% ***************************************************
% a_f = 33940; e_f = 0.165200; i_f = 3.028000;
% OM_f = 1.977000; om_f = 2.934000; th_f = 0.985900;
% ***************************************************

[RF ,VF] = par2car (a_f ,e_f ,i_f ,OM_f ,om_f ,th_f , mu);

T_f = 2* pi * sqrt (a_f ^3/ mu);
T_f = sec2HM (T_f )
r_f = norm (RF);
v_f = norm (VF);
eps_f = 1/2* v_f ^2- mu/r_f;
p_f = a_f *(1 - e_f ^2) ;

plotEarth (OM_i , OM_f )
rotate (globe ,[0 0 1] ,190 ,[0 0 0]);
plotOrbit (a_i , e_i , i_i , OM_i , om_i , th_i , th_i +2* pi , dth , 'stat ', 0, speed , mu , 'Initial Point ');
plotOrbit (a_f , e_f , i_f , OM_f , om_f , th_f , th_f +2* pi , dth , 'stat ', 0, speed , mu , 'Final Point ');

 % considerations about ratio of the average radius (BIELLIPTIC )

r_a_i = a_i *(1+ e_i);
r_p_i = a_i *(1 - e_i);
r_a_f = a_f *(1+ e_f);
r_p_f = a_f *(1 - e_f);

r_av_i = ( r_a_i + r_p_i )/2;
r_av_f = ( r_a_f + r_p_f )/2;
radAvRatio = r_av_f / r_av_i

%% GROUND TRACK ( TARGET ORBIT )
nOrb = 42; % number of orbits []
dt = 250; % timestep [s]

if plotActive
greenwich0 = 66.433; % [deg ]
plotGroundTrack (nOrb , dt , a_f ,e_f ,i_f ,OM_f ,om_f ,th_f ,greenwich0 , mu)

resizePDFPaper
print (myFig , " groundTrack_target ", '-dpdf ')
end

pause (1)
% clf
% run(' earth / plotBetterEarth .m ')
% plotOrbit (a, e, i, OM , om , th0 , thf , dth , 0, 0, speed ,mu)
% set(gcf ,  Units ', 'Normalized ', 'OuterPosition ', [0 0 1 1]) ;
% type (' earth / README .txt ');

%
% pause (0.5)
%
%
%
% orbElements = DATA_g (7:12)
%
% th0 = orbElements (6) ;
% thf = th0 + 2* pi;
% plotOrbit ( orbElements (1) , orbElements (2) , orbElements(3) , orbElements (4) , orbElements (5) , th0 , thf , dth , mu)
%
% pause (1)

%% STRATEGY 1.a: PLANE + PERIAPSIS + SHAPE : Bitangent (P1 ->A2)

strategyName = sprintf ('C% d_strategy_1_a ', g)

% PLANE CHANGE
[ DeltaV_plane , om_1 , th_PC ] = changeOrbitalPlane (a_i , e_i ,i_i , OM_i , om_i , i_f , OM_f , mu);

% PERIAPSIS ARGUMENT CHANGE

[ DeltaV_periArg , th_peri_i , th_peri_f ] = changePericenterArg (a_i , e_i , om_1 , om_f , mu);

% Let us chose the nearest point for performing the PeriArg
Change maneuver
% ( there is no difference in terms of DeltaV --> we will choose the first point we encounter )

[ th_peri_i , th_peri_f ] = choosePeriChangeAngle ( th_peri_i ,th_peri_f , th_PC );

% SHAPE CHANGE ( Bitangent transfer )
[ DeltaV_bitg1 , DeltaV_bitg2 , DeltaV_bitg , Deltat , a_t , e_t ,periApoInvTrue ] = bitangentTransfer (a_i , e_i , a_f , e_f , 'PA ', mu);

% DELTA V
DeltaV_vec = [ DeltaV_plane DeltaV_periArg DeltaV_bitg1 DeltaV_bitg2 ] 
DeltaV_TOT = sum ( DeltaV_vec )

% TRANSFER TIME
t1 = orbitPathTime (a_i ,e_i ,mu ,th_i , th_PC );
t2 = orbitPathTime (a_i ,e_i ,mu ,th_PC , th_peri_i );
t3 = orbitPathTime (a_i ,e_i ,mu , th_peri_f ,2* pi);
t4 = orbitPathTime (a_t ,e_t ,mu ,0, pi);
t5 = orbitPathTime (a_f ,e_f ,mu ,pi , th_f );
Deltat = t1 + t2 + t3 + t4 + t5
sec2HM ( Deltat )
Deltat_vec = [t1 t2 t3 t4 t5]'

% PLOT

plotEarth (OM_i , OM_f )
view ([104 ,21])
plotOrbit (a_i , e_i , i_i , OM_i , om_i , 0, 2*pi , dth , '--',0, speed , mu);
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, 2*pi , dth , '--',0, speed , mu);
plotOrbit (a_i , e_i , i_i , OM_i , om_i , th_i , th_PC , dth , 'dyn ',0, speed , mu , 'Initial Point ');
plotOrbit (a_i , e_i , i_f , OM_f , om_1 , th_PC , th_peri_i , dth , 'dyn ', 0, speed , mu , 'Plane Change ');
plotOrbit (a_i , e_i , i_f , OM_f , om_f , th_peri_f , 2*pi , dth , 'dyn ', 0, speed , mu , 'Periapsis Change ');
plotOrbit (a_t , e_t , i_f , OM_f , om_f , 0, pi , dth , 'dyn ', 0,speed , mu , 'Bitangent (P)');
plotOrbit (a_f , e_f , i_f , OM_f , om_f , pi , th_f , dth , 'dyn ', 1,speed , mu , 'Bitangent (A)');

writeMovieAndPDF ( strategyName )
writeCSVData ( strategyName , DeltaV_vec , Deltat_vec )


%% STRATEGY 1.b: PLANE + PERIAPSIS + SHAPE : Bitangent (A1 ->P2)

strategyName = sprintf ('C% d_strategy_1_b ', g)

plotEarth (OM_i , OM_f )
% set (gcf , 'Units ', 'Normalized ', 'OuterPosition ', [0 0 1 1]);

plotOrbit (a_i , e_i , i_i , OM_i , om_i , 0, 2*pi , dth , '--',0, speed , mu);
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, 2*pi , dth , '--',0, speed , mu);


% PLANE CHANGE
[ DeltaV_plane , om_1 , th_PC ] = changeOrbitalPlane (a_i , e_i ,i_i , OM_i , om_i , i_f , OM_f , mu);

% PERIAPSIS ARGUMENT CHANGE
[ DeltaV_periArg , th_peri_i , th_peri_f ] = changePericenterArg (a_i , e_i , om_1 , om_f , mu);

% Nearest Peri - change angle
[ th_peri_i , th_peri_f ] = choosePeriChangeAngle ( th_peri_i ,th_peri_f , th_PC );


% SHAPE CHANGE ( Bitangent transfer )
[ DeltaV_bitg1 , DeltaV_bitg2 , DeltaV_bitg , Deltat , a_t , e_t ,periApoInvTrue ] = bitangentTransfer (a_i , e_i , a_f , e_f , 'AP ', mu);

% DELTA V

DeltaV_vec = [ DeltaV_plane DeltaV_periArg DeltaV_bitg1 DeltaV_bitg2 ] 
DeltaV_TOT = sum ( DeltaV_vec )


% TRANSFER TIME
t1 = orbitPathTime (a_i ,e_i ,mu ,th_i , th_PC );
t2 = orbitPathTime (a_i ,e_i ,mu ,th_PC , th_peri_i );
t3 = orbitPathTime (a_i ,e_i ,mu , th_peri_f ,pi);
t4 = orbitPathTime (a_t ,e_t ,mu ,pi -pi* periApoInvTrue , 0 -pi* periApoInvTrue );
t5 = orbitPathTime (a_f ,e_f ,mu ,0, th_f );
Deltat = t1 + t2 + t3 + t4 + t5
sec2HM ( Deltat )
Deltat_vec = [t1 t2 t3 t4 t5]'


% PLOT
plotOrbit (a_i , e_i , i_i , OM_i , om_i , th_i , th_PC , dth , 'dyn ',0, speed , mu , 'Initial Point ');
plotOrbit (a_i , e_i , i_f , OM_f , om_1 , th_PC , th_peri_i , dth , 'dyn ', 0, speed , mu , 'Plane Change ');
plotOrbit (a_i , e_i , i_f , OM_f , om_f , th_peri_f , pi , dth , 'dyn', 0, speed , mu , 'Periapsis Change ');
plotOrbit (a_t , e_t , i_f , OM_f , om_f +pi* periApoInvTrue , pi -pi* periApoInvTrue ,2* pi -pi* periApoInvTrue , dth, 'dyn ', 0, speed , mu ,'Bitangent (A)');
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, th_f , dth , 'dyn ', 1,speed , mu , 'Bitangent (P)');


writeMovieAndPDF ( strategyName )
writeCSVData ( strategyName , DeltaV_vec , Deltat_vec )



%% STRATEGY 2: PLANE + PERIAPSIS + SHAPE :+ Biell .- Bitang .


DV_mat = [];
strategyName = sprintf ('C% d_strategy_2 ', g);

r_p_f = a_f *(1 - e_f);
dr_aT_vec = 1;
r_aT_vec = [ r_p_f : dr_aT_vec :32000];

for r_aT = r_aT_vec (1) : dr_aT_vec : r_aT_vec (end)

    % PLANE CHANGE
    [ DeltaV_plane , om_1 , th_PC ] = changeOrbitalPlane (a_i , e_i, i_i , OM_i , om_i , i_f , OM_f , mu);
     
    
    % PERIAPSIS ARGUMENT CHANGE
    [ DeltaV_periArg , th_peri_i , th_peri_f ] = changePericenterArg (a_i , e_i , om_1 , om_f , mu);
    
    % Nearest Peri - change angle
    [ th_peri_i , th_peri_f ] = choosePeriChangeAngle ( th_peri_i ,th_peri_f , th_PC );
    
    
    % SHAPE CHANGE ( Bielliptic - Bitangent transfer )
    [ DeltaV_biellBitg , DeltaV_biellBitg1 , DeltaV_biellBitg2 ,DeltaV_biellBitg3 , a_T1 , a_T2 , e_T1 , e_T2 ] = biellBitang (a_i , e_i , a_f , e_f , r_aT , mu);
    
    % DELTA V
    DeltaV_vec = [ DeltaV_plane DeltaV_periArg
    DeltaV_biellBitg1 DeltaV_biellBitg2 DeltaV_biellBitg3]';
    
    
    DV_mat = [ DV_mat DeltaV_vec ];

end


% Lowest Total - Impulse constraint optimization :

% the optimum is found to be a Degenerate - Bielliptic = Bitangent

% ( since the average - radius ratio between final and initial orbits is << 15.58)
% in other words , bielliptic transfer is optimal

if plotActive
    myFig = figure ;
    DVNormalizer = sum ( DV_mat (: ,1) ,1);
    plot ( r_aT_vec , sum ( DV_mat ,1) / DVNormalizer , 'r', 'LineWidth ', 1);
    grid on
    hold on
    [ DeltaV_TOT , k] = min( sum (DV_mat ,1)); % least sum of columns = deltaVs_for_each_maneuver
    plot ( r_aT_vec (k), DeltaV_TOT / DVNormalizer , 'dr ', 'MarkerSize ', 8)
end


% Lowest Bitangent - Impulse Constraint optimization
% Let us search for the r_aT corresponding to the lowest maximum impulse
% ( apart from the PlaneChange and PeriChange impulses , i.e.
DV_mat (1 ,:) , which is always the biggest one )
DV_mat_max = max ( DV_mat (3: end ,:));
if plotActive
    DVNormalizer = DV_mat_max (1);
    plot ( r_aT_vec , DV_mat_max / DVNormalizer , 'b', 'LineWidth ',1);
end

[ DeltaV_TOT , k] = min( DV_mat_max ); % least sum of columns = deltaVs_for_each_maneuver
DeltaV_vec = DV_mat (:,k);
r_aT = r_aT_vec (k)
DV_mat_max = max ( DV_mat (3: end ,k));
if plotActive
    plot ( r_aT_vec (k), DV_mat_max / DVNormalizer , 'db ', 'MarkerSize ', 8)
    legend ('Normalized \ Deltav_ {tot }( r_{a,t}) ', '\ Deltav_ {tot } opt.', 'Normalized max (\ Deltav_3 , \ Deltav_4 ,\ Deltav_5 )', 'max (\ Deltav_3 , \ Deltav_4 , \ Deltav_5 ) opt .', 'Location ', 'northwest ')
    xlabel ('r_{a,t} [km]')
    ylabel ('Normalized \ Deltav ')
    
    resizePDFPaper
    print (myFig , " biellBitangOptAndComparison ", '-dpdf ')

end


% **********************
% PLANE CHANGE
[ DeltaV_plane , om_1 , th_PC ] = changeOrbitalPlane (a_i , e_i, i_i , OM_i , om_i , i_f , OM_f , mu);
% PERIAPSIS ARGUMENT CHANGE
[ DeltaV_periArg , th_peri_i , th_peri_f ] = changePericenterArg (a_i , e_i , om_1 , om_f , mu);
% Nearest Peri - change angle
[ th_peri_i , th_peri_f ] = choosePeriChangeAngle ( th_peri_i ,th_peri_f , th_PC );
% SHAPE CHANGE ( Bielliptic - Bitangent transfer )
[ DeltaV_biellBitg , DeltaV_biellBitg1 , DeltaV_biellBitg2 ,DeltaV_biellBitg3 , a_T1 , a_T2 , e_T1 , e_T2 ] = biellBitang (a_i , e_i , a_f , e_f , r_aT , mu);
% DELTA V
DeltaV_vec = [ DeltaV_plane DeltaV_periArg DeltaV_biellBitg1 DeltaV_biellBitg2 DeltaV_biellBitg3]';

% **********************

% TRANSFER TIME
t1 = orbitPathTime (a_i ,e_i ,mu ,th_i , th_PC );
t2 = orbitPathTime (a_i ,e_i ,mu ,th_PC , th_peri_i );
t3 = orbitPathTime (a_i ,e_i ,mu , th_peri_f ,2* pi);
t4 = orbitPathTime (a_T1 ,e_T1 ,mu ,0, pi);
t5 = orbitPathTime (a_T2 ,e_T2 ,mu ,pi ,2* pi);
t6 = orbitPathTime (a_f ,e_f ,mu ,0, th_f );
Deltat = t1 + t2 + t3 + t4 + t5 + t6
sec2HM ( Deltat )
Deltat_vec = [t1 t2 t3 t4 t5 t6]'

% PLOT
plotEarth (OM_i , OM_f )
plotOrbit (a_i , e_i , i_i , OM_i , om_i , 0, 2*pi , dth , '--',0, speed , mu);
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, 2*pi , dth , '--',0, speed , mu);

plotOrbit (a_i , e_i , i_i , OM_i , om_i , th_i , th_PC , dth , 'dyn ',0, speed , mu , 'Initial Point ');

plotOrbit (a_i , e_i , i_f , OM_f , om_1 , th_PC , th_peri_i , dth , 'dyn ', 0, speed , mu , 'Plane Change ');
plotOrbit (a_i , e_i , i_f , OM_f , om_f , th_peri_f , 2*pi , dth , 'dyn ', 0, speed , mu , 'Periapsis Change ');

plotOrbit (a_T1 , e_T1 , i_f , OM_f , om_f , 0, pi , dth , 'dyn ', 0,speed , mu , 'Bielliptic - Bitangent (1 st semi -orbit starts )');
plotOrbit (a_T2 , e_T2 , i_f , OM_f , om_f , pi , 2*pi , dth , 'dyn ',0, speed , mu , 'Bielliptic - Bitangent (2 nd semi -orbit starts )');
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, th_f , dth , 'dyn ', 1,speed , mu , 'Bielliptic - Bitangent (2 nd semi -orbit ends )');

writeMovieAndPDF ( strategyName )
writeCSVData ( strategyName , DeltaV_vec , Deltat_vec )


%% STRATEGY 3.a: ECCENTRICITY + PLANE + PERIAPSIS + Bitangent (P1 ->A2)

strategyName = sprintf ('C% d_strategy_3_a ', g)

DV_mat = [];
de = .01;
e_vect = [e_i:de :0.9];

for e_1 = e_vect (1) :de: e_vect (end )
    % **********************
    % DIMENSION CHANGE
    [ DeltaV_ecc , om_1 , th_1 , a_1] = changeOrbitShape (a_i , e_i, i_i , OM_i , om_i , i_f , OM_f , e_1 , mu);
    
    % PLANE CHANGE
    [ DeltaV_plane , om_2 , th_PC ] = changeOrbitalPlane (a_1 , e_1 ,i_i , OM_i , om_1 , i_f , OM_f , mu);
    
    % PERIAPSIS ARGUMENT CHANGE
    [ DeltaV_periArg , th_peri_i , th_peri_f ] = changePericenterArg (a_1 , e_1 , om_2 , om_f , mu);
    
    % Nearest Peri - change angle
    
    [ th_peri_i , th_peri_f ] = choosePeriChangeAngle ( th_peri_i ,th_peri_f , th_PC );
    
    % BITANGENT TRANSFER
    
    [ DeltaV_bitg1 , DeltaV_bitg2 , DeltaV_bitg , Deltat , a_t ,e_t , periApoInvTrue ] = bitangentTransfer (a_1 , e_1 , a_f, e_f , 'PA ', mu);
    
    DeltaV_vec = [ DeltaV_ecc DeltaV_plane DeltaV_periArg DeltaV_bitg1 DeltaV_bitg2 ] ;
    
    DV_mat = [ DV_mat DeltaV_vec ];
    
    % **********************
end

[ DeltaV_TOT , k] = min( sum (DV_mat ,1)) % least sum of columns = deltaVs_for_each_maneuver
DeltaV_vec = DV_mat (:,k)
e_1 = e_vect (k)

if plotActive
myFig = figure ;
plot (e_vect , sum( DV_mat ,1) , 'b', 'LineWidth ', 1);
grid on
hold on
plot ( e_vect (k), min (sum( DV_mat ,1) ), 'db ', 'MarkerSize ',8);
xlabel ('e [-] ')
ylabel ('\ Deltav [km/s]')
legend ('\ Deltav_ {tot}','e opt .')

resizePDFPaper
print (myFig , " eccentricityOptimization_3_a ", '-dpdf ')

end

% **********************
% DIMENSION CHANGE
[ DeltaV_ecc , om_1 , th_1 , a_1] = changeOrbitShape (a_i , e_i, i_i , OM_i , om_i , i_f , OM_f , e_1 , mu);
th_1 ;

% PLANE CHANGE
[ DeltaV_plane , om_2 , th_PC ] = changeOrbitalPlane (a_1 , e_1 ,i_i , OM_i , om_1 , i_f , OM_f , mu)

% PERIAPSIS ARGUMENT CHANGE
[ DeltaV_periArg , th_peri_i , th_peri_f ] = changePericenterArg (a_1 , e_1 , om_2 , om_f , mu);

% Nearest Peri - change angle
[ th_peri_i , th_peri_f ] = choosePeriChangeAngle ( th_peri_i ,th_peri_f , th_PC );

% BITANGENT TRANSFER
[ DeltaV_bitg1 , DeltaV_bitg2 , DeltaV_bitg , Deltat , a_t ,e_t , periApoInvTrue ] = bitangentTransfer (a_1 , e_1 , a_f, e_f , 'PA ', mu);

% **********************


% TRANSFER TIME
t1 = orbitPathTime (a_i , e_i ,mu , th_i , th_1 );
t2 = orbitPathTime (a_1 , e_1 ,mu , 0, th_PC ); % where th_PC = pi
t3 = orbitPathTime (a_1 , e_1 ,mu , th_PC , th_peri_i );
t4 = orbitPathTime (a_1 , e_1 ,mu , th_peri_f , 2* pi);
t5 = orbitPathTime (a_t ,e_t ,mu , 0, pi);
t6 = orbitPathTime (a_f ,e_f ,mu , pi , th_f );
Deltat = t1 + t2 + t3 + t4 + t5 + t6
sec2HM ( Deltat )
Deltat_vec = [t1 t2 t3 t4 t5 t6]'


% PLOT
plotEarth (OM_i , OM_f )
view ([104 ,38])
plotOrbit (a_i , e_i , i_i , OM_i , om_i , 0, 2*pi , dth , '--',0, speed , mu);
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, 2*pi , dth , '--',0, speed , mu);

plotOrbit (a_i , e_i , i_i , OM_i , om_i , th_i , th_1 , dth , 'dyn ',0, speed , mu , 'Initial Point ');
plotOrbit (a_1 , e_1 , i_i , OM_i , om_1 , 0, pi , dth , ' dyn ', 0, speed , mu , 'e Change');
plotOrbit (a_1 , e_1 , i_f , OM_f , om_2 , pi , th_peri_i , dth , 'dyn', 0, speed , mu , 'Plane Change ');
plotOrbit (a_1 , e_1 , i_f , OM_f , om_f , th_peri_f , 2*pi , dth , 'dyn ', 0, speed , mu , 'Periapsis Change ');

plotOrbit (a_t , e_t , i_f , OM_f , om_f , 0, pi , dth , 'dyn ', 0,speed , mu , 'Bitangent (P)');
plotOrbit (a_f , e_f , i_f , OM_f , om_f , pi , th_f , dth ,  dyn  , 1,speed , mu , 'Bitangent (A)');


writeMovieAndPDF ( strategyName )
writeCSVData ( strategyName , DeltaV_vec , Deltat_vec )



%% STRATEGY 3.b: ECCENTRICITY + PLANE + PERIAPSIS : Bitangent (A1 ->P2)

strategyName = sprintf ('C% d_strategy_3_b ', g)

DV_mat = [];
de = .01;
e_vect = [e_i:de :0.9];

for e_1 = e_vect (1) :de: e_vect (end )
    % **********************
    % DIMENSION CHANGE
    [ DeltaV_ecc , om_1 , th_1 , a_1] = changeOrbitShape (a_i , e_i, i_i , OM_i , om_i , i_f , OM_f , e_1 , mu);
    
    % PLANE CHANGE
    [ DeltaV_plane , om_2 , th_PC ] = changeOrbitalPlane (a_1 , e_1 ,i_i , OM_i , om_1 , i_f , OM_f , mu);
    
    
    % PERIAPSIS ARGUMENT CHANGE
    [ DeltaV_periArg , th_peri_i , th_peri_f ] = changePericenterArg (a_1 , e_1 , om_2 , om_f , mu);
    
    % Nearest Peri - change angle
    [ th_peri_i , th_peri_f ] = choosePeriChangeAngle ( th_peri_i ,th_peri_f , th_PC );
    
    
    % BITANGENT TRANSFER
    [ DeltaV_bitg1 , DeltaV_bitg2 , DeltaV_bitg , Deltat , a_t ,e_t , periApoInvTrue ] = bitangentTransfer (a_1 , e_1 , a_f, e_f , 'AP ', mu);
    
    
    DeltaV_vec = [ DeltaV_ecc DeltaV_plane DeltaV_periArg DeltaV_bitg1 DeltaV_bitg2 ] ;
    
    DV_mat = [ DV_mat DeltaV_vec ];
    
    % **********************
end

if plotActive
    myFig = figure ;
    plot (e_vect , sum( DV_mat ,1) , 'b', 'LineWidth ', 1);
    grid on
    hold on
    plot ( e_vect (k), min (sum( DV_mat ,1) ), 'db ', 'MarkerSize ',8);
    xlabel ('e [-] ')
    ylabel ('\ Deltav [km/s]')
    legend ('\ Deltav_ {tot}','e opt .')
    
    resizePDFPaper
    print (myFig , " eccentricityOptimization_3_b ", '-dpdf ')

end

[ DeltaV_TOT , k] = min( sum (DV_mat ,1)) % least sum of columns = deltaVs_for_each_maneuver

DeltaV_vec = DV_mat (:,k)
e_1 = e_vect (k)

% **********************
% DIMENSION CHANGE
[ DeltaV_ecc , om_1 , th_1 , a_1] = changeOrbitShape (a_i , e_i, i_i , OM_i , om_i , i_f , OM_f , e_1 , mu);

% PLANE CHANGE
[ DeltaV_plane , om_2 , th_PC ] = changeOrbitalPlane (a_1 , e_1 ,i_i , OM_i , om_1 , i_f , OM_f , mu);

% PERIAPSIS ARGUMENT CHANGE
[ DeltaV_periArg , th_peri_i , th_peri_f ] = changePericenterArg (a_1 , e_1 , om_2 , om_f , mu);

% Nearest Peri - change angle
[ th_peri_i , th_peri_f ] = choosePeriChangeAngle ( th_peri_i ,th_peri_f , th_PC )

% **********************

% BITANGENT TRANSFER
[ DeltaV_bitg1 , DeltaV_bitg2 , DeltaV_bitg , Deltat , a_t ,e_t , periApoInvTrue ] = bitangentTransfer (a_1 , e_1 , a_f, e_f , 'AP ', mu);

% **********************

% TRANSFER TIME
t1 = orbitPathTime (a_i , e_i ,mu , th_i , th_1 );
t2 = orbitPathTime (a_1 , e_1 ,mu , 0, th_PC ); % where th_PC = pi
t3 = orbitPathTime (a_1 , e_1 ,mu , th_PC , th_peri_i );
t4 = orbitPathTime (a_1 , e_1 ,mu , th_peri_f , pi);
t5 = orbitPathTime (a_t ,e_t ,mu , pi -pi* periApoInvTrue ,2* pi -pi* periApoInvTrue );
t6 = orbitPathTime (a_f ,e_f ,mu , 0, th_f );
Deltat = t1 + t2 + t3 + t4 + t5 + t6
sec2HM ( Deltat )
Deltat_vec = [t1 t2 t3 t4 t5 t6]'


plotEarth (OM_i , OM_f )
view ([104 ,38])
plotOrbit (a_i , e_i , i_i , OM_i , om_i , 0, 2*pi , dth , '--',0, speed , mu);
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, 2*pi , dth , '--',0, speed , mu);

plotOrbit (a_i , e_i , i_i , OM_i , om_i , th_i , th_1 , dth , 'dyn ',0, speed , mu , 'Initial Point ');
plotOrbit (a_1 , e_1 , i_i , OM_i , om_1 , 0, pi , dth , 'dyn ', 0,speed , mu , 'e Change ');
plotOrbit (a_1 , e_1 , i_f , OM_f , om_2 , pi , th_peri_i , dth , 'dyn', 0, speed , mu , 'Plane Change ');
plotOrbit (a_1 , e_1 , i_f , OM_f , om_f , th_peri_f , pi , dth , 'dyn', 0, speed , mu , 'Periapsis Change ');
plotOrbit (a_t , e_t , i_f , OM_f , om_f +pi* periApoInvTrue , pi -pi* periApoInvTrue ,2* pi -pi* periApoInvTrue , dth , 'dyn ', 0, speed , mu ,'Bitangent (A)');
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, th_f , dth , 'dyn ', 1,speed , mu , 'Bitangent (P)');


writeMovieAndPDF ( strategyName )
writeCSVData ( strategyName , DeltaV_vec , Deltat_vec )

%%
if generate3DPDF
% 3D PDF %*******************************
plotEarth3DPdf
view ([104 ,38])

plotOrbit3DPdf (a_i , e_i , i_i , OM_i , om_i , th_i , th_1 , dth, mu);
plotOrbit3DPdf (a_1 , e_1 , i_i , OM_i , om_1 , 0, pi , dth , mu);
plotOrbit3DPdf (a_1 , e_1 , i_f , OM_f , om_2 , pi , th_peri_i ,dth ,mu);
plotOrbit3DPdf (a_1 , e_1 , i_f , OM_f , om_f , th_peri_f , pi ,dth ,mu);
plotOrbit3DPdf (a_t , e_t , i_f , OM_f , om_f +pi*periApoInvTrue , pi -pi* periApoInvTrue ,0 -pi* periApoInvTrue , dth , mu);

% bitangente
plotOrbit3DPdf (a_f , e_f , i_f , OM_f , om_f , 0, th_f , dth ,mu);

view ([104 ,28])

ax = gca ;
fname = ' strategy_3_b ';
fig2u3d (ax , fname )
% 3D PDF %***********************************
end


%% STRATEGY 4: Plane + Circularization ( APOAPSIS )+ Bitangent

%% 4.a: caso PA

strategyName = sprintf ('C% d_strategy_4_a ', g)

plotEarth (OM_i , OM_f )

plotOrbit (a_i , e_i , i_i , OM_i , om_i , 0, 2*pi , dth , '--',0, speed , mu);
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, 2*pi , dth , '--',0, speed , mu);

% PLANE CHANGE

[ DeltaV_plane , om_1 , th_PC ] = changeOrbitalPlane (a_i , e_i ,i_i , OM_i , om_i , i_f , OM_f , mu);

% CIRCULARIZATION
[ DeltaV1c , DeltaV2c , DeltaV_circulariz , Deltat , a_c , e_c] = circularization (a_i , e_i , a_f , e_f , 'A', mu);

% SHAPE CHANGE ( Bitangent transfer )
[ DeltaV_bitg1 , DeltaV_bitg2 , DeltaV_bitg , Deltat , a_t , e_t ,periApoInvTrue ] = bitangentTransfer (a_c , e_c , a_f , e_f , 'PA ', mu);


% DELTA V
DeltaV_vec = [ DeltaV_plane DeltaV_circulariz DeltaV_bitg1 DeltaV_bitg2 ] 
DeltaV_TOT = sum ( DeltaV_vec )

% TRANSFER TIME
t1 = orbitPathTime (a_i ,e_i ,mu ,th_i , th_PC );
t2 = orbitPathTime (a_i ,e_i ,mu ,th_PC , pi);
t3 = orbitPathTime (a_c , e_c ,mu ,pi , om_f - om_1 );
t4 = orbitPathTime (a_t ,e_t ,mu ,0, pi);
t5 = orbitPathTime (a_f ,e_f ,mu ,pi , th_f );
Deltat = t1 + t2 + t3 + t4 + t5
sec2HM ( Deltat )
Deltat_vec = [t1 t2 t3 t4 t5]'


% PLOT
plotOrbit (a_i , e_i , i_i , OM_i , om_i , th_i , th_PC , dth , 'dyn ',0, speed , mu , 'Initial Point ');
plotOrbit (a_i , e_i , i_f , OM_f , om_1 , th_PC , pi , dth , 'dyn ',0, speed , mu , 'Plane Change ');
plotOrbit (a_c , e_c , i_f , OM_f , om_1 , pi , om_f -om_1 , dth , 'dyn', 0, speed , mu , ' Circularization (A)');
plotOrbit (a_t , e_t , i_f , OM_f , om_f , 0, pi , dth , 'dyn ', 0,speed , mu , 'Bitangent (P)');
plotOrbit (a_f , e_f , i_f , OM_f , om_f , pi , th_f , dth , 'dyn ', 1,speed , mu , 'Bitangent (A)');


writeMovieAndPDF ( strategyName )
writeCSVData ( strategyName , DeltaV_vec , Deltat_vec )

%% 4.b: caso AP

strategyName = sprintf ('C% d_strategy_4_b ', g)

plotEarth (OM_i , OM_f )

plotOrbit (a_i , e_i , i_i , OM_i , om_i , 0, 2*pi , dth , '--',0, speed , mu);
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, 2*pi , dth , '--',0, speed , mu);

% PLANE CHANGE
[ DeltaV_plane , om_1 , th_PC ] = changeOrbitalPlane (a_i , e_i ,i_i , OM_i , om_i , i_f , OM_f , mu);

% CIRCULARIZATION
[ DeltaV1c , DeltaV2c , DeltaV_circulariz , Deltat , a_c , e_c] = circularization (a_i , e_i , a_f , e_f ,  A', mu);

% SHAPE CHANGE ( Bitangent transfer )
[ DeltaV_bitg1 , DeltaV_bitg2 , DeltaV_bitg , Deltat , a_t , e_t ,periApoInvTrue ] = bitangentTransfer (a_c , e_c , a_f , e_f , 'AP ', mu);

% DELTA V
DeltaV_vec = [ DeltaV_plane DeltaV_circulariz DeltaV_bitg1 DeltaV_bitg2 ] 
DeltaV_TOT = sum ( DeltaV_vec )

% TRANSFER TIME
t1 = orbitPathTime (a_i ,e_i ,mu ,th_i , th_PC );
t2 = orbitPathTime (a_i ,e_i ,mu ,th_PC , pi);
t3 = orbitPathTime (a_c , e_c ,mu ,pi , -pi+om_f - om_1 );
t4 = orbitPathTime (a_t ,e_t ,mu ,pi -pi* periApoInvTrue ,0 -pi* periApoInvTrue );
t5 = orbitPathTime (a_f ,e_f ,mu ,0, th_f );
Deltat = t1 + t2 + t3 + t4 + t5
sec2HM ( Deltat )
Deltat_vec = [t1 t2 t3 t4 t5]'

% PLOT

plotOrbit (a_i , e_i , i_i , OM_i , om_i , th_i , th_PC , dth , 'dyn ',0, speed , mu , 'Initial Point ');
plotOrbit (a_i , e_i , i_f , OM_f , om_1 , th_PC , pi , dth , 'dyn ',0, speed , mu , 'Plane Change ');
plotOrbit (a_c , e_c , i_f , OM_f , om_1 , pi , -pi+om_f -om_1 , dth , 'dyn ', 0, speed , mu , ' Circularization (A)'); % per pa th = om_f , per ap th = om_f + pi.
plotOrbit (a_t , e_t , i_f , OM_f , om_f +pi* periApoInvTrue , pi -pi* periApoInvTrue ,2* pi -pi* periApoInvTrue , dth , 'dyn ', 0, speed , mu ,'Bitangent (A)');
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, th_f , dth , 'dyn ', 1,speed , mu , 'Bitangent (P)');


writeMovieAndPDF ( strategyName )
writeCSVData ( strategyName , DeltaV_vec , Deltat_vec )


%% STRATEGY 5: Plane + Circularization ( PERIAPSIS )+ Bitangent

%% 5.a: caso PA

strategyName = sprintf ('C% d_strategy_5_a ', g)

plotEarth (OM_i , OM_f )

plotOrbit (a_i , e_i , i_i , OM_i , om_i , 0, 2*pi , dth , '--',0, speed , mu);
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, 2*pi , dth , '--',0, speed , mu);

% PLANE CHANGE
[ DeltaV_plane , om_1 , th_PC ] = changeOrbitalPlane (a_i , e_i ,i_i , OM_i , om_i , i_f , OM_f , mu)

% CIRCULARIZATION
[ DeltaV1c , DeltaV2c , DeltaV_circulariz , Deltat , a_c , e_c] = circularization (a_i , e_i , a_f , e_f ,  P', mu)

% SHAPE CHANGE ( Bitangent transfer )
[ DeltaV_bitg1 , DeltaV_bitg2 , DeltaV_bitg , Deltat , a_t , e_t ,periApoInvTrue ] = bitangentTransfer (a_c , e_c , a_f , e_f , 'PA ', mu);


% DELTA V
DeltaV_vec = [ DeltaV_plane DeltaV_circulariz DeltaV_bitg1 DeltaV_bitg2 ] 
DeltaV_TOT = sum ( DeltaV_vec )

% TRANSFER TIME
t1 = orbitPathTime (a_i ,e_i ,mu ,th_i , th_PC );
t2 = orbitPathTime (a_i ,e_i ,mu ,th_PC , 2* pi);
t3 = orbitPathTime (a_c , e_c ,mu ,0, om_f - om_1 );
t4 = orbitPathTime (a_t ,e_t ,mu ,0, pi);
t5 = orbitPathTime (a_f ,e_f ,mu ,pi , th_f );
Deltat = t1 + t2 + t3 + t4 + t5
sec2HM ( Deltat )
Deltat_vec = [t1 t2 t3 t4 t5]'

% PLOT
plotOrbit (a_i , e_i , i_i , OM_i , om_i , th_i , th_PC , dth , 'dyn ',0, speed , mu , 'Initial Point ');
plotOrbit (a_i , e_i , i_f , OM_f , om_1 , th_PC , 2*pi , dth , 'dyn ',0, speed , mu , 'Plane Change ');
plotOrbit (a_c , e_c , i_f , OM_f , om_1 , 0, om_f -om_1 , dth , 'dyn ', 0, speed , mu , ' Circularization (P)'); % per pa th = om_f, per ap th = om_f + pi.
plotOrbit (a_t , e_t , i_f , OM_f , om_f , 0, pi , dth , 'dyn ', 0,speed , mu , 'Bitangent (P)');
plotOrbit (a_f , e_f , i_f , OM_f , om_f , pi , th_f , dth , 'dyn ', 1,speed , mu , 'Bitangent (A)');

writeMovieAndPDF ( strategyName )
writeCSVData ( strategyName , DeltaV_vec , Deltat_vec )

%% 5.b: caso AP

strategyName = sprintf ('C% d_strategy_5_b ', g)

plotEarth (OM_i , OM_f )

plotOrbit (a_i , e_i , i_i , OM_i , om_i , 0, 2*pi , dth , '--',0, speed , mu);
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, 2*pi , dth , '--',0, speed , mu);

% PLANE CHANGE
[ DeltaV_plane , om_1 , th_PC ] = changeOrbitalPlane (a_i , e_i ,i_i , OM_i , om_i , i_f , OM_f , mu)

% CIRCULARIZATION
[ DeltaV1c , DeltaV2c , DeltaV_circulariz , Deltat , a_c , e_c] = circularization (a_i , e_i , a_f , e_f ,  P', mu)

% SHAPE CHANGE ( Bitangent transfer )
[ DeltaV_bitg1 , DeltaV_bitg2 , DeltaV_bitg , Deltat , a_t , e_t ,periApoInvTrue ] = bitangentTransfer (a_c , e_c , a_f , e_f , 'AP ', mu);

% DELTA V
DeltaV_vec = [ DeltaV_plane DeltaV_circulariz DeltaV_bitg1 DeltaV_bitg2 ] 
DeltaV_TOT = sum ( DeltaV_vec )

% TRANSFER TIME

t1 = orbitPathTime (a_i ,e_i ,mu ,th_i , th_PC );
t2 = orbitPathTime (a_i ,e_i ,mu ,th_PC , 0);
t3 = orbitPathTime (a_c , e_c ,mu ,0, -pi+om_f - om_1 );
t4 = orbitPathTime (a_t ,e_t ,mu ,0, pi);
t5 = orbitPathTime (a_f ,e_f ,mu ,0, th_f );
Deltat = t1 + t2 + t3 + t4 + t5
sec2HM ( Deltat )
Deltat_vec = [t1 t2 t3 t4 t5]'

% PLOT
plotOrbit (a_i , e_i , i_i , OM_i , om_i , th_i , th_PC , dth , 'dyn ',0, speed , mu , 'Initial Point ');
plotOrbit (a_i , e_i , i_f , OM_f , om_1 , th_PC , 2*pi , dth , 'dyn ',0, speed , mu , 'Plane Change ');
plotOrbit (a_c , e_c , i_f , OM_f , om_1 , 0, -pi+om_f -om_1 , dth , 'dyn ', 0, speed , mu , ' Circularization ');
plotOrbit (a_t , e_t , i_f , OM_f , pi+om_f , 0, pi , dth , 'dyn ', 0,speed , mu , 'Bitangent (A)');
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, th_f , dth , 'dyn ', 1,speed , mu , 'Bitangent (P)');


writeMovieAndPDF ( strategyName )
writeCSVData ( strategyName , DeltaV_vec , Deltat_vec )


%% STRATEGY 6: DIRECT TRANSFER

strategyName = sprintf ('C% d_strategy_6 ', g)

DV_mat = [];
Dt_mat = [];
dom_T = 0.01* pi /180;
% om_T_vect = ([ deg2rad (70) : dom_T : deg2rad (87) ]);
om_T_vect = ([ deg2rad (250) : dom_T : deg2rad (344) ]);

for om_T = om_T_vect (1): dom_T : om_T_vect ( end)

[ DeltaV_T1 , DeltaV_T2 , a_T , e_T , i_T , OM_T , th_T_i ,th_T_f ] = directTransfer (a_i , e_i , i_i , OM_i , om_i ,th_i , om_T , a_f , e_f , i_f , OM_f , om_f , th_f , mu);
% DELTA V
DeltaV_vec = [ DeltaV_T1 DeltaV_T2 ]';
DV_mat = [ DV_mat DeltaV_vec ];

% TRANSFER TIME
t1 = orbitPathTime (a_T ,e_T ,mu ,th_T_i , th_T_f );
Deltat = t1;

Deltat_vec = [t1 ]';
Dt_mat = [ Dt_mat Deltat_vec ];

end

[~, k] = min( sum( DV_mat ,1) ) % least sum of columns = deltaVs_for_each_maneuver

% DELTA V
DeltaV_vec = DV_mat (:,k)
DeltaV_TOT = sum ( DeltaV_vec )
om_T = om_T_vect (k)

if plotActive
myFig = figure ;
plot ( rad2deg ( om_T_vect ), sum (DV_mat ,1) , 'b', 'LineWidth ',1);
grid on
hold on
plot ( rad2deg ( om_T_vect (k)), min ( sum (DV_mat ,1) ), 'db ', 'MarkerSize ', 8);
xlabel ('\ omega_t [ deg]')
ylabel ('\ Deltav [km/s]')
legend ('\ Deltav_ {tot}','\ omega_t opt.')

resizePDFPaper
print (myFig , " periArgOptimization_6 ", '-dpdf ')
end

% **********************
[ DeltaV_T1 , DeltaV_T2 , a_T , e_T , i_T , OM_T , th_T_i ,th_T_f ] = directTransfer (a_i , e_i , i_i , OM_i , om_i, th_i , om_T , a_f , e_f , i_f , OM_f , om_f , th_f, mu);
% **********************

% TRANSFER TIME
t1 = orbitPathTime (a_T ,e_T ,mu ,th_T_i , th_T_f );
Deltat = t1;
sec2HM ( Deltat )
Deltat_vec = [t1]

% PLOT
plotEarth (OM_i , OM_f )
if plotActive

view ([164 ,40])
plotOrbit (a_i , e_i , i_i , OM_i , om_i , 0, 2*pi , dth , '--', 0, speed , mu);
plotOrbit (a_f , e_f , i_f , OM_f , om_f , 0, 2*pi , dth , '--', 0, speed , mu);
plotOrbit (a_T , e_T , i_T , OM_T , om_T , th_T_i , th_T_f , dth , 'dyn ', 1, speed , mu , sprintf ('Direct Transfer (\\ omega_t =%.2 f deg )', rad2deg ( om_T )));

dirTransfOrb = plotOrbit (a_T , e_T , i_T , OM_T , om_T , 0, 2*pi ,dth , '--m', 0, speed , mu);
fontSize = 16;
markerSize = 10;
timeBoxLocation = [.1 .8 .1 .1];
legendLocation = [.7 .8 .1 .1];
maneuvCount = maneuvCount + 1;
legendInf { maneuvCount } = sprintf (" Direct -transfer orbit ");
legendObjs ( maneuvCount ) = dirTransfOrb ;
legend ( legendObjs , legendInf , 'AutoUpdate ', 'off ', 'Location ', legendLocation , 'FontSize ', fontSize );
end

writeMovieAndPDF ( strategyName )
% writeCSVData ( strategyName , DeltaV_vec , Deltat_vec )

%% COMPARISON

DV_strat = [6.9614 7.1163 7.0422 5.9305 5.7008 6.9444 6.9967 8.3036 8.4286 7.9827]  ;
Dt_strat = [33114 22625 28533 56389 37483 44766 23649 33176 20894 2979 ] ;

markerSize = 8;
fontSize = 14;
stratNum = length ( DV_strat );

markerColors = colormap ( lines ( stratNum ));
legendInf = {};
legendObjs = [];

stratName = {'1.a', '1.b', '2', '3.a', '3.b', '4.a', '4.b', '5.a', '5.b', '6'};

myFig = figure ;
grid on
hold on

xlabel ('\ Deltat [s]', 'FontSize ', fontSize )
ylabel ('\ Deltav [km/s]', 'FontSize ', fontSize )

optIndex = DV_strat .* Dt_strat ;
[~, k_prod ] = min( optIndex );
sprintf ('OPT Delta_V * Delta_t :%s -> Delta_V =%.3 f km/s Delta_t =%d s', stratName { k_prod }, DV_strat ( k_prod ), round (Dt_strat ( k_prod )))

optIndex = sqrt ( (( DV_strat -min ( DV_strat ))/( max ( DV_strat )-min( DV_strat ))) .^2 + (( Dt_strat - min( Dt_strat ))/( max ( Dt_strat )-min( Dt_strat ))).^2 );
[~, k_modVec ] = min ( optIndex );
sprintf ('OPT sqrt ( Delta_V_perc ^2 + Delta_t_perc ^2) :%s ->Delta_V =%.3 f km/s Delta_t =%d s', stratName { k_modVec },DV_strat ( k_modVec ), round ( Dt_strat ( k_modVec )))

optIndex = DV_strat ;
[~, k_DV ] = min( optIndex );
sprintf ('OPT Delta_V :%s -> Delta_V =%.3 f km/s Delta_t =%d s', stratName { k_DV }, DV_strat ( k_DV ), round ( Dt_strat ( k_DV )))

optIndex = Dt_strat ;
[~, k_Dt ] = min( optIndex );
sprintf ('OPT Delta_t :%s -> Delta_V =%.3 f km/s Delta_t =%d s', stratName { k_Dt }, DV_strat ( k_Dt ), round ( Dt_strat ( k_Dt )))

for k = 1: stratNum
    
    optString = '';
    
    if k == k_prod || k == k_DV || k == k_Dt || k == k_modVec
        stratData = plot ( Dt_strat (k), DV_strat (k),'d', 'MarkerSize ', markerSize , ' MarkerEdgeColor ',markerColors (k ,:) , ' MarkerFaceColor ', markerColors(k ,:));
        
        switch k
            case { k_prod }
                optString = ' (\ Deltav \ cdot \ Deltat )';
            case { k_DV }
                optString = ' (\ Deltav )';
            case { k_Dt }
                optString = ' (\ Deltat )';
            case { k_modVec }
                optString = ' (\ surd (\ Deltav_ {%}^2 + \Deltat_ {%}^2) )';
                optString = sprintf ('%s', optString );
            otherwise
        end
    else
    stratData = plot ( Dt_strat (k), DV_strat (k),'d', 'MarkerSize ', markerSize , ' MarkerEdgeColor ',markerColors (k ,:) );
    end
    
    legendInf {k} = sprintf ("%s%s", stratName {k},optString );
    legendObjs (k) = stratData ;
    legend ( legendObjs , legendInf , 'AutoUpdate ', 'off ', 'FontSize ', fontSize );
    pause (0.1)

end
set(myFig ,  'Units 0', 'Normalized ', ' OuterPosition ', [0.3 0.3 0.4 .62]) ;
resizePDFPaper
print (myFig , " strategyComparison ", '-dpdf ')









