%% setup
% read the input data
data_table = readtable('./data/nassau hall.csv');

[easting,northing]=deg2utm(data_table.Latitude,data_table.Longitude);

% Calculate the standard deviation of easting and northing
std_easting = std(easting);
std_northing = std(northing);

% Display the results
fprintf('Standard Deviation of Easting: %.2f meters\n', std_easting);
fprintf('Standard Deviation of Northing: %.2f meters\n', std_northing);