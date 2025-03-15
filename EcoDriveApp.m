classdef EcoDriveApp < matlab.apps.AppBase
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        
        % Main layout
        MainGrid               matlab.ui.container.GridLayout
        
        % Panels
        InputPanel             matlab.ui.container.Panel
        ResultsPanel           matlab.ui.container.Panel
        
        % Sub-grids
        InputGrid              matlab.ui.container.GridLayout
        ResultsGrid            matlab.ui.container.GridLayout
        
        % Trip & Vehicle Inputs
        StartLatLabel          matlab.ui.control.Label
        StartLatEditField      matlab.ui.control.NumericEditField
        
        StartLonLabel          matlab.ui.control.Label
        StartLonEditField      matlab.ui.control.NumericEditField
        
        EndLatLabel            matlab.ui.control.Label
        EndLatEditField        matlab.ui.control.NumericEditField
        
        EndLonLabel            matlab.ui.control.Label
        EndLonEditField        matlab.ui.control.NumericEditField
        
        % New: Vehicle Class (Bike/Car/Bus)
        VehicleClassLabel      matlab.ui.control.Label
        VehicleClassDropDown   matlab.ui.control.DropDown
        
        % Fuel Type
        VehicleTypeLabel       matlab.ui.control.Label
        VehicleTypeDropDown    matlab.ui.control.DropDown
        
        VehicleLoadLabel       matlab.ui.control.Label
        VehicleLoadEditField   matlab.ui.control.NumericEditField
        
        VehicleCCLabel         matlab.ui.control.Label
        VehicleCCEditField     matlab.ui.control.NumericEditField
        
        VehicleAgeLabel        matlab.ui.control.Label
        VehicleAgeEditField    matlab.ui.control.NumericEditField
        
        TirePressureLabel      matlab.ui.control.Label
        TirePressureEditField  matlab.ui.control.NumericEditField
        
        RoadTypeLabel          matlab.ui.control.Label
        RoadTypeDropDown       matlab.ui.control.DropDown
        
        ACUsageCheckBox        matlab.ui.control.CheckBox
        
        % Basemap Selection
        MapTypeLabel           matlab.ui.control.Label
        MapTypeDropDown        matlab.ui.control.DropDown
        
        % New: Email ID (for rewards)
        EmailIDLabel           matlab.ui.control.Label
        EmailIDEditField       matlab.ui.control.EditField
        
        CalculateButton        matlab.ui.control.Button
        CollectRewardsButton   matlab.ui.control.Button
        GenerateCodeButton     matlab.ui.control.Button
        ViewGoogleMapsButton   matlab.ui.control.Button  % Renamed with an emoji
        
        FooterLabel            matlab.ui.control.Label
        
        % Results Components
        MapAxes                matlab.graphics.axis.GeographicAxes
        ResultsTextArea        matlab.ui.control.TextArea
        DownloadReportButton   matlab.ui.control.Button
        ShowTipsButton         matlab.ui.control.Button
        ShowGraphsButton       matlab.ui.control.Button
    end
    
    properties (Access = private)
        LastEcoTips        cell
        LastTripReport     = []
        LastRewardPoints   = 0
    end
    
    methods (Access = private)
        
        function createComponents(app)
            %% -- Main Figure --
            app.UIFigure = uifigure('Name', 'EcoDrive Pro',...
                'Position', [100 100 1000 600], 'Color', [0.98 0.98 0.98]);
            
            %% -- Main Grid (1×2) --
            app.MainGrid = uigridlayout(app.UIFigure, [1,2]);
            app.MainGrid.ColumnWidth = {300, '1x'};
            app.MainGrid.RowHeight   = {'1x'};
            
            %% ============================
            %  LEFT PANEL: Trip Configuration
            %% ============================
            app.InputPanel = uipanel(app.MainGrid, ...
                'Title', 'Trip Configuration', ...
                'FontSize', 14, ...
                'FontName', 'Segoe UI Semibold', ...
                'BackgroundColor', [1 1 1], ...
                'BorderColor', [0.85 0.85 0.85]);
            app.InputPanel.Layout.Row = 1;
            app.InputPanel.Layout.Column = 1;
            
            % 19-row grid for inputs
            app.InputGrid = uigridlayout(app.InputPanel, [19,2]);
            app.InputGrid.RowHeight = repmat("fit",1,19);
            app.InputGrid.ColumnWidth = {120, '1x'};
            
            % OPTIONAL: Force some row heights for the 4 main buttons to
            % make them appear more "square." Let's set row 15..18 to 80 px:
            app.InputGrid.RowHeight{15} = 80;
            app.InputGrid.RowHeight{16} = 80;
            app.InputGrid.RowHeight{17} = 80;
            app.InputGrid.RowHeight{18} = 80;
            
            % Row 1: Start Lat
            app.StartLatLabel = uilabel(app.InputGrid, 'Text', "🌐 Start Lat");
            app.StartLatLabel.Layout.Row = 1; 
            app.StartLatLabel.Layout.Column = 1;
            app.StartLatEditField = uieditfield(app.InputGrid, 'numeric', 'Value', 13.08);
            app.StartLatEditField.Layout.Row = 1; 
            app.StartLatEditField.Layout.Column = 2;
            
            % Row 2: Start Lon
            app.StartLonLabel = uilabel(app.InputGrid, 'Text', "🌐 Start Lon");
            app.StartLonLabel.Layout.Row = 2;
            app.StartLonLabel.Layout.Column = 1;
            app.StartLonEditField = uieditfield(app.InputGrid, 'numeric', 'Value', 80.27);
            app.StartLonEditField.Layout.Row = 2;
            app.StartLonEditField.Layout.Column = 2;
            
            % Row 3: End Lat
            app.EndLatLabel = uilabel(app.InputGrid, 'Text', "🎯 End Lat");
            app.EndLatLabel.Layout.Row = 3;
            app.EndLatLabel.Layout.Column = 1;
            app.EndLatEditField = uieditfield(app.InputGrid, 'numeric', 'Value', 9.931);
            app.EndLatEditField.Layout.Row = 3;
            app.EndLatEditField.Layout.Column = 2;
            
            % Row 4: End Lon
            app.EndLonLabel = uilabel(app.InputGrid, 'Text', "🎯 End Lon");
            app.EndLonLabel.Layout.Row = 4;
            app.EndLonLabel.Layout.Column = 1;
            app.EndLonEditField = uieditfield(app.InputGrid, 'numeric', 'Value', 76.26);
            app.EndLonEditField.Layout.Row = 4;
            app.EndLonEditField.Layout.Column = 2;
            
            % Row 5: Vehicle Class
            app.VehicleClassLabel = uilabel(app.InputGrid, 'Text', "🛻 Vehicle Class");
            app.VehicleClassLabel.Layout.Row = 5;
            app.VehicleClassLabel.Layout.Column = 1;
            app.VehicleClassDropDown = uidropdown(app.InputGrid, ...
                'Items', {'Bike','Car','Bus'}, 'Value', 'Car');
            app.VehicleClassDropDown.Layout.Row = 5;
            app.VehicleClassDropDown.Layout.Column = 2;
            
            % Row 6: Fuel Type
            app.VehicleTypeLabel = uilabel(app.InputGrid, 'Text', "🚘 Fuel Type");
            app.VehicleTypeLabel.Layout.Row = 6;
            app.VehicleTypeLabel.Layout.Column = 1;
            app.VehicleTypeDropDown = uidropdown(app.InputGrid, ...
                'Items', {'gasoline','diesel','electric'}, 'Value', 'gasoline');
            app.VehicleTypeDropDown.Layout.Row = 6;
            app.VehicleTypeDropDown.Layout.Column = 2;
            
            % Row 7: Load (kg)
            app.VehicleLoadLabel = uilabel(app.InputGrid, 'Text', "📦 Load (kg)");
            app.VehicleLoadLabel.Layout.Row = 7;
            app.VehicleLoadLabel.Layout.Column = 1;
            app.VehicleLoadEditField = uieditfield(app.InputGrid, 'numeric', 'Value', 100);
            app.VehicleLoadEditField.Layout.Row = 7;
            app.VehicleLoadEditField.Layout.Column = 2;
            
            % Row 8: Engine CC
            app.VehicleCCLabel = uilabel(app.InputGrid, 'Text', "🏎️ Engine CC");
            app.VehicleCCLabel.Layout.Row = 8;
            app.VehicleCCLabel.Layout.Column = 1;
            app.VehicleCCEditField = uieditfield(app.InputGrid, 'numeric', 'Value', 1500);
            app.VehicleCCEditField.Layout.Row = 8;
            app.VehicleCCEditField.Layout.Column = 2;
            
            % Row 9: Vehicle Age
            app.VehicleAgeLabel = uilabel(app.InputGrid, 'Text', "📅 Age (yrs)");
            app.VehicleAgeLabel.Layout.Row = 9;
            app.VehicleAgeLabel.Layout.Column = 1;
            app.VehicleAgeEditField = uieditfield(app.InputGrid, 'numeric', 'Value', 10);
            app.VehicleAgeEditField.Layout.Row = 9;
            app.VehicleAgeEditField.Layout.Column = 2;
            
            % Row 10: Tire PSI
            app.TirePressureLabel = uilabel(app.InputGrid, 'Text', "🌀 Tire PSI");
            app.TirePressureLabel.Layout.Row = 10;
            app.TirePressureLabel.Layout.Column = 1;
            app.TirePressureEditField = uieditfield(app.InputGrid, 'numeric', 'Value', 30);
            app.TirePressureEditField.Layout.Row = 10;
            app.TirePressureEditField.Layout.Column = 2;
            
            % Row 11: Road Type
            app.RoadTypeLabel = uilabel(app.InputGrid, 'Text', "🛣️ Road Type");
            app.RoadTypeLabel.Layout.Row = 11;
            app.RoadTypeLabel.Layout.Column = 1;
            app.RoadTypeDropDown = uidropdown(app.InputGrid, ...
                'Items', {'highway','city','mixed'}, 'Value', 'highway');
            app.RoadTypeDropDown.Layout.Row = 11;
            app.RoadTypeDropDown.Layout.Column = 2;
            
            % Row 12: AC Usage
            app.ACUsageCheckBox = uicheckbox(app.InputGrid, 'Text', '❄️ AC Usage', 'Value', true);
            app.ACUsageCheckBox.Layout.Row = 12;
            app.ACUsageCheckBox.Layout.Column = [1 2];
            
            % Row 13: Map Type
            app.MapTypeLabel = uilabel(app.InputGrid, 'Text', "🗺️ Map Type");
            app.MapTypeLabel.Layout.Row = 13;
            app.MapTypeLabel.Layout.Column = 1;
            app.MapTypeDropDown = uidropdown(app.InputGrid, ...
                'Items', {'streets','satellite','topographic','streets-dark'}, 'Value', 'streets');
            app.MapTypeDropDown.Layout.Row = 13;
            app.MapTypeDropDown.Layout.Column = 2;
            app.MapTypeDropDown.ValueChangedFcn = @(dd,event) switchBasemap(app);
            
            % Row 14: Email ID
            app.EmailIDLabel = uilabel(app.InputGrid, 'Text', "✉️ Email ID");
            app.EmailIDLabel.Layout.Row = 14;
            app.EmailIDLabel.Layout.Column = 1;
            app.EmailIDEditField = uieditfield(app.InputGrid, 'text');
            app.EmailIDEditField.Layout.Row = 14;
            app.EmailIDEditField.Layout.Column = 2;
            
            % Row 15: Calculate Button (🚀 + Square-ish shape)
            app.CalculateButton = uibutton(app.InputGrid, 'push', ...
                'Text', '🚀 Calculate Impact', ...
                'FontSize', 14, 'FontName', 'Segoe UI Semibold', ...
                'FontColor', [1 1 1], 'BackgroundColor', [0.25 0.65 0.45], ...
                'ButtonPushedFcn', @(btn,evnt) CalculateButtonPushed(app));
            app.CalculateButton.Layout.Row = 15;
            app.CalculateButton.Layout.Column = [1 2];
            
            % Row 16: Collect Rewards Button (💰 + Square-ish shape)
            app.CollectRewardsButton = uibutton(app.InputGrid, 'push', ...
                'Text', '💰 Collect Rewards', ...
                'FontSize', 14, 'FontName', 'Segoe UI Semibold', ...
                'FontColor', [1 1 1], 'BackgroundColor', [0.7 0.3 0.3], ...
                'ButtonPushedFcn', @(btn,evnt) CollectRewardsButtonPushed(app));
            app.CollectRewardsButton.Layout.Row = 16;
            app.CollectRewardsButton.Layout.Column = [1 2];
            
            % Row 17: Generate Code Button (🔑 + Square-ish shape)
            app.GenerateCodeButton = uibutton(app.InputGrid, 'push', ...
                'Text', '🔑 Generate Code', ...
                'FontSize', 14, 'FontName', 'Segoe UI Semibold', ...
                'FontColor', [1 1 1], 'BackgroundColor', [0.4 0.6 0.4], ...
                'ButtonPushedFcn', @(btn,evnt) GenerateCodeButtonPushed(app));
            app.GenerateCodeButton.Layout.Row = 17;
            app.GenerateCodeButton.Layout.Column = [1 2];
            
            % Row 18: View in Google Maps Button (📍 + Square-ish shape)
            app.ViewGoogleMapsButton = uibutton(app.InputGrid, 'push', ...
                'Text', '📍 View in Google Maps', ...
                'FontSize', 14, 'FontName', 'Segoe UI Semibold', ...
                'FontColor', [1 1 1], 'BackgroundColor', [0.3 0.3 0.8], ...
                'ButtonPushedFcn', @(btn,evnt) ViewInGoogleMapsButtonPushed(app));
            app.ViewGoogleMapsButton.Layout.Row = 18;
            app.ViewGoogleMapsButton.Layout.Column = [1 2];
            
            % Row 19: Footer Label
            app.FooterLabel = uilabel(app.InputGrid, 'Text', "EcoDrive App © 2025", ...
                'HorizontalAlignment', 'center');
            app.FooterLabel.Layout.Row = 19;
            app.FooterLabel.Layout.Column = [1 2];
            
            %% ============================
            %  RIGHT PANEL: Analytics & Visualization
            %% ============================
            app.ResultsPanel = uipanel(app.MainGrid, ...
                'Title', 'Analytics & Visualization', ...
                'FontSize', 14, 'FontName', 'Segoe UI Semibold', ...
                'BackgroundColor', [1 1 1], 'BorderColor', [0.85 0.85 0.85]);
            app.ResultsPanel.Layout.Row = 1;
            app.ResultsPanel.Layout.Column = 2;
            
            % 5-row grid for results
            app.ResultsGrid = uigridlayout(app.ResultsPanel, [5,1]);
            app.ResultsGrid.RowHeight = {'3x', '1x', 'fit', 'fit', 'fit'};
            app.ResultsGrid.ColumnWidth = {'1x'};
            
            % Row 1: Map area (geoaxes)
            app.MapAxes = geoaxes(app.ResultsGrid);
            app.MapAxes.Layout.Row = 1;
            app.MapAxes.Layout.Column = 1;
            geobasemap(app.MapAxes, app.MapTypeDropDown.Value);
            title(app.MapAxes, 'Route Visualization');
            
            % Row 2: Results TextArea
            app.ResultsTextArea = uitextarea(app.ResultsGrid);
            app.ResultsTextArea.Layout.Row = 2;
            app.ResultsTextArea.Layout.Column = 1;
            app.ResultsTextArea.FontName = 'Courier New';
            app.ResultsTextArea.FontSize = 12;
            app.ResultsTextArea.Value = '📈 Waiting for calculation...';
            
            % Row 3: Download Report Button
            app.DownloadReportButton = uibutton(app.ResultsGrid, 'push', ...
                'Text', 'Download Report', ...
                'FontSize', 14, 'FontName', 'Segoe UI Semibold', ...
                'FontColor', [1 1 1], 'BackgroundColor', [0.2 0.6 0.8], ...
                'ButtonPushedFcn', @(btn,evnt) DownloadReportButtonPushed(app));
            app.DownloadReportButton.Layout.Row = 3;
            app.DownloadReportButton.Layout.Column = 1;
            
            % Row 4: Show Tips Button
            app.ShowTipsButton = uibutton(app.ResultsGrid, 'push', ...
                'Text', 'Show Tips', ...
                'FontSize', 14, 'FontName', 'Segoe UI Semibold', ...
                'FontColor', [1 1 1], 'BackgroundColor', [0.5 0.4 0.6], ...
                'ButtonPushedFcn', @(btn,evnt) ShowTipsButtonPushed(app));
            app.ShowTipsButton.Layout.Row = 4;
            app.ShowTipsButton.Layout.Column = 1;
            
            % Row 5: Show Graphs Button
            app.ShowGraphsButton = uibutton(app.ResultsGrid, 'push', ...
                'Text', 'Show Graphs', ...
                'FontSize', 14, 'FontName', 'Segoe UI Semibold', ...
                'FontColor', [1 1 1], 'BackgroundColor', [0.3 0.5 0.9], ...
                'ButtonPushedFcn', @(btn,evnt) ShowGraphsButtonPushed(app));
            app.ShowGraphsButton.Layout.Row = 5;
            app.ShowGraphsButton.Layout.Column = 1;
        end
        
        %% --- Calculate Button ---
        function CalculateButtonPushed(app, ~, ~)
            dlg = uiprogressdlg(app.UIFigure, 'Title', 'Please Wait', ...
                'Message', 'Performing calculations...', 'Indeterminate', 'on');
            drawnow;
            
            start_coords  = [app.StartLatEditField.Value, app.StartLonEditField.Value];
            end_coords    = [app.EndLatEditField.Value,   app.EndLonEditField.Value];
            vehicle_class = app.VehicleClassDropDown.Value;
            vehicle_type  = app.VehicleTypeDropDown.Value;
            vehicle_load  = app.VehicleLoadEditField.Value;
            ac_usage      = app.ACUsageCheckBox.Value;
            vehicle_cc    = app.VehicleCCEditField.Value;
            vehicle_age   = app.VehicleAgeEditField.Value;
            tire_pressure = app.TirePressureEditField.Value;
            road_type     = app.RoadTypeDropDown.Value;
            
            try
                [trip_report, reward_status] = EcoDrive_Advanced_Backend(...
                    start_coords, end_coords, vehicle_class, vehicle_type, vehicle_load, ...
                    ac_usage, vehicle_cc, vehicle_age, tire_pressure, road_type);
                close(dlg);
                
                startStr = sprintf('(%.4f, %.4f)', start_coords(1), start_coords(2));
                endStr   = sprintf('(%.4f, %.4f)', end_coords(1), end_coords(2));
                
                resultLines = { ...
                    '===== EcoDrive Trip Report ====='; ...
                    ['Start:  ' startStr]; ...
                    ['End:    ' endStr]; ...
                    ''; ...
                    sprintf('Distance: %.2f km', trip_report.Distance_km); ...
                    sprintf('CO2 Emissions: %.2f kg', trip_report.CO2_Emissions_kg); ...
                    sprintf('Driving Score: %d / 100', trip_report.Driving_Score); ...
                    sprintf('Reward Points: %d', reward_status.Reward_Points); ...
                    '================================='};
                
                app.ResultsTextArea.BackgroundColor = [0.9 1.0 0.9];
                app.ResultsTextArea.FontColor       = [0.0 0.2 0.0];
                app.ResultsTextArea.Value           = resultLines;
                
                % Store eco tips
                if iscell(reward_status.Eco_Tips)
                    app.LastEcoTips = reward_status.Eco_Tips;
                elseif ischar(reward_status.Eco_Tips)
                    app.LastEcoTips = {reward_status.Eco_Tips};
                elseif isnumeric(reward_status.Eco_Tips)
                    app.LastEcoTips = {num2str(reward_status.Eco_Tips)};
                else
                    app.LastEcoTips = cellstr(string(reward_status.Eco_Tips));
                end
                app.LastTripReport = trip_report;
                app.LastRewardPoints = reward_status.Reward_Points;
                
                % Plot route with animation
                app.plot_route_on_map(trip_report.RouteLat, trip_report.RouteLon);
                
            catch ME
                close(dlg);
                app.ResultsTextArea.BackgroundColor = [1.0 0.9 0.9];
                app.ResultsTextArea.FontColor       = [0.6 0 0];
                app.ResultsTextArea.Value           = {['Error: ' ME.message]};
            end
        end
        
        %% --- Collect Rewards Button ---
        function CollectRewardsButtonPushed(app, ~, ~)
            if isempty(app.LastTripReport)
                uialert(app.UIFigure, 'No trip data available. Please calculate first!', 'No Data');
                return;
            end
            
            emailID = app.EmailIDEditField.Value;
            if isempty(emailID)
                uialert(app.UIFigure, 'Please enter a valid Email ID to collect rewards.', 'Input Error');
                return;
            end
            
            points = app.LastRewardPoints;
            msg = sprintf('Reward Points %d have been transferred to %s.', points, emailID);
            uialert(app.UIFigure, msg, 'Rewards Collected');
        end
        
        %% --- Generate Code Button (Send OTP) ---
        function GenerateCodeButtonPushed(app, ~, ~)
            emailID = app.EmailIDEditField.Value;
            if isempty(emailID)
                uialert(app.UIFigure, 'Please enter a valid Email ID to generate code.', 'Input Error');
                return;
            end
            
            otp = randi([100000,999999]);
            
            % Configure Gmail SMTP settings (update with your real app password)
            setpref('Internet','E_mail','ecodrive2k25@gmail.com');
            setpref('Internet','SMTP_Server','smtp.gmail.com');
            setpref('Internet','SMTP_Username','ecodrive2k25@gmail.com');
            setpref('Internet','SMTP_Password','wwgequnztzevrjxm');  % Your App Password
            
            props = java.lang.System.getProperties;
            props.setProperty('mail.smtp.auth','true');
            props.setProperty('mail.smtp.socketFactory.port','465');
            props.setProperty('mail.smtp.socketFactory.class','javax.net.ssl.SSLSocketFactory');
            props.setProperty('mail.smtp.socketFactory.fallback','false');
            props.setProperty('mail.smtp.port','465');
            
            subject = 'Your EcoDrive OTP Code';
            message = sprintf('Your OTP for EcoDrive rewards is: %d', otp);
            
            try
                sendmail(emailID, subject, message);
                uialert(app.UIFigure, 'OTP code sent to your email successfully.', 'Email Sent');
            catch ME
                uialert(app.UIFigure, ['Failed to send OTP: ' ME.message], 'Email Error');
            end
        end
        
        %% --- View in Google Maps Button ---
        function ViewInGoogleMapsButtonPushed(app, ~, ~)
            startLat = app.StartLatEditField.Value;
            startLon = app.StartLonEditField.Value;
            endLat   = app.EndLatEditField.Value;
            endLon   = app.EndLonEditField.Value;
            
            url = sprintf('https://www.google.com/maps/dir/%f,%f/%f,%f', ...
                startLat, startLon, endLat, endLon);
            web(url, '-browser');
        end
        
        %% --- Plot Route with Animated Vehicle ---
        function plot_route_on_map(app, latArray, lonArray)
            cla(app.MapAxes);
            hold(app.MapAxes, 'on');
            
            % Choose an emoji based on Vehicle Class
            switch app.VehicleClassDropDown.Value
                case 'Bike'
                    vehicleEmoji = "🏍️";
                case 'Car'
                    vehicleEmoji = "🚗";
                case 'Bus'
                    vehicleEmoji = "🚌";
                otherwise
                    vehicleEmoji = "🚗";
            end
            
            % Plot the route
            geoplot(app.MapAxes, latArray, lonArray, ...
                'LineWidth', 3, 'LineStyle', '--', 'Color', 'blue');
            
            % Start marker
            markerSize = 120;
            geoscatter(app.MapAxes, latArray(1), lonArray(1), ...
                markerSize, 'red', 'd', 'filled');
            text(app.MapAxes, latArray(1), lonArray(1), "🚩", ...
                'FontSize', 24, 'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle');
            
            % Animate the vehicle
            N = length(latArray);
            hVehicle = text(app.MapAxes, latArray(1), lonArray(1), vehicleEmoji, ...
                'FontSize', 24, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
            decelStart = floor(0.8 * N);
            
            % Constant speed
            for k = 1:decelStart
                set(hVehicle, 'Position', [latArray(k), lonArray(k), 0]);
                pause(0.001);
                drawnow;
            end
            % Deceleration
            for k = decelStart+1:N
                frac = (k - decelStart) / (N - decelStart);
                t = 0.001 + (0.005 - 0.001)*frac;
                set(hVehicle, 'Position', [latArray(k), lonArray(k), 0]);
                pause(t);
                drawnow;
            end
            delete(hVehicle);
            
            % End marker
            geoscatter(app.MapAxes, latArray(end), lonArray(end), ...
                markerSize, 'green', 'p', 'filled');
            text(app.MapAxes, latArray(end), lonArray(end), "🏁", ...
                'FontSize', 24, 'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle');
            
            % Adjust map limits
            minLat = min(latArray);
            maxLat = max(latArray);
            minLon = min(lonArray);
            maxLon = max(lonArray);
            geolimits(app.MapAxes, [minLat - 0.01, maxLat + 0.01], ...
                                  [minLon - 0.01, maxLon + 0.01]);
            
            hold(app.MapAxes, 'off');
            drawnow;
        end
        
        %% --- Download Report Callback ---
        function DownloadReportButtonPushed(app, ~, ~)
            dlg = uiprogressdlg(app.UIFigure, ...
                'Title', 'Downloading File', ...
                'Message', 'Please wait...', ...
                'Indeterminate', 'on');
            drawnow;
            
            reportText = app.ResultsTextArea.Value;
            if iscell(reportText)
                reportText = strjoin(reportText, newline);
            end
            [file, path] = uiputfile({'*.txt','Text Files (*.txt)'}, 'Save Report As');
            if isequal(file, 0) || isequal(path, 0)
                close(dlg);
                return;
            end
            fullFileName = fullfile(path, file);
            
            fid = fopen(fullFileName, 'w');
            if fid == -1
                close(dlg);
                uialert(app.UIFigure, 'Unable to open file for writing.', 'File Error');
                return;
            end
            fprintf(fid, '%s', reportText);
            fclose(fid);
            close(dlg);
            uialert(app.UIFigure, 'Report saved successfully.', 'Success');
        end
        
        %% --- Show Tips Callback ---
        function ShowTipsButtonPushed(app, ~, ~)
            if isempty(app.LastEcoTips)
                uialert(app.UIFigure, 'No eco tips available. Please calculate first!', 'No Tips');
                return;
            end
            
            msg = "Eco-Friendly Driving Tips:" + newline + newline;
            for i = 1:numel(app.LastEcoTips)
                msg = msg + "- " + app.LastEcoTips{i} + newline;
            end
            uialert(app.UIFigure, msg, 'Eco Tips');
        end
        
        %% --- Show Graphs Callback ---
        function ShowGraphsButtonPushed(app, ~, ~)
            if isempty(app.LastTripReport)
                uialert(app.UIFigure, 'No trip data available. Please calculate first!', 'No Data');
                return;
            end
            
            trip_report = app.LastTripReport;
            
            % Create a new figure with a 2x2 grid
            fig = uifigure('Name', 'EcoDrive Additional Graphs', ...
                'Position', [150 150 900 600]);
            gl = uigridlayout(fig, [2,2]);
            gl.RowHeight = {'1x','1x'};
            gl.ColumnWidth = {'1x','1x'};
            
            % Subplot 1: Speed vs Time
            ax1 = uiaxes(gl);
            ax1.Layout.Row = 1;
            ax1.Layout.Column = 1;
            timeVec = trip_report.DrivingData.time;
            speedVec = trip_report.DrivingData.speed;
            plot(ax1, timeVec, speedVec, 'b-', 'LineWidth', 1.5);
            title(ax1, 'Speed vs Time');
            xlabel(ax1, 'Time (s)');
            ylabel(ax1, 'Speed (km/h)');
            
            % Subplot 2: Acceleration vs Time
            ax2 = uiaxes(gl);
            ax2.Layout.Row = 1;
            ax2.Layout.Column = 2;
            accelVec = trip_report.DrivingData.acceleration;
            plot(ax2, timeVec, accelVec, 'r-', 'LineWidth', 1.5);
            title(ax2, 'Acceleration vs Time');
            xlabel(ax2, 'Time (s)');
            ylabel(ax2, 'Accel (m/s^2)');
            
            % Subplot 3: Bar chart summary
            ax3 = uiaxes(gl);
            ax3.Layout.Row = 2;
            ax3.Layout.Column = 1;
            categories = {'Distance (km)', 'CO2 (kg)', 'Score'};
            values = [trip_report.Distance_km, ...
                      trip_report.CO2_Emissions_kg, ...
                      trip_report.Driving_Score];
            bar(ax3, categorical(categories), values);
            title(ax3, 'Trip Summary');
            ylabel(ax3, 'Value');
            
            % Subplot 4: Speed vs Distance
            ax4 = uiaxes(gl);
            ax4.Layout.Row = 2;
            ax4.Layout.Column = 2;
            cumDist = zeros(size(timeVec));
            for i = 2:numel(timeVec)
                delta = speedVec(i)/3600;  % convert km/h -> km/s
                cumDist(i) = cumDist(i-1) + delta;
            end
            plot(ax4, cumDist, speedVec, 'g-o', 'LineWidth', 1.2);
            title(ax4, 'Speed vs Distance');
            xlabel(ax4, 'Distance (km)');
            ylabel(ax4, 'Speed (km/h)');
        end
        
        %% --- Switch Basemap ---
        function switchBasemap(app)
            newMap = app.MapTypeDropDown.Value;
            geobasemap(app.MapAxes, newMap);
        end
    end
    
    methods (Access = public)
        function app = EcoDriveApp
            createComponents(app);
            app.UIFigure.Visible = 'on';
        end
    end
end
