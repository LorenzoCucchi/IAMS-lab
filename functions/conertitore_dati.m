clear all
close all
clc

load dataA24.mat

[PF.r,PF.v] = Param2rv(PF.a,PF.e,PF.i,PF.OM,PF.om,PF.theta,398600.44)
i = rad2deg(wrapTo2Pi(PF.i))
OM = rad2deg(wrapTo2Pi(PF.OM))
om = rad2deg(wrapTo2Pi(PF.om))
theta = rad2deg(wrapTo2Pi(PF.theta))

p = PF.a*(1-PF.e.^2)
T = minutes(seconds(2*pi*sqrt(PF.a^3/398600.44)))

eps= (norm(PF.v)^2)/2-398600.44/norm(PF.r)



% p = 9928.6 Km  T = 165.0305 min  eps = -19.9973
% p = 1.4724e+04 T = 335.3763 min  eps = -12.4641

