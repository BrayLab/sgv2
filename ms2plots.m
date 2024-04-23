%%personal startup
mkdir('/Users/fjavierdha/Documents/MATLAB')

warning ('off','all')

f = filesep


path = uigetdir()

nameofmolofinterest = 'MS2-MCP signal';
nameofloctag = "loctag ";


nameNotchstatus = "MS2";

parentdirectory = dir(append(path, f, '*', nameNotchstatus, '*'));

  numberofblobspooled = [];
  Totalintensityofblobspooled = [];
  Normalisedintensityofblobspooled = [];
  MeanMaxpooled = [];

for t = 1:length({parentdirectory.name}) %this loop will go over every folder that has the name nameNotchstatus on it
    
    disp(parentdirectory(t).name);
    
    CSVDirectory = dir(append(parentdirectory(t).folder, f, parentdirectory(t).name, f, '*.csv'));
       
    CSVDirectoryfullpath = [];
    
    for u = 1:length(CSVDirectory);
        
        CSVDirectoryfullpath =  [CSVDirectoryfullpath, cellstr(append(CSVDirectory(u).folder, f, CSVDirectory(u).name))];
    
    end
    

numberofblobs = [];
bgincell = [];
areaofblobs = [];
meanintensityofblobs = [];
maxintensityofblobs = [];

    for n = 1:length(CSVDirectoryfullpath);
       
        MS2table = readtable(CSVDirectoryfullpath{n});
        
       numberofblobs = [numberofblobs, size(MS2table{:,1}, 1)];
       bgincell = [bgincell, MS2table{1,7}];
       areaofblobs = padconcatenation(areaofblobs, MS2table{:,2} , 2);
       meanintensityofblobs = padconcatenation(meanintensityofblobs, MS2table{:,3} , 2);
       maxintensityofblobs = padconcatenation(maxintensityofblobs, MS2table{:,5} , 2);
    end
  
   
    

numberofblobspooled = [numberofblobspooled, numberofblobs];
 
Totalintensityofblobs = areaofblobs .* meanintensityofblobs;

Totalintensityofblobspooled = [Totalintensityofblobspooled, sum(Totalintensityofblobs, 1, 'omitnan')];
    
Normalisedintensityofblobs = areaofblobs .* (meanintensityofblobs ./repmat(bgincell, size(meanintensityofblobs, 1), 1));

Normalisedintensityofblobspooled =  [Normalisedintensityofblobspooled, sum(Normalisedintensityofblobs, 1, 'omitnan')];

MeanMaxpooled = [MeanMaxpooled, mean(maxintensityofblobs, 1, 'omitnan')];

% figure('Name', parentdirectory(t).name, 'Position', [0 0 900 350]);
% 
% tl = tiledlayout(1, 4,'TileSpacing','Compact');
% 
% 
% title(tl, append('MS2 signal in ', parentdirectory(t).name));
% 
% nexttile %tplot the number of blobs per cell
% listConditions = {'Number of blobs'};
% green = [0.11 0.7 0.32];
% MyColorMap = green;
% plotBoxplot(numberofblobs.', listConditions, listConditions, 0.5 , 0.25, ' ', 14, 14, MyColorMap, 0.3, 5, 18, [0, 40])
% 
% 
% nexttile 
% listConditions = {'Total raw intensity per cell'};
% 
% 
% Totalintensityofblobs = areaofblobs .* meanintensityofblobs;
% 
% 
% listConditions = {'Total intensity per cell (A.U. * um^2)'};
% green = [0.11 0.7 0.32];
% MyColorMap = green;
% plotBoxplot(sum(Totalintensityofblobs, 1, 'omitnan').', listConditions, listConditions, 0.5 , 0.25, ' ', 14, 14, MyColorMap, 0.3, 5, 18, [0, 6000])
% 
% Totalintensityofblobspooled = padconcatenation(Totalintensityofblobspooled;
% 
% nexttile 
% listConditions = {'Total normalised intensity per cell'};
% 
% 
% Normalisedintensityofblobs = areaofblobs .* (meanintensityofblobs ./repmat(bgincell, size(meanintensityofblobs, 1), 1));
% 
% listConditions = {'Normalised intensity per cell ((A.U./A.U.) * um^2)'};
% green = [0.11 0.7 0.32];
% MyColorMap = green;
% plotBoxplot(sum(Normalisedintensityofblobs, 1, 'omitnan').', listConditions, listConditions, 0.5 , 0.25, ' ', 14, 14, MyColorMap, 0.3, 5, 18, [0, 8])
% 
% 
% nexttile 
% listConditions = {'Average (max intensity per blob) per cell'};
% 
% 
% 
% listConditions = {'Average (max intensity per blob) per cell(A.U.)'};
% green = [0.11 0.7 0.32];
% MyColorMap = green;
% plotBoxplot(mean(maxintensityofblobs, 1, 'omitnan').', listConditions, listConditions, 0.5 , 0.25, ' ', 14, 14, MyColorMap, 0.3, 5, 18, [0, 6000])
% 
% 
% orient(gcf,'landscape');
% 
% saveas(gcf, append(path, "/", 'Blob measurements in ', parentdirectory(t).name, '.pdf'));

   
end







figure('Name', parentdirectory(t).name, 'Position', [0 0 900 350]);

tl = tiledlayout(1, 4,'TileSpacing','Compact');


title(tl, append('MS2 signal in ', parentdirectory(t).name));

nexttile %tplot the number of blobs per cell
listConditions = {'Number of blobs'};
green = [0.11 0.7 0.32];
MyColorMap = green;
plotBoxplot(numberofblobspooled.', listConditions, listConditions, 0.5 , 0.25, ' ', 14, 14, MyColorMap, 0.3, 5, 18, [0, 30])


nexttile 

listConditions = {'Total intensity per cell (A.U. * um^2)'};

plotBoxplot(Totalintensityofblobspooled.', listConditions, listConditions, 0.5 , 0.25, ' ', 14, 14, MyColorMap, 0.3, 5, 18, [0, 6000])



nexttile 

listConditions = {'Normalised intensity per cell ((A.U./A.U.) * um^2)'};

plotBoxplot(Normalisedintensityofblobspooled.', listConditions, listConditions, 0.5 , 0.25, ' ', 14, 14, MyColorMap, 0.3, 5, 18, [0, 7])


nexttile 
listConditions = {'Average (max intensity per blob) per cell(A.U.)'};

plotBoxplot(MeanMaxpooled.', listConditions, listConditions, 0.5 , 0.25, ' ', 14, 14, MyColorMap, 0.3, 5, 18, [0, 4000])


orient(gcf,'landscape');
saveas(gcf, append(path, "/", 'Pooled Blob measurements','.pdf'));
