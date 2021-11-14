function plotOrbit(orbit,dth)

% 3D orbit plot

% ----------------------------------------------------------
% Input arguments :
% orbit [1,1] = a        semi - major axis [km]
% orbit [1,2] = e              eccentricity [-]
% orbit [1,3] = i           inclination [ rad ]
% orbit [1,4] = OM                 RAAN [ rad ]
% orbit [1,5] = om    pericenter anomaly [rad ]
% orbit [1,6] = thi initial true anomaly [rad ]
% orbit [1,7] = thf   final true anomaly [rad ]
% dth [1 x1]     true anomaly step size [ rad ]
% ----------------------------------------------------------


[numberOrbits,~] = size(orbit)

markerColors = colormap ( lines ( numberOrbits ));


rt=6371;                                                               % raggio terrestre
[xs,ys,zs]=sphere;
xs=xs*rt;
ys=ys*rt;
zs=-zs*rt;
earth=surface(xs,ys,zs); 
shading flat;
imData=imread('map.jpg');                                              % lettura mappa(inserire qua 'nomeMappa.jpg' che deve stare nella stessa cartella)
set(earth,'facecolor','texturemap','cdata',imData,'edgecolor','none'); % incolla mappa su sfera
axis square

hold on
grid on
title("3D ORBIT");
xlabel("equinox line [km]");
ylabel("y [km]");
zlabel("z [km]");

for j = 1:numberOrbits    
    a = orbit(j,1);
    e = orbit(j,2);
    i = orbit(j,3);
    OM = orbit(j,4);
    om = orbit(j,5);
    thi = orbit(j,6);
    thf = orbit(j,7);
    
    
    if thf <= thi % the  =r sign involves the case in which th0 == thf 
        % ( convention : last path to plot , i.e. full orbit to play )
        thf = thf + 2*pi;
    end
   
    numTh = round (abs(thf -thi )/dth);
    th_v = linspace (thi ,thf , numTh );
    RR = zeros (3, length ( th_v ));
    VV = zeros (3, length ( th_v ));

    for k = 1: length ( th_v )
        [R,V] = Param2rv ( a, e, i, OM, om, th_v(k));
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
  
    plot3(X,Y,Z)
    hold on
    maneuvPoint = plot3 (X (1) , Y(1) , Z(1) ,'d','MarkerSize', 10 ,'MarkerEdgeColor', markerColors (numberOrbits , :) ,'MarkerFaceColor', markerColors (numberOrbits , :));
    quiver3 (X (1) , Y(1) , Z (1) ,V_X (1) , V_Y (1) , V_Z (1),700,"filled",'-r','LineWidth' ,1.5 ,'MaxHeadSize',10) ;
    [R_peri ,~] = Param2rv (a,e,i,OM ,om ,0);
    [R_apo ,~] = Param2rv (a,e,i,OM ,om ,pi);
    plot3 ([ R_peri(1) ,R_apo(1) ],[ R_peri(2),R_apo(2) ],[ R_peri(3) ,R_apo(3)],'-.b','LineWidth'   ,1); % semi - major axis
    

end
