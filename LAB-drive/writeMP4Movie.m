function writeMP4Movie ( theMovie , fileName )

global tLast ;
global myMovie ;
global playAfterCapture ;
global fps;

if length ( theMovie ) > 1
writerObj = VideoWriter ( fileName , 'MPEG -4 ');
writerObj . Quality = 100;
writerObj . FrameRate = fps;

open ( writerObj );

writeVideo ( writerObj , theMovie );
disp ( sprintf ('%s was written ', writerObj . Filename ))
close ( writerObj );


if playAfterCapture
fig = figure ; % create new figure for playing the movie
movie (fig , theMovie ,2)
end

else
warning ('ERROR writing movie !')
end

end