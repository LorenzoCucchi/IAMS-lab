function [ DeltaV , DeltaV1 , DeltaV2 , DeltaV3 , a_T1 , a_T2 , e_T1, e_T2 ] = biellBitang (a_i , e_i , a_f , e_f , r_aT , mu)


r_p_i = a_i *(1 - e_i);
r_pT1 = r_p_i ;

r_p_f = a_f *(1 - e_f);
r_pT2 = r_p_f ;

isOk = 0;

a_T1 = ( r_pT1 + r_aT ) /2;
a_T2 = ( r_pT2 + r_aT ) /2;
e_T1 = (r_aT - r_pT1 )/( r_aT + r_pT1 );
e_T2 = (r_aT - r_pT2 )/( r_aT + r_pT2 );



DeltaV1 = sqrt (mu) * abs ( sqrt (2/ r_pT1 -1/ a_T1 ) - sqrt (2/r_p_i -1/ a_i ) );
DeltaV2 = sqrt (mu) * abs ( sqrt (2/ r_aT -1/ a_T2 ) - sqrt (2/r_aT -1/ a_T1 ) );
DeltaV3 = sqrt (mu) * abs ( sqrt (2/ r_p_f -1/ a_f ) - sqrt (2/r_pT2 -1/ a_T2 ) );

DeltaV = DeltaV1 + DeltaV2 + DeltaV3 ;

end