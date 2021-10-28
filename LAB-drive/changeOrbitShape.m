function [ DeltaV , om_t , th_t , a_t] = changeOrbitShape (a_i ,e_i , i_i , OM_i , om_i , i_f , OM_f , e_t , mu)

DeltaOM = OM_f - OM_i ;
Deltai = i_f - i_i ;

if DeltaOM *Deltai >0
    alpha = acos (cos( i_i )*cos ( i_f) + sin( i_i )*sin( i_f )* cos (DeltaOM ));
    cosu1 = -( cos (i_f)-cos( alpha )* cos (i_i))/( sin( alpha )* sin (i_i ));
    cosu2 = ( cos (i_i)-cos ( alpha )*cos ( i_f))/( sin( alpha )* sin (i_f ));
    sinu1 = sin ( DeltaOM )/sin( alpha )* sin (i_f );
    sinu2 = sin ( DeltaOM )/sin( alpha )* sin (i_i );
    u1 = atan2 (sinu1 , cosu1 );
    u2 = atan2 (sinu2 , cosu2 );
    th_t = u1 - om_i ;
    om_t = u2 - th_t ;
else
    alpha = acos (cos( i_i )*cos ( i_f) + sin( i_i )*sin( i_f )* cos (DeltaOM ));
    cosu1 = (cos (i_f)-cos ( alpha )*cos ( i_i))/( sin( alpha )* sin (i_i ));
    cosu2 = -( cos (i_i)-cos( alpha )* cos (i_f))/( sin( alpha )* sin (i_f ));
    sinu1 = sin ( DeltaOM )/sin( alpha )* sin (i_f );
    sinu2 = sin ( DeltaOM )/sin( alpha )* sin (i_i );
    u1 = atan2 (sinu1 , cosu1 );
    u2 = atan2 (sinu2 , cosu2 );
    th_t = 2* pi - (u1 + om_i );
    om_t = 2* pi - (u2 + th_t );
end

p_i = a_i *(1 - e_i ^2);
p_t = p_i *(1+ e_t ) /(1+ e_i *cos( th_t ));
a_t = p_t /(1 - e_t ^2);

om_t = om_i + th_t ;
[~, v_i ] = par2car (a_i ,e_i ,i_i ,OM_i ,om_i ,th_t , mu);
[~, v_t ] = par2car (a_t ,e_t ,i_i ,OM_i ,om_t ,0, mu);


DeltaV = sqrt ( norm ( v_i)^2 + norm (v_t)^2 - 2* dot (v_i , v_t ));

end