%%analysis of total intensity of smfish signal at the locustag 
%%images need to be read with Fiji first, and csv files with intensities
%%included

%%getting the different conditions

f = filesep;
fontname = 'Lato'; 
set(0,'DefaultAxesFontName',fontname,'DefaultTextFontName',fontname);

probe1 = 'm3';
probe3 = "mB";

%% getting the folder

path = uigetdir();

blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];

blackcontrol = [0, 0, 0]./ 255;
graybetween = [77,77,77]./ 255;
grayexp = [153, 153, 153]./ 255;

% 
% listConditions = {'LacZ, LacZ', 'LacZ, NDECD', 'MamDN, NDECD'};
% listColor = cat(1, grayexp, graybetween, blackcontrol);

listConditions = {'24 hrs ON0', '24 hrs OFF'};
listColor = cat(1, graybetween, grayexp);


M3count = [];
 MBcount = [];


for a = 1:(length(listConditions))
    
    currentCondition = listConditions{a};
    disp(currentCondition);
    
    
parentdirectory = dir(append(path, f,  currentCondition, f, '*'));

M3intensitycond = [];
MBintensitycond = [];

     for t = 4:length({parentdirectory.name}) %this loop will go over every folder that has the name nameNotchstatus on it
    
        
        disp(parentdirectory(t).name);
        
        
      m3CSVDirectory = dir(append(parentdirectory(t).folder, f, parentdirectory(t).name, f, '*c4*.csv'));
      mBCSVDirectory = dir(append(parentdirectory(t).folder, f, parentdirectory(t).name, f, '*c5*.csv'));
       
      try 
      m3CSV1 = readtable(append(m3CSVDirectory(1).folder, f, m3CSVDirectory(1).name));
      

      end
      
      try 
          
      m3CSV2 = readtable(append(m3CSVDirectory(2).folder, f, m3CSVDirectory(2).name));
      end

      mBCSV1 = readtable(append(mBCSVDirectory(1).folder, f, mBCSVDirectory(1).name));
    try 
        mBCSV2 = readtable(append(mBCSVDirectory(2).folder, f, mBCSVDirectory(2).name));
    end

      M3intensitycond(t*2 -1) =  size(m3CSV1, 1);
      try
        M3intensitycond(t*2) =  size(m3CSV2, 1);
      end
      MBintensitycond(t*2 - 1) =  size(mBCSV1, 1);
      try
      MBintensitycond(t*2) =  size(mBCSV2, 1);
      end
     end
     
    if isempty(M3count)  
        M3count = M3intensitycond.';
    else
        M3count = padconcatenation(M3count, M3intensitycond.', 2);
    end
    
    if isempty(MBcount)

        MBcount = MBintensitycond.';
    else
        MBcount = padconcatenation(MBcount, MBintensitycond.', 2);
    end
    
    
AllMatrix = M3count

end


% MBcount

figure('Name', probe1, 'Position', [0 0 300 400]);


hold on
MyColorMap = [180, 30, 26; ...
              213, 158, 76;
              6, 98, 80] ./255;  %colormap for time course experiment

% MyColorMap = [green; red];
% 
plotBoxplotMATLABlike(M3count, listConditions, listConditions, 0.5 , 0.25, 'cytoplasm  foci count', 14, 14, listColor, 0.3, 5, 18, [1e-04, 1e-09])
% 
% 
[h, p] = ttest2(M3count(:, 1), M3count(:, 2))
% [h, p] = ttest(M3count(:, 2), M3count(:, 3))
% [h, p] = ttest(M3count(:, 1), M3count(:, 3))
 ylim([0, 450])
saveas(gcf, append(path, f,'cytoplasm locustag intensity new colours', probe1, '.pdf'));  

 
% 
%     if exist('barplot')
%         figure(barplot);    
%     else 
%          barplot = figure('Name', 'bar plot', 'Position', [0 0 300 400]); 
%     end
% 
% 
%     ONcells = [];
%     for r = 1:size(M3count, 1)
%         ONcells(r) = M3count(r) >= 20
%     end
% 
% 
%     ONcells = sum(ONcells, "all") / size(M3count, 1);
%     OFFcells = 1 - ONcells;
%     hold on
%     bar(a,[ONcells, OFFcells], 'stacked')
% 
% xlim([0, 3])
% saveas(gcf, append(path, f,'cytoplasm bar plot proportion', probe3, '.pdf'));
 

figure('Name', probe3, 'Position', [0 0 300 400]);



hold on
MyColorMap = [green; red];

plotBoxplotMATLABlike(MBcount, listConditions, listConditions, 0.5 , 0.25, 'cytoplasm  foci count', 14, 14, listColor, 0.3, 5, 18, [-50, 1.2 * max(MBcount,[], 'all') ])

[h, p] = ttest(MBcount(:, 1), MBcount(:, 2))
% [h, p] = ttest(MBcount(:, 2), MBcount(:, 3))
% [h, p] = ttest(MBcount(:, 1), MBcount(:, 3))

 saveas(gcf, append(path, f,'cytoplasm locustag intensity', probe3, '.pdf'));


figure;

scatter(M3count(:, 1), MBcount(:, 1), 200,  '.', 'MarkerFaceColor', [0.11 0.7 0.32]);
ylabel('mB spot number');
xlabel ('m3 spot number');

box 'on'


tmp = corrcoef(M3count(:, 1), MBcount(:, 1));

str=sprintf('r= %1.2f',tmp(1,2));
T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str); 
set(T, 'fontsize', 14, 'verticalalignment', 'top', 'horizontalalignment', 'left');
l = lsline;
set(l,'LineWidth', 2)
xlim([0, 450])
ylim([0, 1300])

orient(gcf,'landscape');

 saveas(gcf, append(path, f, "correlation ", 'm3 locustag vs cytoplasmic', '  intensity', ".pdf"));


