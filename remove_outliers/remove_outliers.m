% read the input data
data_table = readtable('./data/nassau hall.csv');

% extract the latitude and longitude
lat = table2array(data_table(:, 1));
lon = table2array(data_table(:, 2));

% calculate the standard deviation of the latitude and longitude
std_lat = std(lat);
std_lon = std(lon);

% calculate the mean of the latitude and longitude
mean_lat = mean(lat);
mean_lon = mean(lon);

% define one std
lat_range = [mean_lat - 0.5 * std_lat, mean_lat + 0.5 * std_lat];
lon_range = [mean_lon - 0.5 * std_lon, mean_lon + 0.5 * std_lon];

% filter the latitude and longitude values within one std
valid_indices = (lat >= lat_range(1) & lat <= lat_range(2)) & (lon >= lon_range(1) & lon <= lon_range(2));
filtered_lat = lat(valid_indices);
filtered_lon = lon(valid_indices);

% create a table with the filtered latitude and longitude
filtered_data_table = table(filtered_lat, filtered_lon, 'VariableNames', {'Latitude', 'Longitude'});

% write the filtered data to a new CSV file
writetable(filtered_data_table, './data/filtered_nassau_hall.csv');

% print the number of outliers removed
num_outliers = sum(~valid_indices);
fprintf('Number of outliers removed: %d\n', num_outliers);