function [ DeltaV , omf , th_PC ] = changeOrbitalPlane (a, e, i_i ,OM_i , om_i , i_f , OM_f , mu)
% Change of Plane maneuver

DeltaOM = OM_f - OM_i ;
Deltai = i_f - i_i ;

if DeltaOM *Deltai >0
    alpha = acos (cos( i_i )*cos ( i_f) + sin( i_i )*sin( i_f )* cos (DeltaOM ));
    cosu1 = -( cos (i_f)-cos( alpha )* cos (i_i))/( sin( alpha )* sin (i_i ));
    cosu2 = (cos (i_i)-cos ( alpha )*cos ( i_f))/( sin( alpha )* sin (i_f ));
    sinu1 = sin ( DeltaOM )/sin( alpha )* sin (i_f );
    sinu2 = sin ( DeltaOM )/sin( alpha )* sin (i_i );
    u1 = atan2 (sinu1 , cosu1 );
    u2 = atan2 (sinu2 , cosu2 );
    th_PC = u1 - om_i ;
    omf = u2 - th_PC ;
else
    alpha = acos (cos( i_i )*cos ( i_f) + sin( i_i )*sin( i_f )* cos (DeltaOM ));
    cosu1 = (cos (i_f)-cos ( alpha )*cos ( i_i))/( sin( alpha )* sin (i_i ));
    cosu2 = -( cos (i_i)-cos( alpha )* cos (i_f))/( sin( alpha )* sin (i_f ));
    sinu1 = sin ( DeltaOM )/sin( alpha )* sin (i_f );
    sinu2 = sin ( DeltaOM )/sin( alpha )* sin (i_i );
    u1 = atan2 (sinu1 , cosu1 );
    u2 = atan2 (sinu2 , cosu2 );
    th_PC = 2* pi - (u1 + om_i );
    omf = 2* pi - (u2 + th_PC );
end

if cos( th_PC ) > 0
    % since there are two intersections , it means that the one that we have
    % found has the highest v_theta -> we choose the specular intersection
    th_PC = th_PC + pi;
end

p = a*(1 -e^2);
v_theta = sqrt (mu/p) *(1+ e*cos( th_PC ));

DeltaV = 2* v_theta *sin ( alpha /2) ;

end