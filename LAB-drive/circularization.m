function [ DeltaV1 , DeltaV2 , DeltaV , Deltat , a_t , e_t] =circularization (ai , ei , af , ef , type , mu)

switch lower ( type )
    case {'p'}
        % raggio pericentro orbita circolare
        r_p = ai *(1 - ei);
        % raggio apocentro orbita circolare uguale a quello del pericentro
        r_a = r_p ;
        % semiasse maggiore orbita di trasferimento
        a_t = r_p ;
        % variazioni di velocita  , calcolte invertendo la formula dell ’ energia
        DeltaV1 = abs ( (mu *((2/ r_p) -(1/ a_t ))) ^(1/2) - (mu*((2/ r_p ) -(1/ ai))) ^(1/2) );
        DeltaV2 = abs ( (mu *((2/ r_a) -(1/ af))) ^(1/2) - (mu *((2/r_a ) -(1/ a_t ))) ^(1/2) );
        % l  intervallo di tempo e’ la meta ’ del periodo dell ’ orbita di trasferimento
        Deltat = pi *( a_t ^3/ mu) ^(1/2) ;
    case {'a'}
        % raggio apocentro orbita circolare
        r_a = ai *(1+ ei);
        % raggio pericentro orbita circolare uguale a quello
        % dell ’ apocentro
        r_p = r_a ;
        % semiasse maggiore orbita circolare
        a_t = r_a ;
        % variazioni di velocita  , calcolate invertendo la formula dell   energia
        DeltaV1 = abs ( (mu *((2/ r_p) -(1/ a_t ))) ^(1/2) - (mu*((2/ r_p ) -(1/ ai))) ^(1/2) );
        DeltaV2 = abs ( (mu *((2/ r_a) -(1/ af))) ^(1/2) - (mu *((2/r_a ) -(1/ a_t ))) ^(1/2) );
        Deltat = pi *( a_t ^3/ mu) ^(1/2) ;
    otherwise
        error ('ERROR ');
end

e_t = 0;

DeltaV = DeltaV1 + DeltaV2 ;

end