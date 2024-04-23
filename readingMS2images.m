%%reading MS2 or smFISH images


f = filesep;

[File, Path] = uigetfile('.lif');

LifLocString = [Path, File];

Reader = bfGetReader(LifLocString);
    seriesMetadata = Reader.getSeriesMetadata(); 
    omeMeta = Reader.getMetadataStore();
    Info = strsplit(char(omeMeta.dumpXML()),' ')';
    

Image = bfopen(LifLocString);

for s = 2  % this loop will go over every series on the v lif file
        % build the 3D matrix for each series
        % we are workinnng with images that have c channels and z stacks, but no time series
        Channels = [];
        try
        Channels = str2double(extractBefore(extractAfter(Image{s, 1}{1,2}, "C=1/"),2)); %this will extract the first character after "C=1/"
        Stacks = str2double(extractBefore(extractAfter(Image{s, 1}{1,2}, "Z=1/"), "; C=1")); %
        end
        % this will be necessary if the image only has one channel, as the
        % metadata for the number of channels and stacks is stored
        % differently
        if isempty(Channels);
         Channels = 1;
         Stacks  = str2double(extractAfter(Image{s, 1}{1,2}, "Z=1/"));
        end 
        
        SeriesMetadata= split(char(Image{s, 2}),", "); %the metadata string can be divided as there is a delimiter 
        
      
        %Extracting information from the metadata
        PhysicalSizePixel = str2num(extractBefore(extractAfter(FindInMetadata(Info, 'PhysicalSizeX'), '"'), '"'));
        SeriesName = FindInMetadata(SeriesMetadata, 'Image name=');
        SeriesZoom = FindInMetadata(SeriesMetadata, 'ATLConfocalSettingDefinition|Zoom=');
    
       

            ImageMatrix = [];
 
            for y  = 0:Stacks - 1 %channnel 1 
                ImageMatrix(:,:, (y+1), 1) = Image{s, 1}{(Channels*y + 1),1};
            end

          if Channels > 1
            for a  = 0:Stacks - 1 %channnel 2
                ImageMatrix(:,:, (a+1), 2) = Image{s, 1}{(Channels*a + 2),1};
            end
          else  %this will add a NaN channel to only one channel image so they can be compared
              for a  = 0:Stacks - 1 %channnel 2
                ImageMatrix(:,:, (a+1), 2) = NaN(size(Image{s, 1}{(Channels*y + 1),1}));
            end
          end
          
           
           if Channels > 2
             for b = 0:Stacks - 1 %channnel 3
                ImageMatrix(:,:, (b+1), 3) = Image{s, 1}{(Channels*b + 3),1};
             end
           end
end       
    
I = ImageMatrix(:,:,:, 1);

figure
imagesc(ImageMatrix(:,:,5, 1));


seedLevel = round(size(ImageMatrix, 3) / 2);
seed = I(:,:,seedLevel) > min(maxk(max(I(:,:,seedLevel)), 10, 2));
figure
imshow(seed)

mask = zeros(size(I));
mask(:,:,seedLevel) = seed;

bw = activecontour(I,mask,300);

figure;

imshow(bw(:,:,seedLevel));
p = patch(isosurface(double(bw)));
p.FaceColor = 'red';
p.EdgeColor = 'none';
daspect([1 1 27/128]);
camlight; 
lighting phong


