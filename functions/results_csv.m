function [results]=results_csv(results)

results(:,3)=rad2deg(wrapTo2Pi(results(:,3)));
results(:,4)=rad2deg(wrapTo2Pi(results(:,4)));
results(:,5)=rad2deg(wrapTo2Pi(results(:,5)));
results(:,6)=rad2deg(wrapTo2Pi(results(:,6)));
results(:,7)=rad2deg(wrapTo2Pi(results(:,7)));
results(end,12)=minutes(seconds(results(end,12)));
end