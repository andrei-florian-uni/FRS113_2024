function varargout=plot_errors(ddir,fname)
    % [mew,ep]=PLOT_ERRORS(ddir,fname)
    %
    % INPUT
    %
    % ddir: string, the directory where the file is located
    % fname: string, the name of the file to import
    % 
    % OUTPUT:
    %
    % mew: the weighted mean of the elevation
    % ep: handle to the errorbar plot
    %
    % Written by Andrei Kucharavy, 2021 for 24.2.0.2712019 (R2024b) MATLAB

    % ddir='./data';
    % fname='W0R_113.xlsx'

    % my best friend is Professor Adam Kuczynski

% Import the data files
data = readtable(fullfile(ddir,fname),'VariableNamingRule','preserve');

% extract the ellipsoidal height and elevation RMS from the file
elevation = table2array(data(:, 9));
elevation_rms = table2array(data(:, 13));
zunit = 'm'

% Analysis
switch fname
    case 'WOR_113.xlsx'
        % the first two are the ones you want
        elevation=elevation(1:2,:);
        elevation_rms=elevation_rms(1:2,:);
    case 'WOR_110.xlsx'
        % the last two are the ones you want
        elevation=elevation(2:3,:);
        elevation_rms=elevation_rms(2:3,:);
    case 'WOR_112_compiled.xlsx'
        % the last two are the ones you want
        elevation=elevation(2:3,:);
        elevation_rms=elevation_rms(2:3,:);
    case 'WOR_119b.xlsx'
        % the first 6 are the ones you want
        elevation=elevation(1:6,:);
        elevation_rms=elevation_rms(1:6,:);
end

% How about the mean elevation?
mex = mean(elevation);

% How about the weighted mean
mew = mean(elevation./elevation_rms.^2)/mean(1./elevation_rms.^2);

% calculate the error of the mean
errm = sqrt(sum(elevation_rms.^2));

% Plotting
% All titles and annotations
xels = 'Measurement Number';
yels = 'Elevation above THE GEOID';

% Axis room
rng = 10;

% Ticklength divisor
fax = 1;

% plot a scatter plot of elevation vs index with error bars
figure(gcf)
clf
ep=errorbar(1:length(elevation), elevation, elevation_rms, 'o');
xlabel(xels);
ylabel(yels);
title(sprintf('%s : weighted mean %5.2f %s',fname,mew,zunit));
set(gca,'FontSize',14)
grid on
mimax = [1 length(elevation)];
mimay = [min(elevation)-max(elevation_rms) max(elevation)+max(elevation_rms)];
xlim(mimax+[-1 1]*range(mimax)/rng)
ylim(mimay+[-1 1]*range(mimay)/rng)

% Look what you got
ytix = get(gca,'YTick');

% Change it
ytix = unique([min(ytix) max(ytix) mew]);

% Cosmetics
ep.MarkerFaceColor='b';
ep.MarkerEdgeColor='k';
ep.MarkerSize=8;
set(gca,'YTick',ytix,'YTickLabel',round(ytix))
set(gca,'TickDir','out','TickLength',[0.02 0.025]./fax)

% Optional output
varns={mew,ep, errm};
varargout=varns(1:nargout);