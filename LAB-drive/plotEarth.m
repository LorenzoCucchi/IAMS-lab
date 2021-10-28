function [] = plotEarhth (OM_i , OM_f )

global tLast ;
global globe ;
global myMovie ;
global myFig ;
global captureMovie ;
global playAfterCapture ;
global plotActive ;
myMovie = struct (’cdata ’ ,[],’colormap ’ ,[]);
tLast = 0;

if plotActive
    if captureMovie
        myFig = figure (’units ’,’pixels ’,’position ’ ,[0 0 12001080]) ;
    else
        myFig = figure ; 
        set (myFig ,  Units ’, ’Normalized ’, ’ OuterPosition ’,[0.25 0.25 .5 1]) ;
    end

% *****************************************************
a = 9900;
if ( nargin == 2)
h1 = sin (i)* sin ( OM_i ); % x- component of unit
vector h
h2 = -sin (i)* cos ( OM_i ); % y- component of unit
vector h
h3 = cos (i); % z- component of unit
vector h
n1 = -h2 /( sqrt (h1 ^2+ h2 ^2)); % x- component of nodes ’
line
n2 = h1 /( sqrt (h1 ^2+ h2 ^2) ); % y- component of nodes ’
line
n3 = 0; % z- component of nodes ’
line
N_i = [n1 ,n2 ,n3 ]; % nodes ’ line ( unitvector )

h1 = sin (i)* sin ( OM_f ); % x- component of unit vector h
h2 = -sin (i)* cos ( OM_f ); % y- component of unit vector h
h3 = cos (i); % z- component of unit vector h
n1 = -h2 /( sqrt (h1 ^2+ h2 ^2)); % x- component of nodes ’
line
n2 = h1 /( sqrt (h1 ^2+ h2 ^2) ); % y- component of nodes ’
line
n3 = 0; % z- component of nodes ’
line
N_f = [n1 ,n2 ,n3 ]; % nodes ’ line ( unit
vector )
end

ra = 9910.8;

a = 9091.4;
% *****************************************************
% % Definition of axes necessary to rotate the object to whom are reported
% ax = axes (’XLim ’,[-a a],’YLim ’,[-a a],’ZLim ’,[-a a]);

Rplanet =6378; % Planet radius [km]
npanels = 360; % Number of globe panels around the equator [deg/ panel ] = [360/ npanels ]
alpha = 0.9; % alpha (i.e. transparency level ) of the globe
image_file = ’earth . jpg ’;
erad = Rplanet ; % equatorial radius [km]
prad = Rplanet ; % polar radius [km]
hold on;
axis equal ;
axis vis3d ;
[x,y,z] = ellipsoid (0, 0, 0, erad , erad , prad , npanels );
% Create a 3D meshgrid of the sphere points using the ellipsoid function
globe = surf (x,y,-z, FaceColor ’,’none ’,’EdgeColor ’ ,0.5*[1 1 1]) ;
cdata = imread ( image_file ); % Load Earth image for texture map
% Set image as color data ( cdata ) property , and set face color to indicate
% a texturemap , which Matlab expects to be in cdata .

% Ligthing settings
view ([104 ,21])
shading interp
% lightangle (40 , -80)
globe . FaceColor = ’texturemap ’;
globe . CData = cdata ;
globe . FaceAlpha = 0.9;
globe . EdgeColor = ’none ’;

% globe . FaceLighting = ’gouraud ’;
% globe . AmbientStrength = 0.9;
% globe . DiffuseStrength = 0.8;
% globe . SpecularStrength = 0.9;
% globe . SpecularExponent = 90;
 
globe . AmbientStrength = 0.1;
globe . DiffuseStrength = 1;
globe . SpecularColorReflectance = .5;

globe . SpecularExponent = 20;
globe . SpecularStrength = 1;
globe . FaceLighting = ’phong ’;
% Add lights .
light (’position ’ ,[1 0 1]) ;
light (’position ’ ,[1.5 0.5 -0.5] , ’color ’, [.6 .2 .2]) ;

rotate (globe ,[0 0 1] ,180 ,[0 0 0]);


% Plot the equator
angle_eq = linspace (0 ,2*pi ,361) ;
xeq = ( Rplanet *1.0001) .* cos( angle_eq );
yeq = ( Rplanet *1.0001) .* sin( angle_eq );
zeq = zeros (1, size ( angle_eq ,2) );


% ECI F.o.R., equator and nodes ’ line
plot3 ([0 ,2* ra ] ,[0 ,0] ,[0 ,0] , ’ -.k’,’LineWidth ’ ,1);
% X = Aries   direction ( aligned with the vernal point )
plot3 ([0 ,0] ,[0 ,2* ra ] ,[0 ,0] , ’ -.k’,’LineWidth ’ ,1);
% Y
plot3 ([0 ,0] ,[0 ,0] ,[0 ,2* ra],’ -.k’,’LineWidth ’ ,1);
% Z
text (2* ra +120 ,10 ,0 , texlabel (’gamma ’),’Color ’,’k’,’FontSize ’ ,18);
text (10 ,2* ra +120 ,0 , texlabel (’Y’),’Color ’,’k’,’FontSize ’,10);
text (0 ,0 ,2* ra +140 , texlabel (’Z’),’Color ’,’k’,’FontSize ’,10);
plot3 (xeq ,yeq ,zeq ,’--w’,’LineWidth ’ ,1);
% Equator

if ( nargin == 2)
alphaRAAN = 0.4;
RAAN_i = plot3 ([0 ,2* ra* N_i (1) ] ,[0 ,2* ra*N_i (2) ],[0, N_i(3) ],’ -.r’,’LineWidth ’ ,1.5); % Initial Nodes ’Line
text (2* ra*N_i (1) -140 ,2* ra* N_i (2) +140 ,0 , texlabel (’RAAN_i ’),’Color ’,’r’,’FontSize ’ ,8);
RAAN_i . Color (4) = alphaRAAN ;

RAAN_f = plot3 ([0 ,2* ra* N_f (1) ] ,[0 ,2* ra*N_f (2) ],[0, N_f(3) ],  -.r’,’LineWidth ’ ,1.5); % Final Nodes ’ Line
text (2* ra*N_f (1) -140 ,2* ra* N_f (2) +140 ,0 , texlabel ('RAAN_f '),’Color ’,’r’,’FontSize ’ ,8);
RAAN_f . Color (4) = alphaRAAN ;

end

end


end