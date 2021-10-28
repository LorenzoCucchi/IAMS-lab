function [] = writeCSVData ( fileName , DeltaV , Deltat )

fileName = sprintf (" strategyCSV /%s. csv", fileName );


DeltaV = round ([ DeltaV ; NaN ; sum ( DeltaV )], 4); % rounded to 4 decimals (i.e. format short )
% NaN in order to match Deltat  s size
Deltat = round ([ Deltat ; sum ( Deltat )]);

rowNames = {};
for i = 1: length ( DeltaV ) -1
rowNames {i ,1} = sprintf ('$%d$ ', i);
end
rowNames {i+1 ,1} = 'Total ';

T = table (DeltaV , Deltat , 'RowNames ',rowNames )


writetable (T, fileName ,'Delimiter ',',',' QuoteStrings ',true , 'WriteRowNames ', true )

end