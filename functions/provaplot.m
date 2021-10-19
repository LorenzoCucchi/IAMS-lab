load('dataA24.mat')



startTime = datetime(2020,6,02,8,23,0);
stopTime1 = startTime + seconds(TO(1).delta_time(2));
stopTime2 = stopTime1 + seconds(TO(2).delta_time(2));
stopTime3 = stopTime2 + seconds(TO(3).delta_time(1));
stopTime2 = stopTime3 + seconds(TO(3).delta_time(2));

sampleTime = 240;
sc = satelliteScenario(startTime,stopTime1,sampleTime);
sc2 = satelliteScenario(stopTime1,stopTime2,sampleTime);
%sat = satellite(sc,[PI.a*1000 PI.a*1000],[PI.e PI.e],[rad2deg(PI.i) rad2deg(PI.i)],[rad2deg(PI.OM) rad2deg(PI.OM)],[rad2deg(PI.om) rad2deg(TO(1).om_f)],[rad2deg(PI.theta) rad2deg(TO(1).theta_2)])
sat = satellite(sc,PI.a*1000,PI.e,rad2deg(PI.i),rad2deg(PI.OM),rad2deg(PI.om),rad2deg(PI.theta))
sat2 = satellite(sc2,PI.a*1000,PI.e,rad2deg(PI.i),rad2deg(PI.OM),r,rad2deg(TO(1).theta_2))
show(sat2)
satelliteScenarioViewer(sc2, 'CameraReferenceFrame','Inertial');
groundTrack(sat,'LeadTime',3600)