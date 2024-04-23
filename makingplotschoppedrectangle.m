
f = filesep;

% fill in these for the plot and choose the channel

nameofmolofinterest = 'MamHalo MS2';
nameofloctag = "loctag";
ChannelofInterest = 1;



% getting the folder

path = uigetdir();


blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];

listConditions = {'Halo'};
listColor = cat(1, red, green, blue);


AllMatrix = [];
NuclearSignalMatrix = [];


for a = 1:(length(listConditions))
    
    


    nameNotchstatus = listConditions{a};
    notchstatus = listConditions{a};
    disp(notchstatus);


parentdirectory = dir(append(path, f, '*', nameNotchstatus, '*'));


ImageMat = [];
BGMat = []; 
PixelMat = [];
MetadataMat = [];

 for t = 1:length({parentdirectory.name}) %this loop will go over every folder that has the name nameNotchstatus on it
    
    disp(parentdirectory(t).name);
    
    
    
    MATDirectory = dir(append(parentdirectory(t).folder, f, parentdirectory(t).name, f,  '*.mat'));
       

    MATDirectoryfullpath = [];
    
    if isempty(MATDirectory);
        
    else
        for u = 1 : size(MATDirectory, 1)
        pos = size(MATDirectoryfullpath, 1)+1;

        MATDirectoryfullpath = [MATDirectoryfullpath, {append(MATDirectory(u).folder, f , MATDirectory(u).name)}];
    
        end
    end


    for n = 1:size(MATDirectoryfullpath, 2)
       
        if isequal("metadata", regexp(MATDirectoryfullpath{n},'metadata', 'match'))

            Metadata = load(MATDirectoryfullpath{n});
            dimensionsinMetadata = ndims(Metadata) + 1;
            MetadataMat = cat(dimensionsinMetadata, MetadataMat, Metadata); 
            
            
        elseif isequal("pixelsize", regexp(MATDirectoryfullpath{n},'pixelsize', 'match'))

            PixelSize = load(MATDirectoryfullpath{n});
            dimensionsinPixelSize = ndims(PixelSize.PhysicalSizePixel) + 1;
            PixelMat = cat(ndims(PixelSize.PhysicalSizePixel), PixelMat, PixelSize.PhysicalSizePixel); 
        
        elseif isequal("ROIMatrix", regexp(MATDirectoryfullpath{n},'ROIMatrix', 'match'))

            RoiMat = load(MATDirectoryfullpath{n});
            dimensionsinRoiMat = ndims(RoiMat.IntensityROI) + 1;
            ImageMat = cat(dimensionsinRoiMat, ImageMat, RoiMat.IntensityROI); 
            
        elseif isequal("BGmasked", regexp(MATDirectoryfullpath{n},'BGmasked', 'match'))

            BGmask = load(MATDirectoryfullpath{n});
            dimensionsinBGmask = ndims(BGmask.BackgroundIntensityExport) + 1;
            BGMat = cat(dimensionsinBGmask, BGMat, BGmask.BackgroundIntensityExport);
        else 
            
            disp('there is a .mat with no appropiate name');
            
        end
        
        
       end
      
end     



% in this section we will normalise the signal on ImageMat by dividing it by one value. This value is the BG, and it will be obtained from doing a mean of the BG matrix


BGMatNorm1 = permute(mean(permute(BGMat(:,:,:,1,:), [1 2 5 3 4]), [1 2], 'omitnan'), [3 2 1]);
ImageMatSimp1 = double(permute(ImageMat(:,:,:,1,:), [1 2 5 3 4]));

BGMatNorm2 = permute(mean(permute(BGMat(:,:,:,2,:), [1 2 5 3 4]), [1 2], 'omitnan'), [3 2 1]);
ImageMatSimp2 = double(permute(ImageMat(:,:,:,2,:), [1 2 5 3 4]));


BGMatNorm = permute(mean(permute(BGMat(:,:,:,ChannelofInterest,:), [1 2 5 3 4]), [1 2], 'omitnan'), [3 2 1]);
ImageMatSimp = double(permute(ImageMat(:,:,:,ChannelofInterest,:), [1 2 5 3 4]));




BGMatNormRepeat = [];

    for q = 1:size(BGMatNorm, 1)
        
         BGMatNormRepeat(:,:, q) = repmat(BGMatNorm(q), size(ImageMatSimp, 1), size(ImageMatSimp, 2));   
    end

 
 BGMatNormRepeat1 = [];
 
     for m = 1:size(BGMatNorm1, 1)
        
         BGMatNormRepeat1(:,:, m) = repmat(BGMatNorm1(m), size(ImageMatSimp1, 1), size(ImageMatSimp1, 2));   
    end

   
   BGMatNormRepeat2 = [];
   
        for m = 1:size(BGMatNorm2, 1)
        
         BGMatNormRepeat2(:,:, m) = repmat(BGMatNorm2(m), size(ImageMatSimp2, 1), size(ImageMatSimp2, 2));   
    end
   
ImageMatNorm = ImageMatSimp ./ BGMatNormRepeat;

ImageMatNorm1 = ImageMatSimp1 ./ BGMatNormRepeat1;

ImageMatNorm2 = ImageMatSimp2 ./ BGMatNormRepeat2;



% plot with an image where each pixel is an average and its normalised
% version

 figure('Name', notchstatus, 'Position', [0 0 900 235]);
 
NewPixelSize = mode(PixelMat);
Yaxislastvalue = NewPixelSize * size(ImageMatSimp, 1);
Xaxislastvalue = NewPixelSize * size(ImageMatSimp, 2);

tl = tiledlayout(1, 2,'TileSpacing','Compact');


title(tl, append('Intensity of ', nameofmolofinterest, ' in ',  nameNotchstatus));
ylabel(tl, 'distance (um)');
xlabel(tl, 'distance (um)');
colormap(parula);
    nexttile
    imagesc([NewPixelSize:NewPixelSize:Xaxislastvalue],  [NewPixelSize:NewPixelSize:Yaxislastvalue], mean(ImageMatSimp, 3, 'omitnan'));
    caxis([1, 1200]);
    title('Image of the mean intensity');
    colorbar;
 axis equal
 
    nexttile;
    imagesc([NewPixelSize:NewPixelSize:Xaxislastvalue],  [NewPixelSize:NewPixelSize:Yaxislastvalue], mean(ImageMatNorm, 3, 'omitnan'));
    caxis([0, 2]);
    title('Image of the mean fold change');
colorbar;

axis equal
    
%  saving this plot

orient(gcf,'landscape');

saveas(gcf, append(path, f, ' intensity of Mam with', nameNotchstatus, 'treatment.pdf'));


% making the one Yaveraged plot with the SEM
% ChosenNorm = ImageMatSimp;
ChosenNorm = ImageMatNorm;

SEMmolofinterest = std(mean(ChosenNorm, 1), 0, 3, 'omitnan') ./ sqrt(size(ChosenNorm, 3));



    if exist('classicplot')
        figure(classicplot);    
    else 
         classicplot = figure('Name', 'classic plot', 'Position', [0 0 600 400]);
    end


hold on

title(append(nameofmolofinterest, ' intensity'), 'FontSize', 20)

xlabel('Distance (um)', 'FontSize', 14);

ylim([0 4]);
ylabel(append( nameofmolofinterest, 'fluorescence intensity'), 'FontSize', 14);

topcurve = (mean(ChosenNorm, [1 3], 'omitnan') + SEMmolofinterest).';
lowercurve = (mean(ChosenNorm, [1 3], 'omitnan') - SEMmolofinterest).';

spatialscale = NewPixelSize:NewPixelSize:(size(ChosenNorm, 2) * NewPixelSize);
pline1 = plot(spatialscale, mean(ChosenNorm, [1 3], 'omitnan'), '-', 'DisplayName', nameofmolofinterest, 'color', listColor(a,:));

pfill1 = fill([spatialscale fliplr(spatialscale)], [topcurve.' fliplr(lowercurve).'], ...
              listColor(a,:), 'linestyle', 'none', 'FaceAlpha', .3, 'DisplayName', 'SEMmol');

 
 legend([pline1],  notchstatus, ...
     'FontSize', 14);
 


    
 % saving the plot

orient(gcf,'landscape');

% saveas(gcf, append(path, f , ' intensity of Mam with', nameNotchstatus, 'treatment.pdf'));

   

% saving 10 middle pixel in a.txt

FoldChangeMolofInterest = permute(mean(ChosenNorm, [1], 'omitnan'), [3 2 1]);

MiddleFoldChange = mean(FoldChangeMolofInterest(:, [(round(((size(FoldChangeMolofInterest, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest, 2)/2) + 5), 0))]), 2);

writematrix(MiddleFoldChange, strcat(path, f, '10 middle pixels average fold change channel of interest for', nameNotchstatus));






IntensityMolofInterest1 = permute(mean(ImageMatSimp1, [1], 'omitnan'), [3 2 1]);

MiddleIntensityMolofInterest1 = mean(IntensityMolofInterest1(:, [(round(((size(IntensityMolofInterest1, 2)/2) - 5), 0)):(round(((size(IntensityMolofInterest1, 2)/2) + 5), 0))]), 2);

writematrix(MiddleIntensityMolofInterest1, strcat(path, f, '10 middle pixels average intensity channel 1 for', nameNotchstatus));


       
FoldChangeMolofInterest1 = permute(mean(ImageMatNorm1, [1], 'omitnan'), [3 2 1]);

MiddleFoldChange1 = mean(FoldChangeMolofInterest1(:, [(round(((size(FoldChangeMolofInterest1, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest1, 2)/2) + 5), 0))]), 2);

writematrix(MiddleFoldChange1, strcat(path, f, '10 middle pixels average fold change channel 1 for', nameNotchstatus));


IntensityMolofInterest2 = permute(mean(ImageMatSimp2, [1], 'omitnan'), [3 2 1]);

MiddleIntensityMolofInterest2 = mean(IntensityMolofInterest2(:, [(round(((size(IntensityMolofInterest2, 2)/2) - 5), 0)):(round(((size(IntensityMolofInterest2, 2)/2) + 5), 0))]), 2);

writematrix(MiddleIntensityMolofInterest2, strcat(path, f, '10 middle pixels average intensity channel 2 for', nameNotchstatus));


       
FoldChangeMolofInterest2 = permute(mean(ImageMatNorm2, [1], 'omitnan'), [3 2 1]);

MiddleFoldChange2 = mean(FoldChangeMolofInterest2(:, [(round(((size(FoldChangeMolofInterest2, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest2, 2)/2) + 5), 0))]), 2);

writematrix(MiddleFoldChange2, strcat(path, f, '10 middle pixels average fold change channel 2 for', nameNotchstatus));




AllMatrix = padconcatenation(AllMatrix, MiddleFoldChange, 2);
NuclearSignalMatrix = padconcatenation(NuclearSignalMatrix, BGMatNorm  , 2);




end



figure(classicplot);

orient(gcf,'landscape');
saveas(gcf, append(path, f , 'Plot Yavgd intensity of ',nameofmolofinterest, '.pdf'));


boxplot = figure('Name', 'classic plot', 'Position', [0 0 800 500]);


blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];

MyColorMap = [green; red; blue];

hold on

plotBoxplot(AllMatrix, listConditions, listConditions, 0.5 , 0.25, '10 middle pixels', 14, 14, MyColorMap, 0.3, 5, 18, [0, 5.3])

saveas(gcf, append(path, f , 'Yavgd  ',nameofmolofinterest, '.pdf'));
saveas(gcf, append(path, f , 'Boxplot 10 middle pixels levels  ',nameofmolofinterest, '.pdf'));

[h, p] = ttest(AllMatrix(:, 1), AllMatrix(:, 2))
[h, p] = ttest(AllMatrix(:, 2), AllMatrix(:, 3))
[h, p] = ttest(AllMatrix(:, 1), AllMatrix(:, 3))




boxplot2 = figure('Name', 'nuclear signal', 'Position', [0 0 800 500]);


blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];

MyColorMap = [green; red; blue];

hold on

plotBoxplot(AllMatrix, listConditions, listConditions, 0.5 , 0.25, 'nuclear signal', 14, 14, MyColorMap, 0.3, 5, 18, [0, 1800])

saveas(gcf, append(path, f , 'Boxplot nuclear levels  ',nameofmolofinterest, '.pdf'));
