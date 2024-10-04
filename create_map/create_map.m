% Clear all variables
clear

% Clear the current figure axis
clf

% Load the geodetic benchmark data, one example
NH=readtable('./data/nassau hall.csv');
lNH='Nassau Hall';

% So now those are ONLY for Nassau Hall
[xNH,yNH]=deg2utm(NH.Latitude,NH.Longitude);

disp(xNH);
disp(yNH);

% Load the control line data, one example
CL=readtable('./data/control line.csv');

% Convert degrees to UTM
[xCL,yCL]=deg2utm(CL.latitude,CL.longitude);

% Do one of the regressions
lCL=polyfit(xCL,yCL,1);
yyCL=polyval(lCL,xCL);

% Load the plaques data, one example
% Everyone's structure is slightly different, so experiment!!
FM=readtable('./data/height markers.csv');

% Convert degrees to UTM
xFM = FM.northing;
yFM = FM.easting;

% Find out what you really want to plot
props=fieldnames(FM);

% The 8th one is 'marker_height_above_ground_lazer'
zprop=props{6};
zFM=FM.(zprop);

% But that has underscores in it so we take those out for the title
tzprop=zprop; tzprop(find(abs(zprop)==95))=' ';

% Decide on a list of symbols
symbs={'v','s','^','o','<','d','>','p','h'};
cols={'r','b','g','m','c','y','k','r','b'};

% Plot all the points on the graph
% Nassau Hall
pNH=plot(xNH,yNH,'o');

% Princeton orange and black!
pNH.MarkerFaceColor=[255 143 0]/255;
pNH.MarkerEdgeColor=[0 0 0];
hold on

% The control line
pCL=plot(xCL,yCL,'+');

% The plaques... "flood markers"
tofx=10; tofy=20;
for index=1:length(FM.name)
    pFM(index)=plot(xFM(index),yFM(index),symbs{index});
    pFM(index).MarkerFaceColor=cols{index};
    pFM(index).MarkerEdgeColor='k';
    % We are just going to plot whatever comes out as a number
    tFM(index)=text(xFM(index)+tofx,yFM(index),sprintf('%4.2f m',zFM(index)),...
                   'Color','b');
    % Here I am plotting another number, in case you make another point
    uFM(index)=text(xFM(index)+tofx,yFM(index)-tofy,sprintf('%4.2f m',FM.(props{9})(index)));
end

hold off

% Figure out what the axis is
axis tight
xls=xlim;
yls=ylim;

% Load and plot campus buildings as well
load buildings_reprojected
hold on
pCB=plot([b.X],[b.Y]);
hold off
pCB.Color=[0.7 0.7 0.7];

% Plot proper labels
xlabel(sprintf('easting [m] in UTM zone 18'))
ylabel(sprintf('northing [m] in UTM zone 18'))

% Cosmetics and cropping, add a margin to what you had
axis image
widn=100;
xlim(xls+[-1 1]*widn)
ylim(yls+[-1 1]*widn)
grid on
box on
set(gca,'TickDir','out','TickLength',[0.02 0.025]/2)

% Don't like the automatic exponent notation for UTM
%h=gca; h.XAxis.Exponent=1; h.YAxis.Exponent=1;

% Add a legend - type in the marker names
legs=legend(lNH,'Control Line',...
            'Plaque 4','Plaque 8','Plaque 9','Plaque 5',...
            'Plaque 1','plaque 2',...
            'Campus','Location','SouthWest');
set(legs,'AutoUpdate','off')

% Now ADD the mean of the NH locations, plus or minus 'xtim' times the
% standard deviation
xtim=2;
mNHx=mean(xNH);
sNHx=std(xNH);
mNHy=mean(yNH);
sNHy=std(yNH);
hold on
% Remember the offset!
pmsx=plot([mNHx-xtim*sNHx mNHx+xtim*sNHx],[mNHy mNHy],'y-');
pmsy=plot([mNHx mNHx],[mNHy-xtim*sNHy mNHy+xtim*sNHy],'y-');
set([pmsx pmsy],'LineWidth',2)
% Now add the regression line
pr=plot(xCL,yyCL,'r-');

hold off
tl=title(sprintf(...
    'Markers, Control Line, Plaques: Marker Height above Ground Rangefinder and Rod'));
% Move it up and across a tad
tl.Position=tl.Position+[widn/3 widn/5 0];

% Print to a PDF, remember to crop within LaTeX
print('L04_Fig1.pdf','-dpdf','-bestfit')