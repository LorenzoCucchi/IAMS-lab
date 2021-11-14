load('dataA24.mat')



startTime = datetime(2020,6,02,8,23,0);
stopTime1 = startTime + days(1);

sampleTime = 240;
sc = satelliteScenario(startTime,stopTime1,sampleTime);
sat = satellite(sc,[PI.a*1000 PF.a*1000],[PI.e PF.e],[rad2deg(PI.i) rad2deg(PF.i)],[rad2deg(PI.OM) rad2deg(PF.OM)],[rad2deg(PI.om) rad2deg(PF.om)],[rad2deg(PI.theta) rad2deg(PF.theta)])
show(sat)
satelliteScenarioViewer(sc, 'CameraReferenceFrame','Inertial');
groundTrack(sat,'LeadTime',3600)