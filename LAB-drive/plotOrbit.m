function [ myPlot ] = plotOrbit (a, e, i, OM , om , th0 , thf , dth ,plotType , isFinalPath , speed , mu , maneuvName )

% 3D orbit plot
%
% ----------------------------------------------------------
% Input arguments :
% a [1 x1] semi - major axis [km]
% e [1 x1] eccentricity [-]
% i [1 x1] inclination [ rad ]
% OM [1 x1] RAAN [ rad ]
% om [1 x1] pericenter anomaly [rad ]
% th0 [1 x1] initial true anomaly [rad ]
% thf [1 x1] final true anomaly [rad ]
% dth [1 x1] true anomaly step size [ rad ]
% mu [1 x1] gravitational parameter [km ^3/s^2]
% ----------------------------------------------------------


if plotActive

    wE = (2* pi /86164) ; % Earth ’s angular rate aorund z- axis[ rad/ sec ]
    
    fontSize = 16;
    markerSize = 10;
    timeBoxLocation = [.1 .8 .1 .1];
    legendLocation = [.7 .8 .1 .1];
    
    
    pauseTime = 1/ fps; %[s]
    
    th0 = wrapTo2Pi ( th0 );
    thf = wrapTo2Pi ( thf );
    
    if thf <= th0 % the  =’ sign involves the case in which th0 == thf 
        % ( convention : last path to plot , i.e. full orbit to play )
        thf = thf + 2* pi;
    end
    
    
    numTh = round (abs(thf -th0 )/dth);


    th_v = linspace (th0 ,thf , numTh );
RR = zeros (3, length ( th_v ));
VV = zeros (3, length ( th_v ));


for k = 1: length ( th_v )
[R,V] = par2car (a,e,i,OM ,om , th_v (k), mu);
RR (:,k) = R;
VV (:,k) = V;
end

X = RR (1 ,:);
Y = RR (2 ,:);
Z = RR (3 ,:);

V_X = VV (1 ,:);
V_Y = VV (2 ,:);
V_Z = VV (3 ,:);

V = sqrt (VV (1 ,:) .^2 + VV (2 ,:) .^2 + VV (3 ,:) .^2) ;

tt = theta2t (a,e,mu ,0, th_v );


k_update = 1;
t0 = cputime ;
DT = 0;
V_min = min (V);
V_max = max (V);
V_span = V_max - V_min ;

cmapDim = 256;
cmap = parula ( cmapDim );

% cBar = colorbar ;
% set (cBar , ’ylim ’, [ V_min V_max ]);


if tLast == 0
maneuvCount = 0;
legendInf = {};
legendObjs = [];
end


if nargin == 12

maneuvName = [’Point ’ num2str ( maneuvCount )];
end

maneuvMaxNum = 7;

markerColors = colormap ( lines ( maneuvMaxNum ));
if ( maneuvCount + 1) == maneuvMaxNum
maneuvMaxNum = maneuvMaxNum + 1;
 markerColors = colormap ( lines ( maneuvMaxNum ));
end


switch lower ( plotType )
case {’dyn ’} % Dynamic simulation
% Time -Box
delete ( timeBox )
timeBox = annotation (’textbox ’,timeBoxLocation ,’String ’,’ Time : ’);
timeBox . FontSize = fontSize ;
timeBox . BackgroundColor = ’w’;

% Initial point velocity vector arrow
if tLast == 0
quiver3 (X (1) , Y(1) , Z (1) ,V_X (1) , V_Y (1) , V_Z (1),700, ’-r’, ’LineWidth ’ ,1.5 , ’ MaxHeadSize ’,10) ;
else
quiver3 (X (1) , Y(1) , Z (1) ,V_X (1) , V_Y (1) , V_Z (1),700, ’-g’, ’LineWidth ’ ,1.5 , ’ MaxHeadSize ’,10) ;
end

% First movie frame
myMovie (1) = getframe ( myFig );


% Highlight each Maneuver Point with legend
maneuvCount = maneuvCount + 1;
maneuvPoint = plot3 (X (1) , Y(1) , Z(1) ,’d’, ’MarkerSize’, markerSize , ’ MarkerEdgeColor ’, markerColors (maneuvCount , :) ,’ MarkerFaceColor ’, markerColors (maneuvCount , :));
legendInf { maneuvCount } = sprintf ("%d. %s",maneuvCount -1, maneuvName );
legendObjs ( maneuvCount ) = maneuvPoint ;
legend ( legendObjs , legendInf , ’AutoUpdate ’, ’off ’, ’Location ’, legendLocation , ’FontSize ’, fontSize );


for k = 2: length (tt)

if k < length (tt)
XS(k) = plot3 (X(k), Y(k), Z(k), o’ ,... % Plot the current position of the S/C
    ’MarkerSize ’, markerSize ,’MarkerEdgeColor ’,’r’,’MarkerFaceColor ’ ,[0.8 ,0.2 ,0.2]) ;
end


if (k >1)
delete (XS(k -1)); % delete last position of the S/C and replace it with

end

if (( tt(k)-tt( k_update )) >= pauseTime * speed ) || k== length (tt)

% (tt(k)-tt( k_update ))

cmapIndex = floor ( ( cmapDim -1) * (V(k)-V_min )/ V_span ) + 1;
stepColor = cmap ( cmapIndex ,:) ;
plot3 (X( k_update :k), Y( k_update :k), Z(k_update :k), ’LineWidth ’, 1.5 , ’Color ’,stepColor );

hours = floor (( tLast +tt(k)) /3600) ;
minutes = round ((( tLast +tt(k))-hours *3600)/60) ;
timeBox . String = sprintf (" Time : %d h %02d m", hours , minutes );

rotate (globe ,[0 0 1], rad2deg (wE * (tt(k)-tt( k_update ))) ,[0 0 0]);

if captureMovie
 myMovie ( end +1) = getframe ( myFig );
end


drawnow limitrate

k_update = k;
% dt = cputime - t0
% DT = DT+dt
% if (DT < pauseTime )
% pause ( pauseTime )
% else
% DT =0;
%end
% t0 = cputime ;
pause ( pauseTime )
end

end

quiver3 (X( end), Y( end ), Z(end),V_X( end ), V_Y( end ), V_Z (end ) ,700, ’-r’, ’LineWidth ’ ,1,’MaxHeadSize ’, 10);
tLast = tLast + tt( end );

% Highlight Final Point with legend
if isFinalPath
% Highlight maneuver point with legend
maneuvCount = maneuvCount + 1;
maneuvPoint = plot3 (X( end), Y( end ), Z(end),’d’, ’MarkerSize ’, markerSize , ’MarkerEdgeColor ’, markerColors ( maneuvCount, :) ,’ MarkerFaceColor ’, markerColors (maneuvCount , :));
legendInf { maneuvCount } = sprintf ("%d. %s",maneuvCount -1, " Final Point ");
legendObjs ( maneuvCount ) = maneuvPoint ;
legend ( legendObjs , legendInf , ’AutoUpdate ’, ’off ’, ’Location ’, legendLocation , ’FontSize ’, fontSize );
myMovie ( end +1) = getframe ( myFig );
end

case {’stat ’} % Static plot
% Time -Box

quiver3 (X (1) , Y(1) , Z (1) ,V_X (1) , V_Y (1) , V_Z (1),700, ’-r’, ’LineWidth ’ ,1.5 , ’ MaxHeadSize ’,10) ;

% Highlight each Maneuver Point with legend
maneuvCount = maneuvCount + 1;
maneuvPoint = plot3 (X (1) , Y(1) , Z (1) ,’d’, ’MarkerSize ’, markerSize , ’ MarkerEdgeColor ’,markerColors ( maneuvCount , :) ,’ MarkerFaceColor ’, markerColors ( maneuvCount , :));
legendInf { maneuvCount } = sprintf ("%d. %s",maneuvCount , maneuvName );
legendObjs ( maneuvCount ) = maneuvPoint ;
legend ( legendObjs , legendInf , ’AutoUpdate ’, ’off ’, ’Location ’, legendLocation , ’FontSize ’, 16 );

[ R_peri ,~] = par2car (a,e,i,OM ,om ,0, mu);
[R_apo ,~] = par2car (a,e,i,OM ,om ,pi , mu);
semiMajor = plot3 ([ R_peri (1) ,R_apo (1) ],[ R_peri (2),R_apo (2) ],[ R_peri (3) ,R_apo (3)],’ -.b’,’LineWidth ’ ,1); % semi - major axis
semiMajor . Color (4) = 0.4;


for k = 2: length (tt)

cmapIndex = floor ( ( cmapDim -1) * (V(k)-V_min )/ V_span ) + 1;
stepColor = cmap ( cmapIndex ,:) ;
plot3 (X(k -1: k), Y(k -1: k), Z(k -1: k), ’LineWidth ’, 1.5 , ’Color ’, stepColor );

end

tLast = length (tt); % This command has no purposeexcept avoiding that for consecutive plots :
% tLast = 0 -> maneuvCount =1 ( repeatedly ) ->
% legend overwritten eachtime (i.e. we only se thelast point added )

case {’--’} % Static dashed plot
myPlot = plot3 (X, Y, Z, ’--k’, ’LineWidth ’, 1.5 );
myPlot . Color (4) = 0.2;

[ R_peri ,~] = par2car (a,e,i,OM ,om ,0, mu);
[R_apo ,~] = par2car (a,e,i,OM ,om ,pi , mu);
semiMajor = plot3 ([ R_peri (1) ,R_apo (1) ],[ R_peri (2),R_apo (2) ],[ R_peri (3) ,R_apo (3)],’ -.b’,’LineWidth ’ ,1); % semi - major axis
semiMajor . Color (4) = 0.4;
otherwise
myPlot = plot3 (X, Y, Z, plotType , ’LineWidth ’,1.5 );
myPlot . Color (4) = 0.5;
[ R_peri ,~] = par2car (a,e,i,OM ,om ,0, mu);
[R_apo ,~] = par2car (a,e,i,OM ,om ,pi , mu);
semiMajor = plot3 ([ R_peri (1) ,R_apo (1) ],[ R_peri (2),R_apo (2) ],[ R_peri (3) ,R_apo (3)],’ -.b’,’
LineWidth ’ ,1); % semi - major axis
semiMajor . Color (4) = 0.4;

 end

grid on
axis equal

end

end


























