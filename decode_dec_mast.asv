function [az_value, elev_value] = decode_dec_mast(dec_mast)
%This function decodes the bcd using Johns tables
%file
filename = 'C:\Users\leon\Documents\Data\MoonData\SurveyorTables\Surveyor7_edited.csv';
lookup_table = readtable(filename,'ReadVariableNames',false);
%Azimuth 1:3
%extract azimuth
azimuth_table = lookup_table(:,2:4);
%cleanup table
tf = ismissing(azimuth_table);
azimuth_table = azimuth_table(~any(tf,2),:);
%Elevation 4:6
%extract elevation
elevation_table = lookup_table(:,8:10);
%cleanup table
tf = ismissing(elevation_table);
elevation_table = elevation_table(~any(tf,2),:);

%calibration_vals
calib_val = mean(dec_mast(:,6));
%initial_values
azimuth_val = dec_mast(2,3);
elevation_val = dec_mast(1,7);
iris_val = dec_mast(1,13);
focus_val = dec_mast(1,5);
filter_val = dec_mast(1, 10);


azimuth_lookup = azimuth_val/calib_val;
elevation_lookup = elevation_val/calib_val;
lookup_array_az = azimuth_table{:,{'Var2','Var4'}};
az_value = interp1(lookup_array_az(:,2),lookup_array_az(:,1), azimuth_lookup);
lookup_array_elev = elevation_table{:,{'Var5','Var8'}};
elev_value = interp1(lookup_array_elev(:,2),lookup_array_elev(:,1), elevation_lookup);


%had to change the 18 to 28

%had to change 54 to 59
%had to change 7551 to 7651
