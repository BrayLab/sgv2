mkdir('/Users/fjavierdha/Documents/MATLAB')

warning ('on','all')


blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
darkgreen =[0.21 0.8 0.42];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];
darkpurple = [0.8 0.05 1];
listConditions = {'Mam24', 'Mam4off', 'Mam8off', 'SuH24', 'SuH4off', 'SuH8off' };%, 'kto', 'med1'};
listColor = cat(1, green, darkgreen, purple ,darkpurple);


nameofmolofinterest = 'Mam';
nameofloctag = "Su(H) ";


path = uigetdir()


parentdirectory = dir(append(path, '/*middle pixels*.txt'));
MeansofConditions = []


Mam24Means = readmatrix(append(parentdirectory(1).folder, '/', parentdirectory(1).name));
SuH24Means = readmatrix(append(parentdirectory(2).folder, '/', parentdirectory(2).name));
Mam4offMeans = readmatrix(append(parentdirectory(1).folder, '/', parentdirectory(3).name));
SuH4offMeans = readmatrix(append(parentdirectory(1).folder, '/', parentdirectory(4).name));
Mam8offMeans = readmatrix(append(parentdirectory(1).folder, '/', parentdirectory(5).name));
SuH8offMeans = readmatrix(append(parentdirectory(1).folder, '/', parentdirectory(6).name));

AllMatrix = [];

AllMatrix = padconcatenation(AllMatrix,Mam24Means.', 2);
AllMatrix = padconcatenation(AllMatrix, Mam4offMeans.', 2);
AllMatrix = padconcatenation(AllMatrix, Mam8offMeans.', 2);
AllMatrix = padconcatenation(AllMatrix, SuH24Means.', 2);
AllMatrix = padconcatenation(AllMatrix, SuH4offMeans.', 2);
AllMatrix = padconcatenation(AllMatrix, SuH8offMeans.', 2);

blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];



MyColorMap = [green; darkgreen; purple; darkpurple];

hold on

plotBoxplot(AllMatrix, listConditions, listConditions, 0.5 , 0.25, 'Fold change 10 middle pixels', 14, 14, MyColorMap, 0.3, 5, 18, [0, 3000])
All = AllMatrix;
Nicknames  = listConditions;
ExpLabels = listConditions;
Jitter = 0.5;
BarW = 0.25;
Title = 'Test run for botplox';
FontSize = 14;
DotSize = 14;
CMAP = MyColorMap;
FaceAlpha = 0.3;
LineWidth = 5;
FontSizeTitle = 18;
Ylim = [0, 12];


% plotBoxplot(All,Nicknames,ExpLabels,Jitter,BarW,Title,FontSize,DotSize,CMAP,FaceAlpha,LineWidth,FontSizeTitle,Ylim)
% 
% plotBoxplot('All', AllMatrix, 'Nicknames', listConditions, 'ExpLabels', listConditions, ...
%          'Jitter', 0.5 , 'BarW', 0.01, 'Title', 'MamGFP intensity with MedKDs', 'FontSize', 5,...
%          'DotSize',  2, 'CMAP',  [0.1, 1, 0.1], 'LineWidth',  1, 'FontSizeTitle', 1, ...
%          'Ylim', [0, 10])
%     

orient(gcf,'landscape');
saveas(gcf, append(path, "/","boxplot suh and mam ratio .pdf")); 

[h, p] = ttest(AllMatrix(:, 2), AllMatrix(:, 3))

%%




ratio24 = SuH24Means ./  Mam24Means;
ratio4off = SuH4offMeans ./ Mam4offMeans;
ratio8off =  SuH8offMeans ./ Mam8offMeans;


listConditions = {'24hrson', '24hrson4hrsoff', '24hrson8hrsoff'};
MyColorMap = [green; red; blue];

hold on
AllMatrixNew = padconcatenation(ratio24.', ratio4off.', 2)
AllMatrixNew = padconcatenation(AllMatrixNew, ratio8off.', 2)

plotBoxplot(AllMatrixNew, listConditions, listConditions, 0.5 , 0.25, 'Fold change 10 middle pixels', 14, 14, MyColorMap, 0.3, 5, 18, [0, 5])

All = AllMatrix;
Nicknames  = listConditions;
ExpLabels = listConditions;
Jitter = 0.5;
BarW = 0.25;
Title = 'Test run for botplox';
FontSize = 14;
DotSize = 14;
CMAP = MyColorMap;
FaceAlpha = 0.3;
LineWidth = 5;
FontSizeTitle = 18;
Ylim = [0, 12];


[h, p] = ttest(AllMatrixNew(:, 3), AllMatrixNew(:, 1))
[h, p] = ttest(AllMatrix(:, 1), AllMatrix(:, 3))
[h, p] = ttest(AllMatrix(:, 3), AllMatrix(:, 4))


[p, h] = ranksum(AllMatrix(:, 1), AllMatrix(:, 2))
[p, h] = ranksum(AllMatrix(:, 1), AllMatrix(:, 3))
[p, h] = ranksum(AllMatrix(:, 1), AllMatrix(:, 4))
