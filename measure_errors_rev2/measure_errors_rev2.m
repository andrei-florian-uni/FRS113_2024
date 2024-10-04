%% setup
% read the input data
data_table = readtable('./data/utm.csv');

% Define markers
markers = [9, 4, 5, 8, 2, 1];

% Initialize arrays to store results
northings = [];
eastings = [];
altitudes = [];

%% Calculate values for each marker
for i = 1:length(markers)
    marker = markers(i);
    
    % Extract data for the current marker
    current_marker = data_table(data_table.marker == marker, :);
    
    % Initialize structure to store results for the current marker
    results(i).marker = marker;
    results(i).northings = [];
    results(i).eastings = [];
    results(i).altitudes = [];
    
    % Iterate through each reading for the current marker and calculate the corrected values
    for j = 1:height(current_marker)
        northing = table2array(current_marker(j, 2)) + table2array(current_marker(j, 4)) * cos(deg2rad(table2array(current_marker(j, 5))));
        easting = table2array(current_marker(j, 3)) + table2array(current_marker(j, 4)) * sin(deg2rad(table2array(current_marker(j, 5))));
        altitude = table2array(current_marker(j, 6));
        
        % Append results to structure arrays
        results(i).northings = [results(i).northings; northing];
        results(i).eastings = [results(i).eastings; easting];
        results(i).altitudes = [results(i).altitudes; altitude];
    end
end

%% Calculate mean and standard deviation for each marker
for i = 1:length(markers)
    northings_mean(i) = mean(results(i).northings);
    northings_std(i) = std(results(i).northings);
    
    eastings_mean(i) = mean(results(i).eastings);
    eastings_std(i) = std(results(i).eastings);
    
    altitudes_mean(i) = mean(results(i).altitudes);
    altitudes_std(i) = std(results(i).altitudes);
end

%% Display and export the results
disp('Mean and Standard Deviation for each marker:');
for i = 1:length(markers)
    fprintf('Marker %d:\n', markers(i));
    fprintf('  Northings - Mean: %.2f, Std: %.2f\n', northings_mean(i), northings_std(i));
    fprintf('  Eastings - Mean: %.2f, Std: %.2f\n', eastings_mean(i), eastings_std(i));
    fprintf('  Altitudes - Mean: %.2f, Std: %.2f\n', altitudes_mean(i), altitudes_std(i));
end

% Create a table to store the results
results_table = table(markers', northings_mean', northings_std', eastings_mean', eastings_std', altitudes_mean', altitudes_std', ...
    'VariableNames', {'Marker', 'Northings_Mean', 'Northings_Std', 'Eastings_Mean', 'Eastings_Std', 'Altitudes_Mean', 'Altitudes_Std'});

% Write the table to a CSV file
writetable(results_table, './data/results.csv');

disp('Number of Readings');
disp(size(table2array(data_table(:, 1)), 1));