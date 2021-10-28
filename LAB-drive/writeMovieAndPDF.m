function writeMovieAndPDF ( strategyName )

global captureMovie
global myFig ;
global myMovie ;
global createPDF ;

%% WRITE MOVIE
if captureMovie
writeMP4Movie ( myMovie , sprintf ('strategyMovie /%s. mp4 ',strategyName ));
end

if createPDF
%% WRITE PDF
resizePDFPaper
print (myFig , sprintf (" strategyPDF /%s", strategyName ), '-dpdf ')
end

end