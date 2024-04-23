% Script for image data analysis with a custom-built MATLAB app

% Define a file separator
f = filesep;

% Option to override quantifications
listConditions = {'Check if quantifications have been done', 'Do not check if quantifications have been done'};
[indx, ~] = listdlg('ListString', listConditions);

if isequal('Check if quantifications have been done', listConditions{indx})
    Override = [];
elseif isequal('Do not check if quantifications have been done', listConditions{indx})
    Override = (1);
end

%% Choosing a folder and opening a mini app

% Set the parent folder that contains the folders with the .lif files
Listdirectory = findliffilesv2(); % Function to find all .lif files within a directory; files must be nested into folders with the same name as the .lif file

for v = 1: length({Listdirectory.name})
    % Loop through each .lif file in the Listdirectory
    
    LifLocString = convertStringsToChars(append(Listdirectory(v).folder, f, Listdirectory(v).name));
    % Combine the name and folder for easier file access
    
    Reader = bfGetReader(LifLocString);
    SeriesMetadataReader = Reader.getSeriesMetadata();
    omeMeta = Reader.getMetadataStore();
    Info = strsplit(char(omeMeta.dumpXML()), ' ')';
    
    PhysicalSizePixel = findpixelsizeinmetadataseries(Info);
    % Extract physical size information from metadata
    
    Image = bfopen(LifLocString); % Import all data from the .lif file
    
    [ImageMat, Metadata] = extractingseries(Image, 3); % Extract image series data, change channels as needed
    
    IntensityROIsLIF = [];
    MeansChannel1LIF = [];
    MeansChannel2LIF = [];
    MeansChannel3LIF = [];
    BackgroundIntensity = [];
    
    for s = 1:size(ImageMat, 2)
        % Loop through each series in the .lif file
        
        CheckIfMatFile = [];
        
        if isempty(Override)
            try
                CheckIfMatFile = load(append(LifLocString, ' series ', Metadata(s).SeriesName, ' ROIMatrix.mat'));
            end
        end
        
        if isempty(CheckIfMatFile)
            % Check if a .mat file exists; if not, read the matrix and generate a mini app
            
            ROIdim = [100, 100, 90, 40]; % Define the dimensions
            
            % Check series parameters
            if ((Metadata(s).SeriesZoom ~= 4.5) == 0)
                error(strcat("The series ", Metadata(s).SeriesName, " in the image ", Listdirectory(1).name, " has a zoom different from 4.5. This might affect the scale of the plot"));
            end
            
            if (Metadata(s).SeriesBits == 8)
                warning(strcat("The series ", Metadata(s).SeriesName, " in the image ", Listdirectory(1).name, " has 8 bits instead of 12"));
                ImageMat(s).Image = uint32(ImageMat(s).Image) .* uint32(2^4); % Convert image values from 8-bit to 12-bit
            end
            
            app = bandintensity(ImageMat(s).Image, ROIdim);
            while isvalid(app)
                pause(0.1);
            end
            
            IntensityROI = ExportIntensityROI; % Export intensity data
            
            % Save data to .mat files
            save(append(LifLocString, ' series ', Metadata(s).SeriesName, ' ROIMatrix.mat'), 'IntensityROI');
            save(append(LifLocString, ' series ', Metadata(s).SeriesName, ' BGmasked.mat'), 'BackgroundIntensityExport');
            save(append(LifLocString, ' series ', Metadata(s).SeriesName, ' metadata.mat'), 'Metadata');
            save(append(LifLocString, ' series ', Metadata(s).SeriesName, ' pixelsize.mat'), 'PhysicalSizePixel');
        end
    end
end
