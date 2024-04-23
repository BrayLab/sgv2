
f = filesep;

% fill in these for the plot and choose the channel

nameofmolofinterest = 'Hairless';
nameofloctag = "loctag";
ChannelofInterest = 1;



% getting the folder

path = uigetdir();


blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];

listConditions = {'skd', 'kto', 'wRi'};
listColor = cat(1, red, blue, green);


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

 figure('Name', append(notchstatus, ' Channel1'), 'Position', [0 0 900 235]);
 
NewPixelSize = mode(PixelMat);
Yaxislastvalue = NewPixelSize * size(ImageMatSimp1, 1);
Xaxislastvalue = NewPixelSize * size(ImageMatSimp1, 2);

tl = tiledlayout(1, 2,'TileSpacing','Compact');


title(tl, append('Intensity of ', nameofmolofinterest, ' in ',  nameNotchstatus));
ylabel(tl, 'distance (um)');
xlabel(tl, 'distance (um)');
colormap(parula);
    nexttile
    imagesc([NewPixelSize:NewPixelSize:Xaxislastvalue],  [NewPixelSize:NewPixelSize:Yaxislastvalue], mean(ImageMatSimp1, 3, 'omitnan'));
    caxis([1, 3000]);
    title('Image of the mean intensity');
    colorbar;
 axis equal
 
    nexttile;
    imagesc([NewPixelSize:NewPixelSize:Xaxislastvalue],  [NewPixelSize:NewPixelSize:Yaxislastvalue], mean(ImageMatNorm1, 3, 'omitnan'));
    caxis([0, 5]);
    title('Image of the mean fold change');
colorbar;

axis equal
    
%  saving this plot

orient(gcf,'landscape');

saveas(gcf, append(path, f, ' intensity of Channel 1', nameNotchstatus, 'treatment.pdf'));

% plot with an image where each pixel is an average and its normalised
% version

 figure('Name', append(notchstatus, ' Channel2'), 'Position', [0 0 900 235]);
 
NewPixelSize = mode(PixelMat);
Yaxislastvalue = NewPixelSize * size(ImageMatSimp1, 1);
Xaxislastvalue = NewPixelSize * size(ImageMatSimp1, 2);

tl = tiledlayout(1, 2,'TileSpacing','Compact');


title(tl, append('Intensity of ', nameofmolofinterest, ' in ',  nameNotchstatus));
ylabel(tl, 'distance (um)');
xlabel(tl, 'distance (um)');
colormap(parula);
    nexttile
    imagesc([NewPixelSize:NewPixelSize:Xaxislastvalue],  [NewPixelSize:NewPixelSize:Yaxislastvalue], mean(ImageMatSimp2, 3, 'omitnan'));
    caxis([1, 3000]);
    title('Image of the mean intensity');
    colorbar;
 axis equal
 
    nexttile;
    imagesc([NewPixelSize:NewPixelSize:Xaxislastvalue],  [NewPixelSize:NewPixelSize:Yaxislastvalue], mean(ImageMatNorm2, 3, 'omitnan'));
    caxis([0, 5]);
    title('Image of the mean fold change');
colorbar;

axis equal
   
%  saving this plot

orient(gcf,'landscape');

saveas(gcf, append(path, f, ' intensity of Channel 2', nameNotchstatus, 'treatment.pdf'));


% making the one Yaveraged plot with the SEM
%  ChosenNorm = ImageMatSimp;
%ChosenNorm = ImageMatNorm;
% 
% SEMmolofinterest = std(mean(ChosenNorm, 1), 0, 3, 'omitnan') ./ sqrt(size(ChosenNorm, 3));
% 
% 
% 
%     if exist('classicplot')
%         figure(classicplot);    
%     else 
%          classicplot = figure('Name', 'classic plot', 'Position', [0 0 600 400]);
%     end
% 
% 
% hold on
% 
% title(append(nameofmolofinterest, ' intensity'), 'FontSize', 20)
% 
% xlabel('Distance (um)', 'FontSize', 14);
% 
% ylim([0 3000]);
% ylabel(append( nameofmolofinterest, 'fluorescence intensity'), 'FontSize', 14);
% 
% topcurve = (mean(ChosenNorm, [1 3], 'omitnan') + SEMmolofinterest).';
% lowercurve = (mean(ChosenNorm, [1 3], 'omitnan') - SEMmolofinterest).';
% 
% spatialscale = NewPixelSize:NewPixelSize:(size(ChosenNorm, 2) * NewPixelSize);
% pline1 = plot(spatialscale, mean(ChosenNorm, [1 3], 'omitnan'), '-', 'DisplayName', nameofmolofinterest, 'color', listColor(a,:));
% 
% pfill1 = fill([spatialscale fliplr(spatialscale)], [topcurve.' fliplr(lowercurve).'], ...
%               listColor(a,:), 'linestyle', 'none', 'FaceAlpha', .3, 'DisplayName', 'SEMmol');
% 
%  
%  legend([pline1],  notchstatus, ...
%      'FontSize', 14);
%  


    
 % saving the plot

orient(gcf,'landscape');

% saveas(gcf, append(path, f , ' intensity of Mam with', nameNotchstatus, 'treatment.pdf'));

   

% saving 10 middle pixel in a.txt

% FoldChangeMolofInterest = permute(mean(ChosenNorm, [1], 'omitnan'), [3 2 1]);
% 
% MiddleFoldChange = mean(FoldChangeMolofInterest(:, [(round(((size(FoldChangeMolofInterest, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest, 2)/2) + 5), 0))]), 2);
% 
% writematrix(MiddleFoldChange, strcat(path, f, '10 middle pixels average fold change channel of interest for', nameNotchstatus));
% 




IntensityMolofInterest1 =ImageMatSimp1;

CroppedIntensityMolofInterest1 = [];

for l = 1:size(IntensityMolofInterest1, 3)
    
    CroppedIntensityMolofInterest1(:, :, l) =  IntensityMolofInterest1(:, [(round(((size(IntensityMolofInterest1, 2)/2) - 5), 0)):(round(((size(IntensityMolofInterest1, 2)/2) + 5), 0))], l);
   
end


FoldChangeMolofInterest1 =ImageMatNorm1;

CroppedFoldChangeMolofInterest1 = [];

for l = 1:size(FoldChangeMolofInterest1, 3)
    
    CroppedFoldChangeMolofInterest1(:, :, l) =  FoldChangeMolofInterest1(:, [(round(((size(FoldChangeMolofInterest1, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest1, 2)/2) + 5), 0))], l);
   
end



IntensityMolofInterest2 =ImageMatSimp2;

CroppedIntensityMolofInterest2 = [];

for l = 1:size(IntensityMolofInterest2, 3)
    
    CroppedIntensityMolofInterest2(:, :, l) =  IntensityMolofInterest2(:, [(round(((size(IntensityMolofInterest1, 2)/2) - 5), 0)):(round(((size(IntensityMolofInterest2, 2)/2) + 5), 0))], l);
   
end


FoldChangeMolofInterest2 =ImageMatNorm2;

CroppedFoldChangeMolofInterest2 = [];

for l = 1:size(FoldChangeMolofInterest2, 3)
    
    CroppedFoldChangeMolofInterest2(:, :, l) =  FoldChangeMolofInterest2(:, [(round(((size(FoldChangeMolofInterest2, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest2, 2)/2) + 5), 0))], l);
   
end



numberoffragments = 5;


MiddleIntensityMolofInterest1 = [];

for d = 1:size(CroppedIntensityMolofInterest1, 3)
    start = 1;
    clear k
    for h = 1:numberoffragments
        try 
            start = k(size(k, 2)) +1;
        end
        k = start : (start + ((size(CroppedIntensityMolofInterest1, 1 ) - 1) / numberoffragments ) -1);
        MiddleIntensityMolofInterest1 = [MiddleIntensityMolofInterest1, mean(CroppedIntensityMolofInterest1(k,:, d) ,'all', 'omitnan')];
        
    end
    
end


writematrix(MiddleIntensityMolofInterest1, strcat(path, f, '10 middle pixels intensity cropped in 8 channel 1 for', nameNotchstatus));


MiddleFoldChange1 = [];

for d = 1:size(CroppedFoldChangeMolofInterest1, 3)
    start = 1;
    clear k
    for h = 1:numberoffragments
        try 
            start = k(size(k, 2)) +1;
        end
        k = start : (start + ((size(CroppedFoldChangeMolofInterest1, 1 ) - 1) / numberoffragments ) -1);
        MiddleFoldChange1 = [MiddleFoldChange1, mean(CroppedFoldChangeMolofInterest1(k,:, d) ,'all', 'omitnan')];
        
    end
    
end

writematrix(MiddleFoldChange1, strcat(path, f, '10 middle pixels fold change cropped in 8 channel 1 for', nameNotchstatus));

MiddleIntensityMolofInterest2 = [];

for d = 1:size(CroppedIntensityMolofInterest2, 3)
    start = 1;
    clear k
    for h = 1:numberoffragments
        try 
            start = k(size(k, 2)) +1;
        end
        k = start : (start + ((size(CroppedIntensityMolofInterest2, 1 ) - 1) / numberoffragments ) -1);
        MiddleIntensityMolofInterest2 = [MiddleIntensityMolofInterest2, mean(CroppedIntensityMolofInterest2(k,:, d) ,'all', 'omitnan')];
        
    end
    
end

writematrix(MiddleIntensityMolofInterest2, strcat(path, f, '10 middle pixels intensity cropped in 8 channel 2 for', nameNotchstatus));

MiddleFoldChange2 = [];

for d = 1:size(CroppedFoldChangeMolofInterest2, 3)
    start = 1;
    clear k
    for h = 1:numberoffragments
        try 
            start = k(size(k, 2)) +1;
        end
        k = start : (start + ((size(CroppedFoldChangeMolofInterest2, 1 ) - 1) / numberoffragments ) -1);
        MiddleFoldChange2 = [MiddleFoldChange2, mean(CroppedFoldChangeMolofInterest2(k,:, d) ,'all', 'omitnan')];
        
    end
    
end


writematrix(MiddleFoldChange1, strcat(path, f, '10 middle pixels fold change cropped in 8 channel 2 for', nameNotchstatus));




end


 figure;
 
 % Get coefficients of a line fit through the data.
 
 x = MiddleIntensityMolofInterest1;
 y = MiddleIntensityMolofInterest2;
coefficients = polyfit(x, y, 1);
% Create a new x axis with exactly 1000 points (or whatever you want).
xFit = linspace(min(x), max(x), 1000);
% Get the estimated yFit value for each of those 1000 new x locations.
yFit = polyval(coefficients , xFit);
% Plot everything.
plot(x, y, 'b.', 'MarkerSize', 15); % Plot training data.
hold on; % Set hold on so the next plot does not blow away lslithe one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
grid on;
ylabel('MamHalo intensity')
xlabel('ms2 intensity')

orient(gcf,'landscape');
saveas(gcf, append(path, f , 'Plot correlation intensity 2 ',nameofmolofinterest, '.pdf'));


 figure;
 
 % Get coefficients of a line fit through the data.
 
 x = MiddleFoldChange1;
 y = MiddleFoldChange2;
coefficients = polyfit(x, y, 1);
% Create a new x axis with exactly 1000 points (or whatever you want).
xFit = linspace(min(x), max(x), 1000);
% Get the estimated yFit value for each of those 1000 new x locations.
yFit = polyval(coefficients , xFit);
% Plot everything.
plot(x, y, 'b.', 'MarkerSize', 15); % Plot training data.
hold on; % Set hold on so the next plot does not blow away lslithe one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
grid on;
ylabel('MamHalo fold change')
xlabel('ms2 fold change')



orient(gcf,'landscape');
saveas(gcf, append(path, f , 'Plot fold change ',nameofmolofinterest, '.pdf'));


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

plotBoxplot(AllMatrix, listConditions, listConditions, 0.5 , 0.25, '10 middle pixels', 14, 14, MyColorMap, 0.3, 5, 18, [0, 3000])

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
