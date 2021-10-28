function [ th_peri_i , th_peri_f ] = choosePeriChangeAngle (th_peri_i_vect , th_peri_f_vect , th_PC )

% Let us chose the nearest point for performing the PeriArgChange maneuver
% ( there is no difference in terms of DeltaV --> we willchoose the first point we encounter )

th_1 = wrapTo2Pi ( th_peri_i_vect (1));
th_2 = wrapTo2Pi ( th_peri_i_vect (2));
th_PC = wrapTo2Pi ( th_PC );

dist1 = th_1 - th_PC ;
dist2 = th_2 - th_PC ;

if ( dist1 < dist2 )
chosenTh = 1;
if ( dist1 * dist2 < 0) && th_1 <pi && th_PC >= pi % particular case
chosenTh = 2;

end
else
chosenTh = 2;
if ( dist1 * dist2 < 0) && th_2 <pi && th_PC >= pi % particular case
chosenTh = 1;
end
end


th_peri_i = th_peri_i_vect ( chosenTh );
th_peri_f = th_peri_f_vect ( chosenTh );

end