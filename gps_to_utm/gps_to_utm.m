% read the input data
origin = readtable('./data/origin.csv');

% create two matrices to store the GPS coordinates
marker = table2array(origin(:, 1));
lat = table2array(origin(:, 2));
lng = table2array(origin(:, 3));
gps_horizontal_offset = table2array(origin(:, 4));
gps_horizontal_offset_heading = table2array(origin(:, 5));
marker_height_laser = table2array(origin(:, 6));

% convert the latitude and longitude to UTM
[northing, easting, zone] = deg2utm(lat, lng);

% create a csv file with columns for the marker name, UTM x and UTM y
if isequal(size(marker, 1), size(northing, 1), size(easting, 1), size(gps_horizontal_offset, 1), size(gps_horizontal_offset_heading, 1), size(marker_height_laser, 1))
    % create a csv file with columns for the marker name, UTM x and UTM y
    output = table(marker, northing, easting, gps_horizontal_offset, gps_horizontal_offset_heading, marker_height_laser, 'VariableNames', {'marker', 'northing', 'easting', 'gps_horizontal_offset', 'gps_horizontal_offset_heading', 'marker_height_laser'});

    % write the output to a csv file
    writetable(output, './data/utm.csv');
else
    error('All variables must have the same number of rows.');
end