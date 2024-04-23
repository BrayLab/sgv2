%%this script will take mat files with cropped images that are contained
%%within folders (for each experiment) and generate plots of different sorts: ones that average the
%%images, averaging the Y dimension, and making boxplots and violin plots.
%%Lastly, it will do a gaussian curve fitting that will fit one or more
%%populations with the data distribution

% 
% 
% Clear variables and close figures
clear variables;
close all;

% Define file separator character
FileSep = filesep;
f = filesep;
% Specify molecule of interest, localization tag, and channel of interest


nameofmolofinterest = 'Hairless';
nameofloctag = "loctag";



listConditions = {'ON', 'OFF'};
listConditionsNAME = listConditions;
listConditionsnames = listConditions;

nameofloctag = "loctag";
ChannelofInterest = 1;


% Get user input for y-axis limits of plot
% LOWERylim = input("What is the lower ylim? ");
% UPPERylim = input("What is the upper ylim? ");

% Set values for y-axis and proportion
LOWERylim = 0;
UPPERylim = 4;
PROPOR = 1;

% Get directory from user
path = uigetdir();

% Define color palettes for different conditions
% Define color palettes for different conditions
blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];
suhbetween = [122, 167, 63] ./ 255;
suhgreenoff = [139, 191, 72] ./ 255;
suhgreenon = [104, 143, 54] ./ 255;
mampurpleoff = [218, 124, 163] ./ 255;
mampurpleon = [193, 37, 101] ./ 255;
mampurplebetween = [206, 81, 132] ./ 255;
NICDpurpleON = [126, 102, 158] ./ 255;
NICDpurpleOFF = [191, 179, 207] ./ 255;
skdstrong = [252, 192, 48] ./ 255;
skdmid = [254, 224, 152] ./ 255;
skdvweak = [253, 213, 117] ./ 255;
blackcontrol = [0, 0, 0] ./ 255;
graybetween = [77, 77, 77] ./ 255;
grayexp = [153, 153, 153] ./ 255;
polIIOFF = [183, 208, 235] ./ 255;
polIION = [112, 162, 215] ./ 255;
% 
% listColor = cat(1, mampurplebetween, mampurpleon);
% listColor2 = cat(1, mampurplebetween, mampurpleon);
listColor = cat(1, suhbetween, suhgreenon);
listColor2 =  cat(1, suhbetween, suhgreenon);
AllMatrix = [];
AllMatrix2 = [];
% Iterate through all folders in the specified directory
for a = 1:length(listConditions)

nameNotchstatus = listConditions{a};
notchstatus = listConditions{a};
disp(notchstatus);



parentdirectory = dir(append(path, FileSep, '*', nameNotchstatus, '*'));


ImageMat = [];
BGMat = []; 
PixelMat = [];
MetadataMat = [];

% Iterate through all folders that match the specified condition
%this loop will go over every folder that has the name nameNotchstatus on i
 for t = 1:length({parentdirectory.name})
    
    disp(parentdirectory(t).name);
    
    
    % Iterate through all .mat files in the current folder
    MATDirectory = dir(append(parentdirectory(t).folder, FileSep, parentdirectory(t).name, FileSep,  '*.mat'));
       

    MATDirectoryfullpath = [];
    
   % Concatenate the full file path of all .mat files
    if isempty(MATDirectory);
        
    else
        for u = 1 : size(MATDirectory, 1)
        pos = size(MATDirectoryfullpath, 1)+1;

        MATDirectoryfullpath = [MATDirectoryfullpath, {append(MATDirectory(u).folder, FileSep , MATDirectory(u).name)}];
    
        end
    end

%loop to import all the mat files into the right variable
for n = 1:size(MATDirectoryfullpath, 2)
       
    if contains(MATDirectoryfullpath{n},'metadata', 'IgnoreCase', true)

        Metadata = load(MATDirectoryfullpath{n});
        dimensionsinMetadata = ndims(Metadata) + 1;
        MetadataMat = cat(dimensionsinMetadata, MetadataMat, Metadata); 


    elseif contains(MATDirectoryfullpath{n},'pixelsize', 'IgnoreCase', true)

        PixelSize = load(MATDirectoryfullpath{n});
        dimensionsinPixelSize = ndims(PixelSize.PhysicalSizePixel) + 1;
        PixelMat = cat(ndims(PixelSize.PhysicalSizePixel), PixelMat, PixelSize.PhysicalSizePixel); 
   

    elseif contains(MATDirectoryfullpath{n},'ROIMatrix', 'IgnoreCase', true)

        RoiMat = load(MATDirectoryfullpath{n});
        dimensionsinRoiMat = ndims(RoiMat.IntensityROI) + 1;
        ImageMat = cat(dimensionsinRoiMat, ImageMat, RoiMat.IntensityROI); 

    elseif contains(MATDirectoryfullpath{n},'BGmasked', 'IgnoreCase', true)

        BGmask = load(MATDirectoryfullpath{n});
        dimensionsinBGmask = ndims(BGmask.BackgroundIntensityExport) + 1;
        BGMat = cat(dimensionsinBGmask, BGMat, BGmask.BackgroundIntensityExport);
    else 

        disp('There is a .mat file with no appropriate name.');

    end
end

end

%% Normalize the signal on ImageMat by dividing it by the mean of the BG matrix

if size(size(BGMat).', 1)> 3

BGMatNorm1 = permute(mean(permute(BGMat(:,:,:,1,:), [1 2 5 3 4]), [1 2], 'omitnan'), [3 2 1]);
ImageMatSimp1 = double(permute(ImageMat(:,:,:,1,:), [1 2 5 3 4]));

BGMatNorm2 = permute(mean(permute(BGMat(:,:,:,2,:), [1 2 5 3 4]), [1 2], 'omitnan'), [3 2 1]);
ImageMatSimp2 = double(permute(ImageMat(:,:,:,2,:), [1 2 5 3 4]));


BGMatNorm = permute(mean(permute(BGMat(:,:,:,ChannelofInterest,:), [1 2 5 3 4]), [1 2], 'omitnan'), [3 2 1]);
ImageMatSimp = double(permute(ImageMat(:,:,:,ChannelofInterest,:), [1 2 5 3 4]));

else


BGMatNorm1 = permute(mean(BGMat, [1 2] , 'omitNan'), [3 2 1]);
ImageMatSimp1 = double(ImageMat);


BGMatNorm2 = BGMatNorm1;
ImageMatSimp2 = ImageMatSimp1;

BGMatNorm = BGMatNorm1;
ImageMatSimp = ImageMatSimp1;

end

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

% Create figure with one tile
figure('Name', notchstatus, 'Position', [0 0 230*(PROPOR*2) 250]);
tl = tiledlayout(1, 1,'TileSpacing','Compact');

% Create image of the mean enrichment
NewPixelSize = mode(PixelMat);
Yaxislastvalue = NewPixelSize * size(ImageMatSimp1, 1);
Xaxislastvalue = NewPixelSize * size(ImageMatSimp1, 2);

ylabel('distance (um)');
xlabel('distance (um)');
colormap(flipud(gray));

% This is for cropped x and y
nexttile

% Crop the image if desired
 onethirdImageMat1 = ImageMatNorm1;
%onethirdImageMat1 = ImageMatSimp;

% onethirdImageMat1 = ImageMatNorm1(:, round((size(ImageMatSimp1, 2) * (PROPOR)):1:round((size(ImageMatSimp1,2) *(1-PROPOR)))), :);

imagesc([NewPixelSize:NewPixelSize:(size(onethirdImageMat1, 2))], ...
[NewPixelSize:NewPixelSize:(size(onethirdImageMat1, 1))], ...
mean(onethirdImageMat1, 3, 'omitnan'));

caxis([LOWERylim, UPPERylim]);
title('Image of the mean enrichment');
colormap(flipud(gray));
colorbar;


onethirdImageMat2 = ImageMatNorm2;
%     onethirdImageMat2 = ImageMatNorm2( round((size(ImageMatSimp2,1) *(3/8))):1:round((size(ImageMatSimp2,1) *(5/8))), ...
%                                         round((size(ImageMatSimp2, 2) .*(1/6))):1:round((size(ImageMatSimp2,2) *(5/6))), ...
%                                         :);
% 
% if PROPOR < 0.5
% 
% onethirdImageMat2 = ImageMatNorm2(:,round((size(ImageMatSimp1, 2) * (PROPOR)):1:round((size(ImageMatSimp1,2) *(1-PROPOR)))) , :);
% else
%     onethirdImageMat2 = ImageMatNorm2(:,round((size(ImageMatSimp1, 2) * (1-PROPOR)):1:round((size(ImageMatSimp1,2) *(PROPOR)))) , :);
% end
%    

%     imagesc( [NewPixelSize:NewPixelSize:(NewPixelSize*size(onethirdImageMat2, 2))], ...
%              [NewPixelSize:NewPixelSize:(NewPixelSize*size(onethirdImageMat2, 1))], ...
%              mean(onethirdImageMat2, 3, 'omitnan'));
%     caxis([0, 10]);
%     title('Image of the mean enrichment');
% colormap(flipud(gray));
% 
% colorbar;


    
%% saving this plot
% 
orient(gcf,'landscape');

saveas(gcf, append(path, FileSep, 'enrichment of', nameofmolofinterest, ' CROPPEDwith1-3', listConditionsNAME{a}, 'treatment.pdf'));


%% making the one Yaveraged plot with the SEM

ChosenNorm = onethirdImageMat1;
try
    ChosenNorm2 = onethirdImageMat2;
end
SEMmolofinterest = std(mean(ChosenNorm, 1), 0, 3, 'omitnan') ./ sqrt(size(ChosenNorm, 3));

try
SEMmolofinterest2 = std(mean(ChosenNorm2, 1), 0, 3, 'omitnan') ./ sqrt(size(ChosenNorm2, 3));
end

    if exist('classicplot')
        figure(classicplot);    
    else 
         classicplot = figure('Name', 'classic plot', 'Position', [0 0 450 400]);
    end


hold on

title(append(nameofmolofinterest, 'enrichment channel 1'), 'FontSize', 20)

xlabel('distance (um)', 'FontSize', 14);


ylim([LOWERylim,  UPPERylim])
ylabel(append( nameofmolofinterest, 'fluorescence intensity'), 'FontSize', 14);

topcurve = (mean(ChosenNorm, [1 3], 'omitnan') + SEMmolofinterest).';
lowercurve = (mean(ChosenNorm, [1 3], 'omitnan') - SEMmolofinterest).';

Mean3ChosenNorm = mean(ChosenNorm, [1 3 ]);
[M, PosLocTag] = max(Mean3ChosenNorm)

spatialscaleOLD = NewPixelSize:NewPixelSize:(size(ChosenNorm, 2) * NewPixelSize);
spatialscale = (spatialscaleOLD(1) - spatialscaleOLD(PosLocTag)):NewPixelSize:(spatialscaleOLD(end)-spatialscaleOLD(PosLocTag));

% for q = 1:size(ChosenNorm, 3)
%    plot(spatialscale, mean(ChosenNorm(:,:,q), [1], 'omitnan'), '-', 'DisplayName', nameofmolofinterest, 'color', [0, 0, 0]);
% end
locustagcolor = [0 0 0 0.1];

xline(0, 'LineWidth', 50, 'color', [0 0 0 0.001])

pline1 = plot(spatialscale, mean(ChosenNorm, [1 3], 'omitnan'), '-', 'DisplayName', nameofmolofinterest, 'color', listColor(a,:));

pfill1 = fill([spatialscale fliplr(spatialscale)], [topcurve.' fliplr(lowercurve.')], ...
              listColor(a,:), 'linestyle', 'none', 'FaceAlpha', .3, 'DisplayName', 'SEMmol');
xlim([spatialscale(1), spatialscale(end)]);


 legend([pline1],  notchstatus, ...
     'FontSize', 14);
%  


% 
%     if exist('classicplot2')
%         figure(classicplot2);    
%     else 
%          classicplot2 = figure('Name', 'classic plot2', 'Position', [0 0 600 400]);
%     end
% 
% 
% hold on
% 
% title(append(nameofmolofinterest, ' enrichement channel 2'), 'FontSize', 20)
% 
% xlabel('distance (um)', 'FontSize', 14);
% 
% 
% ylim([0,  4])
% ylabel(append( nameofmolofinterest, 'enrichment'), 'FontSize', 14);
% 
% topcurve2 = (mean(ChosenNorm2, [1 3], 'omitnan') + SEMmolofinterest2).';
% lowercurve2 = (mean(ChosenNorm2, [1 3], 'omitnan') - SEMmolofinterest2).';
% 
% spatialscale2 = NewPixelSize:NewPixelSize:(size(ChosenNorm2, 2) * NewPixelSize);
% 
% 
% Mean3ChosenNorm = mean(ChosenNorm, [1 3 ]);
% [M, PosLocTag] = max(Mean3ChosenNorm);
% 
% spatialscale2OLD = NewPixelSize:NewPixelSize:(size(ChosenNorm2, 2) * NewPixelSize);
% spatialscale2 = (spatialscale2OLD(1) - spatialscale2OLD(PosLocTag)):NewPixelSize:(spatialscale2OLD(end)-spatialscale2OLD(PosLocTag));
% 
% pline1 = plot(spatialscale2, mean(ChosenNorm2, [1 3], 'omitnan'), '-', 'DisplayName', nameofmolofinterest, 'color', listColor2(a,:));
% 
% pfill1 = fill([spatialscale2 fliplr(spatialscale2)], [topcurve2.' fliplr(lowercurve2.')], ...
%               listColor2(a,:), 'linestyle', 'none', 'FaceAlpha', .3, 'DisplayName', 'SEMmol');
% xlim([spatialscale(1), spatialscale(end)]);
%  
%  legend([pline1],  notchstatus, ...
%      'FontSize', 14);
%  

    
 %% saving the plot
% 
orient(gcf,'landscape');

saveas(gcf, append(path, f , 'intensity with', nameNotchstatus, 'treatment.pdf'));

%    

%% saving 10 middle pixel in a.txt
% 
FoldChangeMolofInterest = permute(mean(ChosenNorm, [1], 'omitnan'), [3 2 1]);

MiddleFoldChange = mean(FoldChangeMolofInterest(:, [(round(((size(FoldChangeMolofInterest, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest, 2)/2) + 5), 0))]), 2);

writematrix(MiddleFoldChange, strcat(path, FileSep, '10 middle pixels average fold change for', nameNotchstatus));


FoldChangeMolofInterest2 = permute(mean(ChosenNorm2, [1], 'omitnan'), [3 2 1]);

MiddleFoldChange2 = mean(FoldChangeMolofInterest2(:, [(round(((size(FoldChangeMolofInterest2, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest2, 2)/2) + 5), 0))]), 2);

writematrix(MiddleFoldChange2, strcat(path, FileSep, '10 middle pixels average channel2 fold change for', nameNotchstatus));

% 
% % 
%          
% 
AllMatrix = padconcatenation(AllMatrix, MiddleFoldChange, 2);
AllMatrix2 = padconcatenation(AllMatrix2, MiddleFoldChange2, 2);
% NuclearSignalMatrix = padconcatenation(NuclearSignalMatrix, BGMatNorm  , 2);
% 

% %saving individual images
% try
% mkdir(append(path, f , 'Individual Plots'));
% end
% 
% for b = 1:size(ImageMatSimp, 3)
% 
% 
% 
% individualplot = figure('Name', append('Indv plot', num2str(b)), 'Position', [0 0 900 235]);
% 
% tl = tiledlayout(1, 2,'TileSpacing','Compact');
% 
% 
% title(tl, append('Intensity of ', nameofmolofinterest, ' in ',  nameNotchstatus, 'number', num2str(b)));
% ylabel(tl, 'distance (um)');
% xlabel(tl, 'distance (um)');
% colormap(parula);
%     nexttile
%     imagesc([NewPixelSize:NewPixelSize:Xaxislastvalue],  [NewPixelSize:NewPixelSize:Yaxislastvalue], ImageMatSimp(:,:, b));
%     clim([1, 2000]);
%     title('Intensity');
%     colorbar;
%  axis equal
%  
%     nexttile;
%     imagesc([NewPixelSize:NewPixelSize:Xaxislastvalue],  [NewPixelSize:NewPixelSize:Yaxislastvalue], ImageMatNorm(:,:, b));
%     caxis([0, 3]);
%     title('Enrichment');
% colorbar;
% orient(gcf,'landscape');
%  saveas(gcf, append(path, f , 'Individual Plots', f, nameofmolofinterest, listConditionsnames{a},  'individual example number ', num2str(b), '.pdf'));
% close(gcf)
% 
% 
% end

end



 figure(classicplot);

orient(gcf,'landscape');
 saveas(gcf, append(path, FileSep , 'Plot Yavgd enrichment cropped channel1 colours changed with locustag senexina', '.pdf'));


% figure(classicplot2);
% 
% orient(gcf,'landscape');
% %  saveas(gcf, append(path, FileSep , 'Plot Yavgd enrichment cropped channel2 colours changed with locustagsenexina', '.pdf'));
% 
% 


boxplot = figure('Name', 'boxplot plot', 'Position', [0 0 400 600]);

MyColorMap = listColor;

hold on


plotBoxplotMATLABlike(AllMatrix, listConditions, listConditions, 0.5 , 0.25, '10 middle pixels', 14, 14, MyColorMap, 0.3, 5, 18, [LOWERylim,  UPPERylim])
% 
% 
% AllMatrixcomb = [];
% listColorcomb = [];
% 
% for g = 1:size(AllMatrix, 2)
% AllMatrixcomb = padconcatenation(AllMatrixcomb, AllMatrix2(:, g), 2);
% AllMatrixcomb = padconcatenation(AllMatrixcomb, AllMatrix(:, g), 2);
% 
% listColorcomb = padconcatenation(listColorcomb, listColor2(g, :), 1);
% listColorcomb = padconcatenation(listColorcomb, listColor(g, :), 1);
% 
% end
% 
% MyColorMap = [listColor2; listColor];
% 
% boxplot = figure('Name', 'boxplot plot', 'Position', [0 0 800 600]);
% 
% plotBoxplotMATLABlike(padconcatenation(AllMatrix2, AllMatrix, 2), [listConditions, listConditions], [listConditions, listConditions], 0.5 , 0.25, '10 middle pixels', 14, 14, MyColorMap, 0.3, 5, 18, [0,  5.5])
% 
% % 
% % boxplot = figure('Name', 'boxplot plot', 'Position', [0 0 800 600]);
% % 
% % MyColorMapcomb = listColorcomb
% % plotBoxplotMATLABlike(AllMatrixcomb, [listConditions, listConditions], [listConditions, listConditions], 0.5 , 0.25, '10 middle pixels', 14, 14, MyColorMapcomb, 0.3, 5, 18, [0,  5.5])
% % 
% 


orient(gcf,'landscape');
saveas(gcf, append(path, FileSep , 'Plot box plot cropped channel1 colours changed senexina', '.pdf'));

% not 
[h, p] = ranksum(AllMatrix(:, 2), AllMatrix(:, 1))
