% import the data
all_markers = readtable('./data/all_markers.csv');
my_markers = readtable('./data/my_markers.csv');

% Extract latitude and longitude from both tables and store them in arrays
all_latitudes = table2array(all_markers(:, 2));
all_longitudes = table2array(all_markers(:, 3));
my_latitudes = table2array(my_markers(:, 2));
my_longitudes = table2array(my_markers(:, 3));

% convert from lat lon to UTM
[all_x, all_y] = deg2utm(all_latitudes, all_longitudes);
[my_x, my_y] = deg2utm(my_latitudes, my_longitudes);

% define a range for the search in meters
range = 200;

% Create a matrix to store all rows from the first column of my_markers in the first row
my_markers_matrix = repmat(my_markers{:, 1}', 1, 1);

% Initialize an empty cell array to store the matching markers
matching_markers = {};

% Loop through each row in my_x and my_y
for i = 1:length(my_x)
    % Calculate the distance from the current my_marker to all all_markers
    distances = sqrt((all_x - my_x(i)).^2 + (all_y - my_y(i)).^2);
    
    % Find indices of all_markers that are within the specified range
    within_range_indices = find(distances <= range);
    
    % Store the matching markers
    if ~isempty(within_range_indices)
        matching_markers{i} = all_markers{within_range_indices, 1};
    else
        matching_markers{i} = [];
    end
end

% Display the matching markers
disp(matching_markers);

% Convert the cell array to a table
matching_markers_table = cell2table(matching_markers');

% Use the first row of my_markers as column names
matching_markers_table.Properties.VariableNames = my_markers.Properties.VariableNames(1);

% Write the table to a CSV file
writetable(matching_markers_table, './matching_markers.csv');