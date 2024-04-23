function [ImageMat, Metadata] = extractingseries(Image, ChannelNmbr)
%this function will extract information from the bfreader when reading a
%lif files and make a matrix with the following dimensions: [X,Y, stacks, channel]

%additionally, it will also output, the number of channels, the numer of
%stacks and...

%this function works for lif files that have different channels (up to n)
%but not with images that have time series


%the microscope will save the data in a different way depending if it has 
%one or more channels, so we need to extract some metadata first


%the ChannelNmbr is the channels that you are expecting to have. If an
%individual series or all the images dont have the expexted number of
%channels, they will be filled with NaNs

    Metadata = [];
    ImageMat = [];
 
    
for s = 1:size(Image, 1)
    
    try
    Metadata(s).Channels = str2double(extractBefore(extractAfter(Image{s, 1}{1,2}, "C=1/"),2)); %this will extract the first character after "C=1/"
    Metadata(s).Stacks = str2double(extractBefore(extractAfter(Image{s, 1}{1,2}, "Z=1/"), "; C=1")); %
    end
    % this will be necessary if the image only has one channel, as the
    % metadata for the number of channels and stacks is stored
    % differently
    
    MetadataSeriesChannelInfo = [];
    try 
        MetadataSeriesChannelInfo = Metadata(s).Channels; 
    end

        if isempty(MetadataSeriesChannelInfo)
     Metadata(s).Channels = 1;
     Metadata(s).Stacks  = str2double(extractAfter(Image{s, 1}{1,2}, "Z=1/"));
        end
  

     
    
    SeriesMetadata = split(char(Image{s, 2}),", "); %the metadata string can be divided as there is a delimiter 
    
    Metadata(s).SeriesName = FindInMetadata(SeriesMetadata, 'Image name=');
    Metadata(s).SeriesZoom = FindInMetadata(SeriesMetadata, 'ATLConfocalSettingDefinition|Zoom=');
    Metadata(s).SeriesBits = FindInMetadata(SeriesMetadata, 'Image|ATLConfocalSettingDefinition|BitSize=');


    
    for Ch = 1:ChannelNmbr  
    
         if Metadata(s).Channels > Ch - 1

            for a  = 0:Metadata(s).Stacks - 1 
            ImageMat(s).Image(:,:, (a+1), Ch) = Image{s, 1}{(Metadata(s).Channels*a + Ch),1};
            end
            
         else
             
            for a  = 0:Metadata(s).Stacks - 1 
            ImageMat(s).Image(:,:, (a+1), Ch) = NaN(size(Image{s, 1}{(Metadata(s).Channels*a + Ch-1), 1}));
            end
             
             
         end
     
        
    end    
    
   
end


end
