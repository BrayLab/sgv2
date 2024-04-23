close all 
clear all
f = filesep;

%% fill in these for the plot and choose the channel

nameofmolofinterest = 'Mam';
nameofloctag = "loctag";
ChannelofInterest = 1;
LOWERylim = 0;
UPPERylim = 4;
 %PROPOR = 4.5/6;
PROPOR = 1;
%% getting the folder

path = uigetdir();


blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];


c = [139, 191, 72]./ 255;
suhbetween = [122, 167, 63]./ 255;
suhgreenoff = [139, 191, 72]./ 255;
suhgreenon = [104, 143, 54]./ 255;
mampurpleoff = [218, 124, 163]./ 255;
mampurpleon = [193, 37, 101]./ 255;
mampurplebetween = [206, 81, 132]./ 255;

NICDpurpleON = [126, 102, 158]./ 255;
NICDpurpleOFF = [191,179,207]./ 255;

skdstrong = [252,192,48]./ 255;
skdmid = [254,224,152]./ 255;
skdvweak = [253,213,117]./ 255;


blackcontrol = [0, 0, 0]./ 255;
graybetween = [77,77,77]./ 255;
grayexp = [153, 153, 153]./ 255;



polIIOFF = [183,208,235]./ 255;
polIION = [112,162,215]./ 255;

listConditions = {'MamGFPwt', 'MamGFPmutex2'};
listConditionsNAME = listConditions
% 
% listConditions = {'LacZ*Ecdysone', 'NDECD*EtOH', 'NDECD*Ecdysone'};
% listConditionsNAME = {'LacZEcdysone', 'NDECDEtOH', 'NDECDEcdysone'};
% listColor = cat(1, graybetween); %, blackcontrol);
% % listColor2 = [NICDpurpleOFF; NICDpurpleON];

% listColor = cat(1, graybetween, grayexp)%,  orange, blue);
%listColor = cat(1, suhgreenoff, suhgreenon)
% listColor = cat(1, blackcontrol, graybetween, grayexp);
% listColor = cat(1, skdmid, skdstrong);

listColor = cat(1, graybetween, blackcontrol);

%  listColor = cat(1, mampurplebetween, mampurpleoff);
listColor2 = listColor;
% listColor= cat(1, suhgreenon, suhgreenoff);

AllMatrix = [];
NuclearSignalMatrix = [];

AllMatrix2 = [];
NuclearSignalMatrix2 = [];

AllMatrix3 = [];
NuclearSignalMatrix3 = [];


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
BGMatNormch3 = permute(mean(permute(BGMat(:,:,:,3,:), [1 2 5 3 4]), [1 2], 'omitnan'), [3 2 1]);
% 
ImageMatSimp1 = double(permute(ImageMat(:,:,:,1,:), [1 2 5 3 4]));
ImageMatSimp2 = double(permute(ImageMat(:,:,:,2,:), [1 2 5 3 4]));
ImageMatSimp3 = double(permute(ImageMat(:,:,:,3,:), [1 2 5 3 4]));

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


  BGMatNormRepeat3 = [];

    for q = 1:size(BGMatNormch1, 1)
        
        BGMatNormRepeat3(:,:, q) = repmat(BGMatNormch3(q), size(ImageMatSimp3, 1), size(ImageMatSimp3, 2));   
    end  


 %ImageMatNorm1 = ImageMatSimp1 ./ BGMatNormRepeat1;


%ImageMatNorm1 = ImageMatSimp1;
ImageMatNorm1 = ImageMatSimp1 ./ BGMatNormRepeat1;

%ImageMatNorm2 = ImageMatSimp2;
ImageMatNorm2 = ImageMatSimp2 ./ BGMatNormRepeat2;

%ImageMatNorm3 = ImageMatSimp3;
ImageMatNorm3 = ImageMatSimp3 ./ BGMatNormRepeat3;


% 

%figure('Name', notchstatus, 'Position', [0 0 450 500]); %for two images 
figure('Name', notchstatus, 'Position', [0 0 230*(PROPOR ) (250*3)/2]); %for two images, (4/6)
% figure('Name', notchstatus, 'Position', [0 0 230 250]); %for two images, (4/6)
 %  figure('Name', notchstatus, 'Position', [0 0 460 225]); %for two images, (2/3) 


 tl = tiledlayout(1, 1,'TileSpacing','Compact');



%plot with an image where each pixel is an average and its normalised
%version


 
NewPixelSize = mode(PixelMat);
Yaxislastvalue = NewPixelSize * size(ImageMatSimp1, 1);
Xaxislastvalue = NewPixelSize * size(ImageMatSimp1, 2);


ylabel('distance (um)');
xlabel('distance (um)');
colormap(flipud(gray));


 nexttile 

 
    imagesc( [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm1, 2))], ...
             [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm1, 1))], ...
             mean(ImageMatNorm1, 3, 'omitnan'));
    caxis([0.5,  UPPERylim/2.5]);
    title('Mean Med1 intensity');
colormap(flipud(gray));
colorbar;

 nexttile 

 
    imagesc( [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm3, 2))], ...
             [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm3, 1))], ...
             mean(ImageMatNorm3, 3, 'omitnan'));
    caxis([0.5,  UPPERylim/1.5]);
    title('Mean Rbp1 intensity');
colormap(flipud(gray));
colorbar;

 nexttile 

    imagesc( [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm2, 2))], ...
             [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm2, 1))], ...
             mean(ImageMatNorm2, 3, 'omitnan'));
    caxis([LOWERylim,  UPPERylim]);
    title('Mean Rbp1 intensity');
colormap(flipud(gray));
colorbar;



    
%% saving this plot
% 
% orient(gcf,'landscape');

saveas(gcf, append(path, f, 'enrichment of', nameofmolofinterest, ' CROPPEDwith1-3', listConditionsNAME{a}, 'treatment.pdf'));


%% making the one Yaveraged plot with the SEM

% ChosenNorm = onethirdImageMat1;


%% saving 10 middle pixel in a.txt
% 
FoldChangeMolofInterest = permute(mean(ImageMatNorm1, [1], 'omitnan'), [3 2 1]);
MiddleFoldChange = mean(FoldChangeMolofInterest(:, [(round(((size(FoldChangeMolofInterest, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest, 2)/2) + 5), 0))]), 2);
writematrix(MiddleFoldChange, strcat(path, f, '10 middle pixels average fold change for', nameNotchstatus));


FoldChangeMolofInterest2 = permute(mean(ImageMatNorm2, [1], 'omitnan'), [3 2 1]);
MiddleFoldChange2 = mean(FoldChangeMolofInterest2(:, [(round(((size(FoldChangeMolofInterest2, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest2, 2)/2) + 5), 0))]), 2);
writematrix(MiddleFoldChange2, strcat(path, f, '10 middle pixels average channel2 fold change for', nameNotchstatus));

FoldChangeMolofInterest3 = permute(mean(ImageMatNorm3, [1], 'omitnan'), [3 2 1]);
MiddleFoldChange3 = mean(FoldChangeMolofInterest3(:, [(round(((size(FoldChangeMolofInterest3, 2)/2) - 5), 0)):(round(((size(FoldChangeMolofInterest2, 2)/2) + 5), 0))]), 2);
writematrix(MiddleFoldChange3, strcat(path, f, '10 middle pixels average channel3 fold change for', nameNotchstatus));



AllMatrix = padconcatenation(AllMatrix, MiddleFoldChange, 2);
AllMatrix2 = padconcatenation(AllMatrix2, MiddleFoldChange2, 2);
AllMatrix3 = padconcatenation(AllMatrix3, MiddleFoldChange3, 2);


%saving individual images
try
mkdir(append(path, f , 'Individual Plots'));
end

% 
% for b = 1:size(ImageMatSimp1, 3)
% 
% 
% 
% individualplot = figure('Name', append('Indv plot', num2str(b)), 'Position', [0 0 235 360]);
% 
% tl = tiledlayout(3, 1,'TileSpacing','Compact');
% 
%  nexttile 
% 
%  title(tl, append('Med1 Intensity', ' in ', 'cell', num2str(b)));
% 
%  
%     imagesc( [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm1, 2))], ...
%              [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm1, 1))], ...
%              ImageMatNorm1(:, :, b));
%     clim([LOWERylim,  UPPERylim/1.5]);
%     title('Image of the mean enrichment');
% colorbar;
% 
%  nexttile 
% 
%  title(tl, append('Rbp Intensity', ' in ', 'cell', num2str(b)));
% 
%  
%     imagesc( [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm3, 2))], ...
%              [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm3, 1))], ...
%              ImageMatNorm3(:, :, b));
%     clim([LOWERylim,  UPPERylim/1.5]);
%     title('Image of the mean enrichment');
%     colorbar;
% 
%  
%     nexttile;
% 
%      title(tl, append('CSL Intensity', ' in ', 'cell', num2str(b)));
% 
%  
%     imagesc( [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm2, 2))], ...
%              [NewPixelSize:NewPixelSize:(NewPixelSize*size(ImageMatNorm2, 1))], ...
%              ImageMatNorm2(:, :, b));
%     clim([LOWERylim,  UPPERylim]);
%     title('Image of the mean enrichment');
%     colorbar;
% 
% 
% orient(gcf,'landscape');
% saveas(gcf, append(path, f , 'Individual Plots', f, nameofmolofinterest, listConditions{a},  'individual example number ', num2str(b), '.pdf'));
%  close(gcf)
% 
% 
% end


end




figure('Name', 'Correlation between levels', 'Position', [0 0 300 900]); 

tl2 = tiledlayout(3, 1,'TileSpacing','Compact');


%correlation between variable 1 and 3

for e = 1:3

    if e == 1
        y = AllMatrix;
        x = AllMatrix3;
        Ylabel = 'Med1 enrichment';
        Xlabel = 'Rbp1 enrichme';
    elseif e == 2
        y = AllMatrix;
        x = AllMatrix2;
        Ylabel = 'Med1 enrichment';
        Xlabel = 'CSL enrichment';

    elseif e == 3
        x = AllMatrix3;
        y = AllMatrix2;
        Ylabel = 'Rbp1 enrichment';
        Xlabel = 'CSL enrichment';
    end

% compute a linear regression that predicts y from x:
coefficients = polyfit(x, y, 1);

% Create a new x axis with exactly 1000 points (or whatever you want).
xFit = linspace(min(x), max(x), 1000);

%  use p to predict y, calling the result yfit:
yfit = polyval(coefficients,x);

% Get the estimated yFit value for each of those 1000 new x locations.
yFit = polyval(coefficients , xFit);

yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);

rsq = 1 - SSresid/SStotal;





nexttile

plot(x, y, '.', 'MarkerSize', 15, 'Color', [153, 153, 153]./ 255); % Plot training data.
hold on; % Set hold on so the next plot does not blow away lslithe one we just drew.

plot(xFit, yFit, 'k-', 'LineWidth', 2); % Plot fitted line.
grid off;

legend(append('R^2 = ', string(rsq) ));

ylabel(Ylabel);
xlabel(Xlabel);
% 
% xlim([0.5, 3])
% ylim([0.5, 3])


if e == 3
    ylim([0.8 3.2])
end
end



saveas(gcf, append(path, f , 'Correlation with normalised values n', '.pdf'));


