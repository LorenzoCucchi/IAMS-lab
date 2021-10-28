function plotOrbit3DPdf (a, e, i, OM , om , th0 , thf , dth , mu)

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

fps = 20; % Frames per second [1/ s]


pauseTime = 1/ fps; %[s]

th0 = wrapTo2Pi ( th0);
thf = wrapTo2Pi ( thf);
if thf <= th0 % the ’=’ sign involves the case in which th0 ==thf ( convention : last path to plot , i.e. full orbit toplay )
thf = thf + 2* pi;
end


th_v = [ th0 :dth : thf ];
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


th = [ th0 :dth : thf ];
tt = theta2t (a,e,mu ,0, th);

myPlot = plot3 (X, Y, Z, '-', 'LineWidth ', 1.5 );
% myPlot . Color (4) = 0.5;



quiver3 (X (1) , Y(1) , Z (1) ,V_X (1) , V_Y (1) , V_Z (1) ,700, '-g', 'LineWidth ' ,1.5 , 'MaxHeadSize ', 10) ;
if (thf - th0 ) < 2* pi % otherwise , our convention implies that we have reached the last path to plot
quiver3 (X( end ), Y( end ), Z(end),V_X( end ), V_Y (end ),V_Z (end) ,700 , '-r', 'LineWidth ' ,1,'MaxHeadSize ',10) ;
end

plot3 (X(1) , Y (1) , Z (1) ,'o' ,'MarkerSize' ,8,'MarkerEdgeColor ','r','MarkerFaceColor ' ,[0.8 ,0.2 ,0.2]) ;

grid on
axis equal

end