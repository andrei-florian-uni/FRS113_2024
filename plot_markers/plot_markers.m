% import the data file
data_table = readtable('./data/markers.csv');

% Extract latitude and longitude
latitudes = data_table{:, 2}
longitudes = data_table{:, 3}

% plot the latitude longitude pairs on a graph
plot(longitudes, latitudes, 'o');
xlabel('Longitude');
ylabel('Latitude');
title('Latitude and Longitude of Markers');
grid on;
axis image;