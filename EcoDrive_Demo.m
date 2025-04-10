%% EcoDriveDemo.m
% This demo file illustrates the usage of the EcoDrive system.
% It first launches the EcoDriveApp GUI and then calls the backend
% function with sample inputs to display the trip report and reward status.

%% Option 1: Launch the GUI App
disp('Launching EcoDriveApp GUI...');
app = EcoDriveApp;
pause(2);  % Pause briefly to allow the GUI to open

%% Option 2: Backend Function Demo
disp('Running backend demo with sample inputs...');
newf=var(h-1)%10
% Define sample input parameters
start_coords = [9.981, 76.299];  % e.g. Mumbai (latitude, longitude)
end_coords   = [10.527, 76.214];   % e.g. Navi Mumbai (latitude, longitude)
vehicle_type = 'gasoline';
vehicle_load = 100;                 % in kg
ac_usage     = true;
vehicle_cc   = 1500;                % Engine CC
vehicle_age  = 10;                  % in years
tire_pressure = 30;                 % PSI
road_type    = 'city';

% Call the backend function
[trip_report, reward_status] = EcoDrive_Advanced_Backend(...
    start_coords, end_coords, vehicle_type, vehicle_load, ac_usage, ...
    vehicle_cc, vehicle_age, tire_pressure, road_type);

% Display the results in the Command Window
fprintf('\n--- Trip Report ---\n');
disp(trip_report);
fprintf('\n--- Reward Status ---\n');
disp(reward_status);
