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

figure(2)
[numberOrbits,~] = size(orbit)


markerColors = colormap(winter( numberOrbits+1));


rt=6371;                                                               % raggio terrestre
[xs,ys,zs]=sphere;
xs=xs*rt;
ys=ys*rt;
zs=-zs*rt;
earth=surface(xs,ys,zs); 
shading flat;
imData=imread('map.jpg');                                              % lettura mappa(inserire qua 'nomeMappa.jpg' che deve stare nella stessa cartella)
set(earth,'facecolor','texturemap','cdata',imData,'edgecolor','none'); % incolla mappa su sfera
axis equal

hold on
grid on
lun = 13000;

    quiver3(0,0,0,lun,0,0,1.2,'-.','color','k','LineWidth',0.5);
    quiver3(0,0,0,0,lun,0,1.2,'-.','color','k','LineWidth',0.5);
    quiver3(0,0,0,0,0,lun,1.2,'-.','color','k','LineWidth',0.5);
 text(lun+3000,0,0,'I','FontSize',12,'color','k');
    text(0,lun+3000,0,'J','FontSize',12,'color','k');
    text(0,0,lun+3000,'K','FontSize',12,'color','k');
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

    V_min = min(V);
    V_max = max(V);
    V_span = V_max-V_min;

    cmapDim = 256;
    cmap = parula ( cmapDim );

    for k = 2: length (th_v)
            
        cmapIndex = floor ( ( cmapDim -1) * (V(k)-V_min )/ V_span ) + 1;
        stepColor = cmap ( cmapIndex ,:) ;
        plot3(X(k -1: k), Y(k -1: k), Z(k -1: k),'LineWidth', 1.5 ,'Color', stepColor );
    end


    %     hold on
    maneuvPoint = plot3 (X (1) , Y(1) , Z(1) ,'d','MarkerSize', 10 ,'MarkerEdgeColor', markerColors (j, :) ,'MarkerFaceColor', markerColors (j, :));
    %quiver3 (X (1) , Y(1) , Z (1) ,V_X (1) , V_Y (1) , V_Z (1),400,"filled",'-r','LineWidth' ,1.2 ,'MaxHeadSize',3) ;
    [R_peri ,~] = Param2rv (a,e,i,OM ,om ,0);
    [R_apo ,~] = Param2rv (a,e,i,OM ,om ,pi);
    plot3 ([ R_peri(1) ,R_apo(1) ],[ R_peri(2),R_apo(2) ],[ R_peri(3) ,R_apo(3)],'-.b','LineWidth',1,'Color',markerColors (j, :)); % semi - major axis
    
    if(j==numberOrbits | j==1)
         if(j==numberOrbits)
            maneuvPoint = plot3 (X (end) , Y(end) , Z(end) ,'d','MarkerSize', 10 ,'MarkerEdgeColor', markerColors (j+1, :) ,'MarkerFaceColor', markerColors (j+1, :));
         end
        numTh = round (abs(2*pi )/0.1);
        th_v = linspace (0 ,2*pi , numTh );
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
    
        V_min = min(V);
        V_max = max(V);
        V_span = V_max-V_min;
    
        cmapDim = 256;
        cmap = parula ( cmapDim );
    
        for k = 2: length (th_v)
                
            cmapIndex = floor ( ( cmapDim -1) * (V(k)-V_min )/ V_span ) + 1;
            stepColor = cmap ( cmapIndex ,:) ;
            plot3(X(k -1: k), Y(k -1: k), Z(k -1: k),'--' ,'Color', stepColor );
        end
%         for k = 2: length ( th_v )
%             
%             cmapIndex = floor((cmapDim -1)*(V(k)-V_min )/ V_span ) + 1
%             stepColor = cmap ( cmapIndex ,:) 
%             [R,V] = Param2rv ( a, e, i, OM, om, th_v(k));
%             R (:,k) = R;
%             V (:,k) = V;
%             plot3(X(k -1: k), Y(k -1: k), Z(k -1: k),'--','Color',stepColor) 
%         
%         end
     
        %plot3(RR(1,:),RR(2,:),RR(3,:),'--','Color',markerColors (j, :))    
    end

    
    

end
