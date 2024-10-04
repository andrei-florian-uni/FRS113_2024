% read the input data
class_sample = readtable('./data/utm.csv');
individual_sample = readtable('./data/utm_individual.csv');

% Define markers
markers = [9, 4, 5, 8, 2, 1];

% Initialize arrays to store errors
northing_errors = zeros(length(markers), 1);
easting_errors = zeros(length(markers), 1);
altitude_errors = zeros(length(markers), 1);

for i = 1:length(markers)
    marker = markers(i);
    
    % Extract individual and class data for the current marker
    individual_marker = individual_sample(individual_sample.marker == marker, :);
    class_marker = class_sample(class_sample.marker == marker, :);
    
    % Calculate northing for individual and class
    individual_northing = table2array(individual_marker(1, 2)) + table2array(individual_marker(1, 4)) * cos(deg2rad(table2array(individual_marker(1, 5))));
    class_northing = mean(table2array(class_marker(:, 2))) + mean(table2array(class_marker(:, 4))) * cos(deg2rad(mean(table2array(class_marker(:, 5)))));
    
    % Calculate easting for individual and class
    individual_easting = table2array(individual_marker(1, 3)) + table2array(individual_marker(1, 4)) * sin(deg2rad(table2array(individual_marker(1, 5))));
    class_easting = mean(table2array(class_marker(:, 3))) + mean(table2array(class_marker(:, 4))) * sin(deg2rad(mean(table2array(class_marker(:, 5)))));

    % Calculate altitude for individual and class
    individual_altitude = table2array(individual_marker(1, 6));
    class_altitude = mean(table2array(class_marker(:, 6)));
    
    % Store errors
    northing_errors(i) = abs(individual_northing - class_northing);
    easting_errors(i) = abs(individual_easting - class_easting);
    altitude_errors(i) = abs(individual_altitude - class_altitude);
end

% Display errors
disp('Northing Errors:');
disp(northing_errors);

disp('Easting Errors:');
disp(easting_errors);

disp('Altitude Errors:');
disp(altitude_errors);

disp('Number of Readings');
disp(size(table2array(class_sample(:, 1)), 1));