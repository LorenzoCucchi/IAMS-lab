function [ DeltaV1 , DeltaV2 , DeltaV , Deltat , a_t , e_t ,periApoInvTrue ] = bitangentTransfer (ai , ei , af , ef , type ,mu)

switch lower ( type )
    case {’pa ’}
        % Temporary values of:
        % raggio pericentro orbita di trasferimento
        r_p_tmp = ai *(1 - ei);
        % raggio apocentro orbita di trasferimento
        r_a_tmp = af *(1+ ef); 
        r_a = max ( r_p_tmp , r_a_tmp );
        r_p = min ( r_p_tmp , r_a_tmp );
        
        % semiasse maggiore orbita di trasferimento
        a_t = ( r_a +r_p) /2;
        % variazioni di velocita  , calcolte invertendo la formula dell ’ energia
        DeltaV1 = abs ( (mu *((2/ r_p) -(1/ a_t ))) ^(1/2) - (mu*((2/ r_p ) -(1/ ai))) ^(1/2) );
        DeltaV2 = abs ( (mu *((2/ r_a) -(1/ af))) ^(1/2) - (mu *((2/r_a ) -(1/ a_t ))) ^(1/2) );
        % l’ intervallo di tempo e’ la meta ’ del periodo dell ’
        
        Deltat = pi *( a_t ^3/ mu) ^(1/2) ;
    case {’ap ’}
        r_p_tmp = af *(1 - ef);
        r_a_tmp = ai *(1+ ei);
        r_a = max ( r_p_tmp , r_a_tmp );
        r_p = min ( r_p_tmp , r_a_tmp );
        
        a_t = ( r_a +r_p) /2;
        DeltaV1 = abs ( (mu *((2/ r_p) -(1/ a_t ))) ^(1/2) - (mu*((2/ r_p ) -(1/ ai))) ^(1/2) );
        DeltaV2 = abs ( (mu *((2/ r_a) -(1/ af))) ^(1/2) - (mu *((2/r_a ) -(1/ a_t ))) ^(1/2) );
        Deltat = pi *( a_t ^3/ mu) ^(1/2) ;
    case {’pp ’}
        r_p_tmp = ai *(1 - ei);
        r_a_tmp = af *(1 - ef);
        r_a = max ( r_p_tmp , r_a_tmp );
        r_p = min ( r_p_tmp , r_a_tmp );
        
        a_t = ( r_a +r_p) /2;
        DeltaV1 = abs ( (mu *((2/ r_p) -(1/ a_t ))) ^(1/2) - (mu*((2/ r_p ) -(1/ ai))) ^(1/2) );
        DeltaV2 = abs ( (mu *((2/ r_a) -(1/ af))) ^(1/2) - (mu *((2/r_a ) -(1/ a_t ))) ^(1/2) );
        Deltat = pi *( a_t ^3/ mu) ^(1/2) ;
    case {’aa ’}
        r_p_tmp = ai *(1+ ei);
        r_a_tmp = af *(1+ ef);
        r_a = max ( r_p_tmp , r_a_tmp );
        r_p = min ( r_p_tmp , r_a_tmp );
        
        a_t = ( r_a +r_p) /2;
        DeltaV1 = abs ( (mu *((2/ r_p) -(1/ a_t ))) ^(1/2) - (mu*((2/ r_p ) -(1/ ai))) ^(1/2) );
        DeltaV2 = abs ( (mu *((2/ r_a) -(1/ af))) ^(1/2) - (mu *((2/r_a ) -(1/ a_t ))) ^(1/2) );
        Deltat = pi *( a_t ^3/ mu) ^(1/2) ;
    otherwise
        error (’ERRORE ’);

end

if r_p_tmp > r_a_tmp

    periApoInvTrue = 1;
    warning (’Peri <-> Apo Inversion !’)

else

    periApoInvTrue = 0;

end


% eccentricity ’
e_t = (r_a -r_p)/( r_a+ r_p );

DeltaV = DeltaV1 + DeltaV2 ;


end