%% Making MS2 movie spot tracking plot with variable-length tracks

% Import CSV data (add comments for clarity)
[TableFile, TablePath] = uigetfile('.csv', 'Select tracking data CSV');
Trackingdata = readtable(strcat(TablePath, TableFile));


MaxTrackLength = [];
% Extract relevant columns
TrackID = Trackingdata.TRACK_ID;
Timepoint = Trackingdata.POSITION_T;
Maxintensity = Trackingdata.MAX_INTENSITY_CH1;
Meanintensity = Trackingdata.MEAN_INTENSITY_CH1;


% Find longest track

for i = 1:length(unique(TrackID))
  currentTrack = TrackID == i;
 
  TracksSortedTemp = [Timepoint(currentTrack), ...
                    Maxintensity(currentTrack), ...
                    Meanintensity(currentTrack)];
  TempTrackLength = size(TracksSortedTemp, 1);

   if isempty(MaxTrackLength)
        MaxTrackLength = TempTrackLength;

   elseif TempTrackLength >= MaxTrackLength

       MaxTrackLength = TempTrackLength;

   end
end




% Initialize empty cell array to store track data
AllTracksData = NaN(MaxTrackLength, 3, size(unique(TrackID), 1));

% Loop through each unique track ID

% ... code for preparing data as chunks ...

% Clear animated lines for future use
% clear animLines;
for i = 1:length(unique(TrackID))
  currentTrack = TrackID == i;

  % Extract and sort data for current track
  TracksSortedTemp = [Timepoint(currentTrack), ...
                    Maxintensity(currentTrack), ...
                    Meanintensity(currentTrack)];
  TracksSortedTemp = sortrows(TracksSortedTemp);

  % Append sorted data for this track to cell array
   AllTracksData(1:size(TracksSortedTemp, 1), :, i) = TracksSortedTemp;
   % animLine = animatedline('Color', colors(i,:), 'LineWidth', 2, 'Marker', '.', 'MarkerSize', 10);

end

% 

% 
% 
% animatedplot = figure('Name', 'Tracks', 'Position', [0 0 600 300]);
% hold on;
% 
% xlim([0 60]);
% ylim([1000 2000]);
% 
% xlabel('Time (minutes)');
% ylabel('Mean Intensity');
% 
% animLines = []; % Store animated line objects
for i = 1:length(unique(TrackID))
  currentTrack = TrackID == i;

  % Extract and sort data for current track
  TracksSortedTemp = [Timepoint(currentTrack), ...
                    Maxintensity(currentTrack), ...
                    Meanintensity(currentTrack)];
  TracksSortedTemp = sortrows(TracksSortedTemp);
  TracksSortedTemp(:, 1) =  TracksSortedTemp(:, 1) ./ 60;
%  animLine = animatedline('Color', colors(i,:), 'LineWidth', 2, 'Marker', '.', 'MarkerSize', 10);
% 
%  addpoints(animLine, TracksSortedTemp(:,1), TracksSortedTemp(:,2));
%     drawnow;
%     pause(1);
% 
% animLines = [animLines animLine];
  end

% hold off;

% exportgraphics(gcf,append(TablePath, filesep, "animatedplot ",".gif"),'Append',true);

% frames = getframe(gcf);

% Write frames to GIF using VideoWriter (may require Video Toolbox)
% writer = VideoWriter(append(TablePath, filesep, "animatedplot ",".gif"), 'GIF');
% open(writer);
% for i = 1:length(frames)
%   writeVideo(writer, frames(i).cdata);
% end
% close(writer);


% % Export as GIF with desired frame rate and quality
% export_fig(append(TablePath, filesep, "animatedplot ",".gif"), '-animated', '-fps', 20, '-quality', 100);

% Extract timepoints and max intensities from all tracks
allTimepoints = squeeze(AllTracksData(:, 1, :));
allMaxintensities = squeeze(AllTracksData(:, 2, :));
allMeanintensities = squeeze(AllTracksData(:, 3, :));
% Convert all timepoints to minutes directly using vectorized operations


% allTimepoints_minutes = bsxfun(@rdivide, allTimepoints, 60);
% allTimepoints = allTimepoints_minutes;
% Note: bsxfun applies ./ element-wise across corresponding elements


% Combine timepoints and intensities into a single structure (optional)
trackData = struct('timepoints', allTimepoints_minutes, 'maxintensities', allMaxintensities);


% Define colors for different tracks (optional)
colors = lines(size(allTimepoints, 2));

% Create the plot
CompoPlot = figure('Name', 'Tracks', 'Position', [0 0 600 300]);
tlcombo = tiledlayout(2, 1,'TileSpacing','tight');

nexttile

hold on
for i = 1:size(allTimepoints, 2)
  % Select non-NaN values for plotting (important!)
  validIndices = ~isnan(allTimepoints(:, i));
plot(allTimepoints(validIndices, i), allMaxintensities(validIndices, i), 'Color', colors(i,:), 'LineWidth', 2, 'Marker', '.', 'MarkerSize', 10);
 end
hold off;

% Label axes and add title
% xlabel('Time (minutes)');
ylabel('Max Intensity');
% title('Max Intensity');


xlim([0 60]);

% ylim([0 2000]);


nexttile

hold on
for i = 1:size(allTimepoints, 2)
  % Select non-NaN values for plotting (important!)
  validIndices = ~isnan(allTimepoints(:, i));
plot(allTimepoints(validIndices, i), allMeanintensities(validIndices, i), 'Color', colors(i,:), 'LineWidth', 2, 'Marker', '.', 'MarkerSize', 10);
 end
hold off;

% Label axes and add title
xlabel('Time (minutes)');
ylabel('Mean Intensity');
% title('Mean Intensity');

xlim([0 60]);



orient(gcf,'landscape');
saveas(gcf, append(TablePath, filesep, "TrackPlot ",".pdf"));

%% figure for a heatmap raw
% 
% % Assuming AllTracksData has dimensions [maxTrackLength x 3 x numTracks]
% % Transpose to arrange tracks as rows and timepoints as columns
% intensityData = permute(AllTracksData, [2 1 3]);
% % Select the second row (index 2) which contains max intensities
% intensityData = squeeze(intensityData(2,:,:)).';
% % Create a vector of track numbers
% numTracks = size(intensityData, 1);
% trackNums = (1:numTracks)';
% % Create a vector of time points
% numTimePoints = size(intensityData, 2);
% timePoints = (1:numTimePoints)';
% % Repeat the track numbers and time points for each cell
% trackNums = repmat(trackNums, 1, numTimePoints);
% timePoints = repmat(timePoints, numTracks, 1);
% % Reshape the data into column vectors
% trackNums = trackNums(:);
% timePoints = timePoints(:);
% intensityData = intensityData(:);
% % Remove the NaN values
% valid = ~isnan(intensityData);
% trackNums = trackNums(valid);
% timePoints = timePoints(valid);
% intensityData = intensityData(valid);
% % Convert the data into a table
% T = table(trackNums, timePoints, intensityData, ...
%     'VariableNames', {'Track', 'Time', 'MaxIntensity'});
% % Create a heat map from the table
% h = heatmap(T, 'Time', 'Track', 'ColorVariable', 'MaxIntensity');
% % Customize the appearance of the heat map
% h.Title = 'Heatmap of tracks';
% h.XLabel = 'Time (mins)';
% h.YLabel = 'Tracks';
% h.Colormap = parula;
% h.ColorLimits = [0 1800];
% h.MissingDataColor = 'none';
% h.GridVisible = 'off';
% % Save the heat map as a PDF file
% saveas(gcf, append(TablePath, filesep, "heatmap sorted tracks ",".pdf"));
% 
% 
% % % Assuming AllTracksData has dimensions [maxTrackLength x 3 x numTracks]
% % % Transpose to arrange tracks as rows and timepoints as columns
% % intensityData1 = permute(AllTracksData, [2 1 3]);
% % 
% % % Select the second row (index 2) which contains max intensities
% % intensityDatatime = squeeze(intensityData1(1,:,:));
% % intensityData1 = squeeze(intensityData1(2,:,:));
% % 
% % 
% % % Assuming your matrix is named 'data'
% % [~, colsToRemove] = find(all(isnan(intensityData1)));
% % intensityData1(:, colsToRemove) = [];
% % intensityDatatime(:, colsToRemove) = [];
% % 
% % intensityData1 = permute(intensityData1, [2 1]);
% % intensityDatatime = permute(intensityDatatime, [2 1]);
% % 
% % 
% % % Assuming your data is in a matrix called 'intensityData'
% % figure;
% % try
% %     imagesc('x', intensityDatatime, 'C', intensityData1); % Create the heatmap image
% % end
% % 
% % colorbar; % Add a colorbar to explain intensity values
% % 
% % % Customize appearance (optional)
% % xlabel('Time (mins)');
% % ylabel('Tracks');
% % title('Heatmap of tracks');
% % colormap(parula); % Set the desired colormap
% % colorbar;
% % clim([0 1800])
% % % xlim([0 25])
% % % 
% % % ylim([0 50])
% % 
% % set(gca, 'Color', 'None')
% % 
% % saveas(gcf, append(TablePath, filesep, "heatmap sorted tracks ",".pdf"));

%% figure for a heatmap sorted

% Assuming AllTracksData has dimensions [maxTrackLength x 3 x numTracks]
% Transpose to arrange tracks as rows and timepoints as columns
intensityData = permute(AllTracksData, [2 1 3]);

% Select the second row (index 2) which contains max intensities
intensityData = squeeze(intensityData(2,:,:));

% Assuming your matrix is named 'data'
[~, colsToRemove] = find(all(isnan(intensityData)));
intensityData(:, colsToRemove) = [];

intensityData = permute(intensityData, [2 1]);

[Sumorgnaised OrderofIntensities] = sort(sum(isnan(intensityData), 2, 'omitnan'), 'descend');
intensityData = intensityData(OrderofIntensities.', :);


% Assuming your data is in a matrix called 'intensityData'
figure;
try
    imagesc(0:0.5:(size(intensityData, 2)/2), ...
    0:1:size(intensityData, 2),...
    intensityData, [2 1]); % Create the heatmap image
end

colorbar; % Add a colorbar to explain intensity values

% Customize appearance (optional)
xlabel('Time (mins)');
ylabel('Tracks');
title('Heatmap of Sortedtracks');
colormap(parula); % Set the desired colormap
colorbar;
clim([0 100])
% xlim([0 25])
% 
% ylim([0 50])

set(gca, 'Color', 'None')

saveas(gcf, append(TablePath, filesep, "heatmap sorted tracks ",".pdf"));



%% Making a boxplot and a violin plot for the track duration

TrackDuration = [];

allTimepoints_minutes = allTimepoints;

for t = 1:size(allTimepoints_minutes, 2)

    TrackDurationTemp = (max(allTimepoints_minutes(:,t)) - min(allTimepoints_minutes(:,t)));

    TrackDuration = [TrackDuration ; TrackDurationTemp];

end


listColor = [0.8 0.8 0.8];

listConditions = 'MS2 foci duration';


boxplot = figure('Name', 'boxplot plot', 'Position', [0 0 200 300]);

plotBoxplotMATLABlike(TrackDuration, '.', '.', 0.5 , 0.25, 'Track duration', 14, 14, [0.2 0.2 0.2] , 0.3, 5, 18, [0,  50])

ylabel('Track duration (minutes)');

saveas(gcf, append(TablePath, filesep, "Boxplot track duration ",".pdf"));


figure(boxplot);


try
delete(violinplotobj);
end
try
 violinplotobj = violin(TrackDuration, 'xlabel', 'ms2', 'facecolor', [0.2 0.2 0.2], 'edgecolor','none', ...
'mc','',...
'medc','', ...
'bw', 2);
end
ylim([0,  50]);

saveas(gcf, append(TablePath, filesep, "violin track duration ",".pdf"));
