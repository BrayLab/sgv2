clear all
close all

f = filesep;

%% Importing the csv and tif files

% Import CSV data from trackmate, remove the redundant column headers
% before you run it 

[TableFilec1, TablePathc1] = uigetfile('.csv', 'Select tracking data CSVforchannel1');
Trackingdatac1 = readtable(strcat(TablePathc1, TableFilec1));

%using this function to extract a x by y by z matrix and the
%PhysicalPixelSize in microns from a one channel tiff image
[ImageDatac1, PhysicalPixelSizec1] = importImage();


% sliceViewer(ImageDatac1);
% close


% Import CSV data from trackmate, remove the redundant column headers before you run it

[TableFilec2, TablePathc2] = uigetfile('.csv', 'Select tracking data CSVforchannel2');
Trackingdatac2 = readtable(strcat(TablePathc2, TableFilec2));

%using this function to extract a x by y by z matrix and the
%PhysicalPixelSize in microns from a one channel tiff image

[ImageDatac2, PhysicalPixelSizec2] = importImage();

if PhysicalPixelSizec1 == PhysicalPixelSizec2
else
    error('Pixel sizes are different for the two images')
end

% sliceViewer(ImageDatac2);
% close
% 



%% structuring the tracking

% Extract relevant columns from the tracking

c1TrackID = Trackingdatac1.TRACK_ID;
c1SpotID = Trackingdatac1.ID;
c1Timepoint = Trackingdatac1.POSITION_T;
c1Maxintensity = Trackingdatac1.MAX_INTENSITY_CH1;
c1Meanintensity = Trackingdatac1.MEAN_INTENSITY_CH1;
c1PosX= Trackingdatac1.POSITION_X;
c1PosY= Trackingdatac1.POSITION_Y;


c2TrackID = Trackingdatac2.TRACK_ID;
c2SpotID = Trackingdatac2.ID;
c2Timepoint = Trackingdatac2.POSITION_T;
c2Maxintensity = Trackingdatac2.MAX_INTENSITY_CH1;
c2Meanintensity = Trackingdatac2.MEAN_INTENSITY_CH1;
c2PosX= Trackingdatac2.POSITION_X;
c2PosY= Trackingdatac2.POSITION_Y;


AllselectedTrackIDs_c1 = [39; 1; 5; 21; 49]; 
AllselectedTrackIDs_c2 = [2; 5; 9; 1; 10];


for g = 3: size(AllselectedTrackIDs_c1, 1)

selectedTrackIDs_c1 = AllselectedTrackIDs_c1(g, :);
selectedTrackIDs_c2 = AllselectedTrackIDs_c2(g, :);

% Unique Tracks (channel 1)
uniqueTrackIDs_c1 = unique(c1TrackID);
% uniqueTrackIDs_c1 = uniqueTrackIDs_c1(2:end); %removing trackID 0, that includes all the points that dont have a track

% Unique Tracks (channel 2)
uniqueTrackIDs_c2 = unique(c2TrackID);
uniqueTrackIDs_c2 = uniqueTrackIDs_c2(2:end); %removing trackID 0, that includes all the points that dont have a track

% Data structures (separate for each channel)
trackData_c1 = struct();
trackData_c2 = struct();

% Channel 1
for i = 1:length(uniqueTrackIDs_c1)
    trackID = uniqueTrackIDs_c1(i);
    trackIndices = find(c1TrackID == trackID);

    trackData_c1(i).id = trackID;
    trackData_c1(i).time = c1Timepoint(trackIndices);
    trackData_c1(i).ch1Intensity = c1Maxintensity(trackIndices);
    trackData_c1(i).posX = c1PosX(trackIndices);
    trackData_c1(i).posY = c1PosY(trackIndices);

    % Sort data within each track by time
    [trackData_c1(i).time, sortIdx] = sort(trackData_c1(i).time); 
    trackData_c1(i).ch1Intensity = trackData_c1(i).ch1Intensity(sortIdx);
    trackData_c1(i).posX = trackData_c1(i).posX(sortIdx);
    trackData_c1(i).posY = trackData_c1(i).posY(sortIdx);
end

% Channel 2 
for y = 1:length(uniqueTrackIDs_c2)
      trackID = uniqueTrackIDs_c2(y);
    trackIndices = find(c2TrackID == trackID);

    trackData_c2(y).id = trackID;
    trackData_c2(y).time = c2Timepoint(trackIndices);
    trackData_c2(y).ch1Intensity = c2Maxintensity(trackIndices);
    trackData_c2(y).posX = c2PosX(trackIndices);
    trackData_c2(y).posY = c2PosY(trackIndices);

    % Sort data within each track by time
    [trackData_c2(y).time, sortIdx] = sort(trackData_c2(y).time); 
    trackData_c2(y).ch1Intensity = trackData_c2(y).ch1Intensity(sortIdx);
    trackData_c2(y).posX = trackData_c2(y).posX(sortIdx);
    trackData_c2(y).posY = trackData_c2(y).posY(sortIdx);
end

%% visualising the relevant tracks with an image

% Track Selection (by unique ID, modify as needed! these are extracted from
% the excel spreadsheet from TrackMate)


% Customizable parameters
trackRadius = 5;  % Adjust as needed
circleColors = [1 0 0; 0 1 0]; % Colors for channel 1 and channel 2


%% Plotting Tracks over Time 
figure;
hold on;

circleRadius = 0.6/PhysicalPixelSizec1; % Adjust as needed

% adjust the resolution here if needed
sizeX = size(ImageDatac1, 1);
sizeY = size(ImageDatac1, 2);

%extracting time series
maxTime = size(ImageDatac1, 3);


trackMatrix_c1 = zeros(sizeX, sizeY, maxTime);
trackMatrix_c2 = zeros(sizeX, sizeY, maxTime);


for channelIndex = 1:2 
    if channelIndex == 1
        trackData = trackData_c1(selectedTrackIDs_c1);
    else
        trackData = trackData_c2((selectedTrackIDs_c2));
    end

    for i = 1:length(trackData) 
        x = trackData(i).posX ./ PhysicalPixelSizec1;
        y = trackData(i).posY ./ PhysicalPixelSizec1;
        intensity = trackData(i).ch1Intensity;
        time = trackData(i).time;
        time = round(time ./ 30); %adjust here the framegap
       

        for t = 1:length(time) 
            xPos = round(x(t)); 
            yPos = round(y(t));
            maxint = intensity(t);
            timePoint = time(t) + 1; %so time doesnt start at 0 
            if channelIndex == 1
                [NewMatrix] = setCircleInMatrix(trackMatrix_c1, xPos, yPos, timePoint, circleRadius, maxint);
                trackMatrix_c1 = NewMatrix;
            else
                [NewMatrix] = setCircleInMatrix(trackMatrix_c2, xPos, yPos, timePoint, circleRadius, maxint);
                trackMatrix_c2 = NewMatrix;
            end 
        end
    end
end

max(trackMatrix_c1,[], 'all')


tracksCombined = cat(2, trackMatrix_c1, trackMatrix_c2, (trackMatrix_c1 + trackMatrix_c2));

 filename = 'myAnimation.gif';
for frameNum = 1:maxTime
    % Load or display the desired frame
    figure('Position', [0 0 512*3 512])
    imagesc(tracksCombined(:,:,frameNum)); 
    colormap(flipud(gray));
    axis equal
    
    % Capture frame
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 4096);
    

    filename = 'track_animation.gif';
    delayTime = 0.5; % Adjust delay in seconds

   NameGif =  append(TablePathc1, 'animated for tracks ', string(selectedTrackIDs_c1), ' c2', string(selectedTrackIDs_c2), '.gif'); 

    % Write to GIF
    if frameNum == 1
        imwrite(imind, cm, NameGif , 'gif', 'Loopcount', inf, 'DelayTime', delayTime);
    else
        imwrite(imind, cm, NameGif, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end



close all

%% tracking the intensity and the distance of the selected tracks

% Intensity Plots
figure;

subplot(2,1,1); % Subplot intensities
hold on;
for e = 1:length(selectedTrackIDs_c1)
    trackIndex = find([trackData_c1.id] == selectedTrackIDs_c1(e));
    trackID = trackData_c1(selectedTrackIDs_c1(e)).id;
    plot(trackData_c1(selectedTrackIDs_c1(e)).time, trackData_c1(selectedTrackIDs_c1(e)).ch1Intensity, 'g', 'DisplayName', 'MS2MCPGFPlower');
end
xlabel('Time');
ylabel('Intensity');
title('Intensity over Time for Selected Tracks');
legend('show');
hold off;

% ... (Add labels, title, legend for channel 1)
% 
% subplot(2,1,2); % Subplot for channel 2
hold on;
for u = 1:length(selectedTrackIDs_c2)
    trackIndex = find([trackData_c2.id] == selectedTrackIDs_c2(u));
    trackID = trackData_c2(selectedTrackIDs_c2(u)).id;
    plot(trackData_c2(selectedTrackIDs_c2(u)).time, trackData_c2(selectedTrackIDs_c2(u)).ch1Intensity, 'm', 'DisplayName',' MamHalolower')
end
xlabel('Time');
ylabel('Intensity');
title('Intensity over Time for Selected Tracks');
legend('show');
x1 = xlim ;
hold off;
xlim(x1) 


subplot(2,1,2); % Subplot intensities
hold on

for i = 1:length(selectedTrackIDs_c1)
    trackIndex_c1 = find([trackData_c1.id] == selectedTrackIDs_c1(i));
    c1Time = trackData_c1(trackIndex_c1).time;
    c1X = trackData_c1(trackIndex_c1).posX;
    c1Y = trackData_c1(trackIndex_c1).posY;

    for j = 1:length(selectedTrackIDs_c2)
        trackIndex_c2 = find([trackData_c2.id] == selectedTrackIDs_c2(j));
        c2Time = trackData_c2(trackIndex_c2).time;
        c2X = trackData_c2(trackIndex_c2).posX;
        c2Y = trackData_c2(trackIndex_c2).posY;

        [distances, timepoints] = calculateDistance(c1Time, c1X, c1Y, c2Time, c2X, c2Y);

        plot(timepoints.', distances, 'DisplayName', ...
             ['Track ', num2str(selectedTrackIDs_c1(i)), ' - ', num2str(selectedTrackIDs_c2(j))]);
      
    end
end


xlim(x1);
xlabel('Time');
ylabel('distance (um)');
title('distance between selected tracks over time');
legend('show');


% Distance Plots




orient(gcf,'landscape');

saveas(gcf, append(TablePathc1, 'plot with intensities of tracks c1', string(selectedTrackIDs_c1), ' c2', string(selectedTrackIDs_c2), '.pdf'));

%% saving the intensity and distance as a csv




% minStartTime = min([
%     min(cellfun(@(x) x(1), {trackData_c1(selectedTrackIDs_c1).time})), ...
%     min(cellfun(@(x) x(1), {trackData_c2(selectedTrackIDs_c2).time}))
% ]);
% 
% maxTimepoints = max([
%     max(cellfun(@length, {trackData_c1(selectedTrackIDs_c1).time})), ...
%     max(cellfun(@length, {trackData_c2(selectedTrackIDs_c2).time}))
% ]);


Datapointsshared = unique([trackData_c1(selectedTrackIDs_c1).time ; trackData_c2(selectedTrackIDs_c2).time]);

timeData = 1:size(Datapointsshared, 1); % Consistent time array
% timeDataunit =  trackData_c1(selectedTrackIDs_c1).time(2) - trackData_c1(selectedTrackIDs_c1).time(1);
timeDatainsec = unique([trackData_c1(selectedTrackIDs_c1).time ; trackData_c2(selectedTrackIDs_c2).time]).';
intensityChannel1 = NaN([size(timeData, 2), 1]); 
intensityChannel2 = NaN([size(timeData, 2), 1]); 

distanceData = NaN([size(timeData, 2), 1]);


    intensityChannel1(find(ismember(round(timeDatainsec), round(trackData_c1(selectedTrackIDs_c1).time)))) = trackData_c1(selectedTrackIDs_c1).ch1Intensity;
    intensityChannel2(find(ismember(round(timeDatainsec), round(trackData_c2(selectedTrackIDs_c2).time)))) = trackData_c2(selectedTrackIDs_c2).ch1Intensity;
    distanceData(find(ismember(round(timeDatainsec), timepoints))) = distances;

    

% if size(trackData_c2(selectedTrackIDs_c2).time, 1) >  size(trackData_c1(selectedTrackIDs_c1).time, 1) 
% 
%     % timeData = trackData_c2(selectedTrackIDs_c2).time;
%     intensityChannel2 = trackData_c2(selectedTrackIDs_c2).ch1Intensity;
% 
%     [row, col] = find(trackData_c2(selectedTrackIDs_c2).time == trackData_c1(selectedTrackIDs_c1).time.');
% 
%     intensityChannel1(row) = trackData_c1(selectedTrackIDs_c1).time.';
%     % distanceData(row) = distances;
%      distanceData(find(ismember(round(timeDatainsec), timepoints))) = distances;
% 
% else
%     % timeData = trackData_c1(selectedTrackIDs_c1).time;
%     intensityChannel1 = trackData_c1(selectedTrackIDs_c1).ch1Intensity;
% 
%     [row, col] = find(ismember(round(timeDatainsec), round(trackData_c1(selectedTrackIDs_c1).time));
% 
%     intensityChannel2(row) = trackData_c2(selectedTrackIDs_c2).ch1Intensity.';
% 
%     distanceData(find(ismember(round(timeDatainsec), timepoints))) = distances;
% 
% end
% 
% 

outputTable = table(timeDatainsec.', intensityChannel1, intensityChannel2, distanceData, ...
                    'VariableNames', {'Time', 'IntensityCh1', 'IntensityCh2', 'Distance'});
writetable(outputTable, append(TablePathc1, 'trackintensitiesanddistancec1', string(selectedTrackIDs_c1), ' c2', string(selectedTrackIDs_c2), '.csv')); 


end

