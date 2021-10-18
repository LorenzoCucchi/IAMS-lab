load('dataA24.mat')



startTime = datetime(2020,6,02,8,23,0);
stopTime = startTime + hours(1);
sampleTime = 240;
sc = satelliteScenario(startTime,stopTime,sampleTime);
sat = satellite(sc, [(PI.a)*1000 (PF.a)*1000 (PI.a)*1000 (TO(3).a_2)*1000], [PI.e PF.e PI.e TO(3).e_2], [rad2deg(PI.i) rad2deg(PF.i) rad2deg(PF.i) rad2deg(PF.i)], [rad2deg(PI.OM) rad2deg(PF.OM) rad2deg(PF.OM) rad2deg(PF.OM)], [rad2deg(PI.om) rad2deg(PF.om) rad2deg(TO(1).om_f) rad2deg(PF.om)], [rad2deg(PI.theta) rad2deg(PF.theta) rad2deg(TO(1).theta_2) 180])
% show(sat)
satelliteScenarioViewer(sc, 'CameraReferenceFrame','Inertial');
groundTrack(sat,'LeadTime',3600)