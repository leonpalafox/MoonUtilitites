function analyse_tables()
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

%Justin coefficients for azimuth
p = [-0.2351872E3, 0.37950896, 0.1014440E-4 0.22247458E-7 0.15622115E-10]; %Azimuth
%p = [0.84794585E02, -0.3620392, 0.37836857E-5, -0.24882907E-10, 0.23784397E-7];%Elevation
p_1 = fliplr(p);
p_2 = [-0.2351872E3, 0.37950896, 0.1014440E-4 0.22247458E-7 0.15622115E-10 0];
p_3 = [p_1 0];
p2 = polyfit(azimuth_table{:,1}, azimuth_table{:,3},5);
%p2 = polyfit(elevation_table{:,1}, elevation_table{:,3},5);
x1 = 0:0.01:1;
y1 = polyval(p,x1);
y2 = polyval(p2,x1);
y_1 = polyval(p_1, x1);
y_2 = polyval(p_2, x1);
y_3 = polyval(p_3, x1);
%plot values in table
h = plot(x1,y1,'o');
hold on
set(h,'MarkerEdgeColor',[255, 0 ,0]/255,'MarkerFaceColor',[255, 193 ,193]/255)
h = plot(x1,y2,'o');
hold on
set(h,'MarkerEdgeColor',[0, 255 ,0]/255,'MarkerFaceColor',[193, 255 ,193]/255)
h = plot(x1,y_1,'o');
hold on
set(h,'MarkerEdgeColor',[0, 0 ,0]/255,'MarkerFaceColor',[193, 193 ,193]/255)
h = plot(x1,y_2,'o');
hold on
set(h,'MarkerEdgeColor',[0, 193 ,193]/255,'MarkerFaceColor',[148, 193 ,193]/255)
h = plot(x1,y_3,'o');
hold on
set(h,'MarkerEdgeColor',[0, 0 ,255]/255,'MarkerFaceColor',[193, 193 ,255]/255)


plot(azimuth_table{:,1}, azimuth_table{:,3})
%plot(elevation_table{:,1}, elevation_table{:,3})
legend('Justin Polynomial No affine','Calculated Polynomial','Flipped Polynomial No affine' ,'Flipped Affine','Justin Affine' ,'Real Data')
title('Polynomials for the Azimuth table')

%had to change the 18 to 28

%had to change 54 to 59
%had to change 7551 to 7651
