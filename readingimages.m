
% Script for image data analysis with a custom built MatLab app

% Define a file separator
f = filesep;


%% option to override quantifications

listConditions = {'Check if quantifications have been done', 'Do not check if quantifications have been done'};

[indx,tf] = listdlg('ListString',listConditions);

    if isequal('Check if quantifications have been done', listConditions{indx})

        Override = [];

    elseif isequal('Do not check if quantifications have been done', listConditions{indx})
        
        Override = (1);
        
    end


%% choosing folder and opening mini app


%set the parent folder that contains the folders with the lifs files

Listdirectory = findliffilesv2();
 

for v = 1: length({Listdirectory.name}) % this loop will go over every lif file in the Lisdirectory


LifLocString = convertStringsToChars(append(Listdirectory(v).folder, f, Listdirectory(v).name)); %combining the name and the folder so that the bfreader is easier


Reader = bfGetReader(LifLocString);
SeriesMetadataReader = Reader.getSeriesMetadata(); 
omeMeta = Reader.getMetadataStore();
Info = strsplit(char(omeMeta.dumpXML()),' ')';

PhysicalSizePixel = findpixelsizeinmetadataseries(Info);


Image = bfopen(LifLocString);

[ImageMat, Metadata] = extractingseries(Image, 3); %change here the channels that there are on the series



IntensityROIsLIF = [];
MeansChannel1LIF = [];
MeansChannel2LIF = [];
MeansChannel3LIF = [];
BackgroundIntensity = []; 




    for s = 1:size(ImageMat, 2)  % this loop will go over every series on the v lif file
            
        CheckIfMatFile = [];
        
        if isempty(Override)
            try
                CheckIfMatFile = load(append(LifLocString, ' series ', Metadata(s).SeriesName, ' ROIMatrix.mat'));
            end
        end 
        
        if isempty(CheckIfMatFile) %with this if we will check if there is a .mat file. If there isn't, the matrix will be read and the mini app will be generated
            
           ROIdim = [100,100,90,40];
           
                    % this is for the script to wait until the app runs and turn this variable to true

                 if ((Metadata(s).SeriesZoom ~= 4.5) == 0)
                        error(strcat("The series ", Metadata(s).SeriesName  , " in the image ", Listdirectory(1).name , " has a zoom different to 4.5. This might affect the scale of the plot"));
                 end

                 if (Metadata(s).SeriesBits == 8)
                     warning(strcat("The series ", Metadata(s).SeriesName  , " in the image ", Listdirectory(1).name , "has 8 bits instead of 12"));
                     ImageMat(s).Image = uint32(ImageMat(s).Image).* uint32(2^4); % this will convert the image's values that are in 8 bit to 12 bits  
                 end 


                   app = bandintensity(ImageMat(s).Image, ROIdim);
                   while isvalid(app); pause(0.1); end


                    IntensityROI = ExportIntensityROI;  
                    
                
                    save(append(LifLocString, ' series ', Metadata(s).SeriesName, ' ROIMatrix.mat'), 'IntensityROI'); % the save function allows saving variables. They have to be writen as scalars on the second argument  
                    save(append(LifLocString, ' series ', Metadata(s).SeriesName, ' BGmasked.mat'), 'BackgroundIntensityExport'); 
                    save(append(LifLocString, ' series ', Metadata(s).SeriesName, ' metadata.mat'), 'Metadata');
                    save(append(LifLocString, ' series ', Metadata(s).SeriesName, ' pixelsize.mat'), 'PhysicalSizePixel');


        end

    end

end

