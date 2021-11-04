load('dataA24.mat')



startTime = datetime(2020,6,02,8,23,0);
stopTime1 = startTime + days(1);

sampleTime = 240;
sc = satelliteScenario(startTime,stopTime1,sampleTime);
sat = satellite(sc,[PI.a*1000 PI.a*1000],[PI.e PI.e],[rad2deg(PI.i) rad2deg(PI.i)],[rad2deg(PI.OM) rad2deg(PI.OM)],[rad2deg(PI.om) rad2deg(TO(1).om_f)],[rad2deg(PI.theta) rad2deg(TO(1).theta_2)])
show(sat2)
satelliteScenarioViewer(sc2, 'CameraReferenceFrame','Inertial');
groundTrack(sat,'LeadTime',3600)