close all 
clear all
f = filesep;

%% fill in these for the plot and choose the channel

nameofmolofinterest = 'CSL ';
nameofloctag = "loctag";
ChannelofInterest = 1;
LOWERylim = 0;
UPPERylim = 7;
PROPOR = 2/6;
%PROPOR = 1;
%% getting the folder

path = uigetdir();


blackcontrol = [0, 0, 0]./ 255;
graybetween = [77,77,77]./ 255;
grayexp = [153, 153, 153]./ 255;
mampurpleoff = [218, 124, 163]./ 255;
mampurpleon = [193, 37, 101]./ 255;
mampurplebetween = [206, 81, 132]./ 255;


listConditions = {'LacZ', 'MamDN'};
listConditionsNAME = listConditions;


listColor = cat(1, graybetween, graybetween);
listColor2 = listColor;

AllMatrix = [];
NuclearSignalMatrix = [];

AllMatrix2 = [];
NuclearSignalMatrix2 = [];


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



%% in this section we will normalise the signal on ImageMat by dividing it by one value. This value is the BG, and it will be obtained from doing a mean of the BG matrix

if size(size(BGMat).', 1)> 3

BGMatNormch1 = permute(mean(permute(BGMat(:,:,:,1,:), [1 2 5 3 4]), [1 2], 'omitnan'), [3 2 1]);
BGMatNormch2 = permute(mean(permute(BGMat(:,:,:,2,:), [1 2 5 3 4]), [1 2], 'omitnan'), [3 2 1]);
% 
ImageMatSimp1 = double(permute(ImageMat(:,:,:,1,:), [1 2 5 3 4]));
ImageMatSimp2 = double(permute(ImageMat(:,:,:,2,:), [1 2 5 3 4]));


else
BGMatNormch1 = permute(mean(BGMat, [1 2] , 'omitNan'), [3 2 1]);
ImageMatSimp1 = double(ImageMat);

end

BGMatNormRepeat1 = [];

    for q = 1:size(BGMatNormch1, 1)
        
        BGMatNormRepeat1(:,:, q) = repmat(BGMatNormch1(q), size(ImageMatSimp1, 1), size(ImageMatSimp1, 2));   
    end

  BGMatNormRepeat2 = [];

    for q = 1:size(BGMatNormch1, 1)
        
        BGMatNormRepeat2(:,:, q) = repmat(BGMatNormch2(q), size(ImageMatSimp2, 1), size(ImageMatSimp2, 2));   
    end  


ImageMatNorm1 = ImageMatSimp1 ./ BGMatNormRepeat1;
% 
try
ImageMatNorm2 = ImageMatSimp2 ./ BGMatNormRepeat2;
end


 figure('Name', notchstatus, 'Position', [0 0 470 500]); %for two images, (4/6)
 


 tl = tiledlayout(2, 1,'TileSpacing','Compact');


 
NewPixelSize = mode(PixelMat);
Yaxislastvalue = NewPixelSize * size(ImageMatSimp1, 1);
Xaxislastvalue = NewPixelSize * size(ImageMatSimp1, 2);

% 
% ylabel('distance (um)');
% xlabel('distance (um)');
% colormap(flipud(gray));


nexttile 


if PROPOR < 0.5

onethirdImageMat1 = ImageMatNorm1(round((size(ImageMatSimp1, 1) * (PROPOR))):1:round((size(ImageMatSimp1,1) *(1-PROPOR))), ...
                                  round((size(ImageMatSimp1, 2) * (PROPOR)):1:round((size(ImageMatSimp1,2) *(1-PROPOR)))) , :);
 
else
    onethirdImageMat1 = ImageMatNorm1(round((size(ImageMatSimp1, 1) * (1-PROPOR))):1:round((size(ImageMatSimp1, 1) * (PROPOR))), ...
                                      round((size(ImageMatSimp1, 2) * (1-PROPOR))):1:round((size(ImageMatSimp1, 2) * (PROPOR))) , :);
 
end



    imagesc( [NewPixelSize:NewPixelSize:(NewPixelSize*size(onethirdImageMat1, 2))], ...
             [NewPixelSize:NewPixelSize:(NewPixelSize*size(onethirdImageMat1, 1))], ...
             mean(onethirdImageMat1, 3, 'omitnan'));
    caxis([LOWERylim,  UPPERylim]);
    title('Image of the mean enrichment');
colormap(flipud(gray));
colorbar;

nexttile
% % onethirdImageMat2 = ImageMatNorm2;
% 
% %     onethirdImageMat2 = ImageMatNorm2( round((size(ImageMatSimp2,1) *(3/8))):1:round((size(ImageMatSimp2,1) *(5/8))), ...
% %                                         round((size(ImageMatSimp2, 2) .*(1/6))):1:round((size(ImageMatSimp2,2) *(5/6))), ...
% %                                         :);
% % 

if PROPOR < 0.5

onethirdImageMat2 = ImageMatNorm2(round((size(ImageMatSimp2, 1) * (PROPOR))):1:round((size(ImageMatSimp2,1) *(1-PROPOR))), ...
                                  round((size(ImageMatSimp1, 2) * (PROPOR)):1:round((size(ImageMatSimp2,2) *(1-PROPOR)))) , :);
 
else
    onethirdImageMat2 = ImageMatNorm2(round((size(ImageMatSimp2, 1) * (1-PROPOR))):1:round((size(ImageMatSimp2, 1) * (PROPOR))), ...
                                      round((size(ImageMatSimp2, 2) * (1-PROPOR))):1:round((size(ImageMatSimp2, 2) * (PROPOR))) , :);
 
end
    imagesc( [NewPixelSize:NewPixelSize:(NewPixelSize*size(onethirdImageMat2, 2))], ...
             [NewPixelSize:NewPixelSize:(NewPixelSize*size(onethirdImageMat2, 1))], ...
             mean(onethirdImageMat2, 3, 'omitnan'));
    caxis([0, 10]);
    title('Image of the mean enrichment');
colormap(flipud(gray));

colorbar;


    
%% saving this plot
% 
orient(gcf,'landscape');

%  saveas(gcf, append(path, f, 'enrichment of', nameofmolofinterest, ' CROPPEDwith1-3', listConditionsNAME{a}, 'treatment.pdf'));


%% making the one Yaveraged plot with the SEM

ChosenNorm = onethirdImageMat1;
ChosenNorm2 = onethirdImageMat2;
SEMmolofinterest = std(mean(ChosenNorm, 1), 0, 3, 'omitnan') ./ sqrt(size(ChosenNorm, 3));


% SEMmolofinterest2 = std(mean(ChosenNorm2, 1), 0, 3, 'omitnan') ./ sqrt(size(ChosenNorm2, 3));


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

spatialscale = NewPixelSize:NewPixelSize:(size(ChosenNorm, 2) * NewPixelSize);

Mean3ChosenNorm2 = mean(ChosenNorm2, [1 3 ]);
[M, PosLocTag] = max(Mean3ChosenNorm2)

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
pline1 = plot(spatialscale, mean(ChosenNorm, [1 3], 'omitnan'), '-', 'DisplayName', nameofmolofinterest, 'color', listColor(a,:));

pfill1 = fill([spatialscale fliplr(spatialscale)], [topcurve.' fliplr(lowercurve.')], ...
              listColor(a,:), 'linestyle', 'none', 'FaceAlpha', .3, 'DisplayName', 'SEMmol');
xlim([spatialscale(1), spatialscale(end)]);
 
 legend([pline1],  notchstatus, ...
     'FontSize', 14);

    
 %% saving the plot

orient(gcf,'landscape');
% saveas(gcf, append(path, f , ' intensity with', nameNotchstatus, 'treatment.pdf'));

%% saving 10 middle pixel in a.txt

FoldChangeMolofInterest = permute(mean(ChosenNorm, [1], 'omitnan'), [3 2 1]);

MiddleFoldChange = mean(FoldChangeMolofInterest(:, [(round(((size(FoldChangeMolofInterest, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest, 2)/2) + 5), 0))]), 2);

AllMatrix = padconcatenation(AllMatrix, MiddleFoldChange, 2);


% for b = 1:size(ImageMatSimp1, 3)
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
%     imagesc([NewPixelSize:NewPixelSize:Xaxislastvalue],  [NewPixelSize:NewPixelSize:Yaxislastvalue], ImageMatSimp1(:,:, b));
%     clim([1, 2000]);
%     title('Intensity');
%     colorbar;
%  axis equal
%  
%     nexttile;
%     imagesc([NewPixelSize:NewPixelSize:Xaxislastvalue],  [NewPixelSize:NewPixelSize:Yaxislastvalue], ImageMatNorm1(:,:, b));
%     caxis([0.5, 1.5]);
%     title('Enrichment');
% colorbar;
% orient(gcf,'landscape');
% saveas(gcf, append(path, f , 'Individual Plots', f, nameofmolofinterest, listConditions{a},  'individual example number ', num2str(b), '.pdf'));
% close(gcf)
% 
% 
% end


end



 figure(classicplot);

orient(gcf,'landscape');
% saveas(gcf, append(path, f , 'Plot Yavgd enrichment cropped channel1 colours changed with loctag', '.pdf'));

% 
% figure(classicplot2);
% 
% orient(gcf,'landscape');
% saveas(gcf, append(path, f , 'Plot Yavgd enrichment cropped channel2 colours changed', '.pdf'));




boxplot = figure('Name', 'boxplot plot', 'Position', [0 0 400 600]);

MyColorMap = listColor;

hold on
% set(gca, 'YScale', 'log')

ylim([LOWERylim UPPERylim])
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




orient(gcf,'landscape');
% saveas(gcf, append(path, f , 'Plot box plot cropped channel1 colours changed combo', '.pdf'));

% not 
[h, p] = ranksum(AllMatrix(:, 2), AllMatrix(:, 1))



figure(boxplot);

%  violin(Y,'xlabel',{'a','b','c','d'},'facecolor',[1 1 0;0 1 0;.3 .3 .3;0 0.3 0.1],'edgecolor','b',...
% 'bw',0.3,...
% 'mc','k',...
% 'medc','r--')
% ylabel('\Delta [yesno^{-2}]','FontSize',14)

 violinplotobj = violin(AllMatrix, 'xlabel', listConditions, 'facecolor',listColor, 'edgecolor','none', ...
'mc','',...
'medc','')

ylim([LOWERylim,  UPPERylim])
% set(gca, 'YScale', 'log')
% violin(AllMatrix, 'xlabel', listConditions, 'facecolor', MyColorMap, 'edgecolor', 'none', ...
%     'mc', [], 'medc', [])

% , listConditions, listConditions, 0.5 , 0.25, '10 middle pixels', 14, 14, MyColorMap, 0.3, 5, 18, [LOWERylim,  UPPERylim])

orient(gcf,'landscape');
% saveas(gcf, append(path, f , 'Combo plot', '.pdf'));

Fitting = figure('Name', 'fitting', 'Position', [0 0 400 600]);

     
gmdista = fitgmdist(AllMatrix(:, 1), 2);
gmdistb = fitgmdist(AllMatrix(:, 2), 2);
% gmdistc = fitgmdist(AllMatrix(:, 3), 2);

gmsigmaa = gmdista.Sigma;
gmsigmab = gmdistb.Sigma;
% gmsigmac = gmdistc.Sigma;

gmmua = gmdista.mu;
gmuab = gmdistb.mu;
% gmsmuc = gmdistc.mu;


gmwta = gmdista.ComponentProportion;
gmwtb = gmdistb.ComponentProportion;
% gmwtc = gmdistc.ComponentProportion;
min_val = LOWERylim;
max_val = UPPERylim;

% histogram(notch_data,20, 'Normalization', 'pdf')
x = min_val:0.0001:max_val;
% ylim([LOWERylim UPPERylim])

hold on;
xlim([0 UPPERylim])
for j = 1:ndims(gmdista)
    line(x, gmdista.PComponents(j) * normpdf(x, gmdista.mu(j), sqrt(gmdista.Sigma(j))),'color',listColor(1, :));
end

% plot(pdf(gmdistb, x'), x, 'k','color', listColor(2, :))

for j = 1:ndims(gmdistb)
    line(x, gmdistb.PComponents(j) * normpdf(x, gmdistb.mu(j), sqrt(gmdistb.Sigma(j))),'color',listColor(2, :));
end
% plot(pdf(gmdistc, x'), x, 'k','color', listColor(3, :))

for j = 1:ndims(gmdistc)
    line(x, gmdistc.PComponents(j) * normpdf(x, gmdistc.mu(j), sqrt(gmdistc.Sigma(j))),'color',listColor(3, :));
end


% ​
gmdistLac = fitgmdist(AllMatrix(:, 2),2);
gmsigmaLac = gmdistLac.Sigma;
gmmuLac = gmdistLac.mu;
gmwtLac = gmdistLac.ComponentProportion;
plot(pdf(gmdistLac, x'), x, 'r')
% histogram(lac_data,20, 'Normalization', 'pdf')
x = min_val:0.0001:max_val;
% xlim([min_val max_val])

plot(pdf(gmdistLac, x', 'color', listColor(:, 1)), x, 'k')
hold on;


ManualCount = readtable(append(path, f, 'manualcount.csv'))

ManualpropPlot = figure('Name', 'classic plot', 'Position', [0 0 400 600]);
ylim([0.5, 2])

variable1 = ManualCount{:, 1}
variable2 = ManualCount{:, 2}
figure
hold on
bar(1,[sum(ManualCount{:, 1}, 'omitnan')/((size(ManualCount{:, 1}, 1) - sum(isnan(ManualCount{:, 1}))))], 'stacked')
bar(2,[sum(ManualCount{:, 2}, 'omitnan')/((size(ManualCount{:, 2}, 1) - sum(isnan(ManualCount{:, 2}))))], 'stacked')
ylim([0 1])
% 
% plotBoxplotMATLABlike(ManualCount{:,:}, listConditionsnames, listConditionsnames, 0.8 , 0.2, 'ManualpropPlot', 14, 14, MyColorMap, 0.3, 5, 18, [0, 1])
% saveas(gcf, append(path, f , 'Boxplot manual  ',nameofmolofinterest, '.pdf'));
% 
% figure
% 
%     bar(a,[gmwtb(2)] )
% ylim([0, 1])
% xlim([0, 3])


orient(gcf,'landscape');
% saveas(gcf, append(path, f , 'fitting ', '.pdf'));

orient(gcf,'landscape');
% saveas(gcf, append(path, f , ' prop ', '.pdf'));
