figure ('Color ','w');

% *****************************************************
a = 9900;
RAAN = 1.1116;
h1 = sin (i)* sin ( RAAN ); % x- component of unit vector h
h2 = -sin (i)* cos ( RAAN ); % y- component of unit vector h
h3 = cos (i); % z- component of unit vector h
n1 = -h2 /( sqrt (h1 ^2+ h2 ^2)); % x- component of nodes ’ line
n2 = h1 /( sqrt (h1 ^2+ h2 ^2) ); % y- component of nodes ’ line
n3 = 0; % z- component of nodes ’ line
N = [n1 ,n2 ,n3 ]; % nodes ’ line ( unit vector )

ra = 9910.8;
a = 9091.4;
% *****************************************************
% % Definition of axes necessary to rotate the object to whom are reported
% ax = axes (’XLim ’,[-a a],’YLim ’,[-a a],’ZLim ’,[-a a]);

Rplanet =6378; % Planet radius [km]
npanels = 72; % Number of globe panels around the equator [deg / panel ] = [360/ npanels ]
alpha = 0.9; % alpha (i.e. transparency level ) of the globe
image_file = 'earth . jpg ';
erad = Rplanet ; % equatorial radius [km]
prad = Rplanet ; % polar radius [km]
erot =7.2921158553e-5; % earth rotation rate [ rad /s]
hold on;
axis equal ;
axis vis3d ;
[x,y,z] = ellipsoid (0, 0, 0, erad , erad , prad , npanels ); % Create a 3D meshgrid of the sphere points using theellipsoid function

globe = surf (x,y,-z,'FaceColor ','none ','EdgeColor ' ,0.5*[1 1 1]);

cdata = imread ( image_file ); % Load Earth image for texture map
% Set image as color data ( cdata ) property , and set face color to indicate
% a texturemap , which Matlab expects to be in cdata .

% Ligthing settings
view ([36 ,34])
shading interp
% lightangle (40 , -80)
% globe . FaceColor = ’texturemap ’;
% globe . CData = cdata ;
globe . FaceColor = [.2 .2 1];
globe . FaceAlpha = 0.9;
globe . EdgeColor = 'none' ;
globe . AmbientStrength = 0.1;
globe . DiffuseStrength = 1;
globe . SpecularColorReflectance = .5;
globe . SpecularExponent = 20;
globe . SpecularStrength = 1;
globe . FaceLighting = 'phong ';
% Add lights .
% Add lights .
light ('position ' ,[1 0 1]);
light ('position ' ,[1.5 0.5 -0.5] , 'color ', [.6 .2 .2]) ;
rotate (globe ,[0 0 1] ,180 ,[0 0 0]);


% % Plot the equator
% angle_eq = linspace (0 ,2*pi ,361) ;
% xeq = ( Rplanet *1.0001) .* cos ( angle_eq );
% yeq = ( Rplanet *1.0001) .* sin ( angle_eq );
% zeq = zeros (1, size ( angle_eq ,2) );
%
%
% % ECI F.o.R., equator and nodes ’ line
% plot3 ([0 ,2* ra ] ,[0 ,0] ,[0 ,0] , ’ - -k’,’ LineWidth ’ ,1);
% X = Aries   direction ( aligned with the vernal point )
% plot3 ([0 ,0] ,[0 ,2* ra ],[0,0],’--k’,’ LineWidth ’ ,1);
% Y
% plot3 ([0 ,0] ,[0 ,0] ,[0 ,2* ra],’--k’,’ LineWidth ’ ,1);
% Z
% text (2* ra +120 ,10 ,0 , texlabel (’gamma ’) ,’Color ’,’k’,’ FontSize’ ,18);
% text (10 ,2* ra +120 ,0 , texlabel (’Y ’) ,’Color ’,’k’,’ FontSize ’ ,10);
% text (0 ,0 ,2* ra +140 , texlabel (’Z ’) ,’Color ’,’k’,’ FontSize ’ ,10);
% plot3 (xeq ,yeq ,zeq ,’--w’,’ LineWidth ’ ,1);
% Equator
% plot3 ([0 ,2* ra*n1 ] ,[0 ,2* ra*n2 ] ,[0 , n3],’--r’,’ LineWidth ’ ,1.5); 
% Nodes ’ Line
% text (2* ra*n1 -140 ,2* ra*n2 +140 ,0 , texlabel (+RAAN ’) ,’Color ’,’r’,’ FontSize ’ ,8);