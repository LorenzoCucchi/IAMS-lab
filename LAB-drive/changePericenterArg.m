function [ DeltaV , thi , thf ] = changePericenterArg (a, e, om_i ,om_f , mu)


if nargin == 4
    mu = 398600.44;
end

Deltaom = abs(om_f - om_i );
thi1 = Deltaom /2;
thi2 = pi + Deltaom /2;

thf1 = 2* pi - Deltaom /2;
thf2 = pi - Deltaom /2;

p = a*(1 -e^2);

DeltaV = 2 * sqrt (mu/p) * e * abs( sin ( Deltaom /2));


thi = [ thi1 thi2 ]';
thf = [ thf1 thf2 ]';




end