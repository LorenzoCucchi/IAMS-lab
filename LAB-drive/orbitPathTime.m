function [ Deltat ] = orbitPathTime (a,e,mu ,th_1 , th_2 )

th_1 = wrapTo2Pi ( th_1 );
th_2 = wrapTo2Pi ( th_2 );
if th_2 <= th_1 % the ’=’ sign involves the case in which th0== thf ( convention : last path to plot , i.e. full orbit toplay )
th_2 = th_2 + 2* pi;
end
tt = theta2t (a,e,mu ,0 ,[ th_1 , th_2 ]);
Deltat = tt(end );

end