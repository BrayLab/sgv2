%%analysis of total intensity of smfish signal at the locustag 
%%images need to be read with Fiji first, and csv files with intensities
%%included

%%getting the different conditions

f = filesep;
% fontname = 'Lato'; 
% set(0,'DefaultAxesFontName',fontname,'DefaultTextFontName',fontname);

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
% listConditions = {'24 hrs ON', '4 hrs OFF', '8 hrs OFF'};
% listColor = cat(1, grayexp, graybetween, blackcontrol);

%  listConditions = {'24 hrs ON', '4 hrs OFF', '8 hrs OFF', '24 hrs OFF'};
% listColor = cat(1, grayexp, graybetween, blackcontrol, grayexp);

% listConditions = {'DMSO', 'triptolide'};
% listColor = cat(1, graybetween, blackcontrol);
% 


listConditions = {'24 hrs ON0', '4 hrs OFF', '8 hrs OFF'};
listColor = cat(1, blackcontrol, graybetween, grayexp);


M3intensity = [];
MBintensity = [];


for a = 1:(length(listConditions))
    
    currentCondition = listConditions{a};
    disp(currentCondition);
    
    
parentdirectory = dir(append(path, f, currentCondition, f, '*',  currentCondition, '*'));

M3intensitycond = [];
MBintensitycond = [];
try
    for t = 1:length({parentdirectory.name}) %this loop will go over every folder that has the name nameNotchstatus on it
    
        
        disp(parentdirectory(t).name);
        
      [filepath,parentdirectoryfilename, ext] = fileparts(parentdirectory(t).name);
      
      m3CSVDirectory = dir(append(parentdirectory(t).folder,f, parentdirectory(t).name, f, 'locustag', f, '*cl4*.csv'));
      
   
      
      mBCSVDirectory = dir(append(parentdirectory(t).folder,f, parentdirectory(t).name, f, 'locustag', f, '*cl5*.csv'));
       
      
      m3CSV = readtable(append(m3CSVDirectory.folder, f, m3CSVDirectory.name));
      try
          mBCSV = readtable(append(mBCSVDirectory.folder, f, mBCSVDirectory.name));
      end

  M3intensitycond(t) =  sum(m3CSV{:,'RawIntDen'});
      try
          MBintensitycond(t) =  sum(mBCSV{:,'RawIntDen'});
      end
      
    end
end
    
    if isempty(M3intensity)  
        M3intensity = M3intensitycond.';
    else
        M3intensity = padconcatenation(M3intensity, M3intensitycond.', 2);
    end

    if isempty(MBintensity)

        MBintensity = MBintensitycond.';
    else
        MBintensity = padconcatenation(MBintensity, MBintensitycond.', 2);
    end

    

end


AllMatrix =  M3intensity
AllMatrix2 = MBintensity

figure('Name', probe1, 'Position', [0 0 300 400]);


hold on
MyColorMap = listColor;

plotBoxplotMATLABlike(M3intensity, listConditions, listConditions, 0.5 , 0.25, 'Locustag IntDen signal', 14, 14, MyColorMap, 0.3, 5, 18, [0, 1.2 * max(M3intensity,[], 'all') ])

[h, p] = ranksum(M3intensity(:, 1), M3intensity(:, 2))
[h, p] = ranksum(M3intensity(:, 2), M3intensity(:, 3))
[h, p] = ranksum(M3intensity(:, 1), M3intensity(:, 3))

saveas(gcf, append(path, f,'boxplot locustag intensity', probe1, '.pdf'));  

% 
% 
%     if exist('barplot')
%         figure(barplot);    
%     else 
%          barplot = figure('Name', 'bar plot', 'Position', [0 0 300 400]); 
%     end
% 
% 
%     ONcells = [];
%     for r = 1:size(M3intensity, 1)
%         ONcells(r) = M3intensity(r) >= 10000
%     end
% 
% 
%     ONcells = sum(ONcells, "all") / size(M3intensity, 1);
%     OFFcells = 1 - ONcells;
%     hold on
%     bar(a,[ONcells, OFFcells], 'stacked')
% 
% xlim([0, 3])
% saveas(gcf, append(path, f,'locustag bar plot proportion', probe3, '.pdf'));
% 
% 




figure('Name', probe3, 'Position', [0 0 300 400]);




hold on


plotBoxplotMATLABlike(MBintensity, listConditions, listConditions, 0.5 , 0.25, 'Locustag IntDen signal', 14, 14, MyColorMap, 0.3, 5, 18, [-50,  1.2 * max(MBintensity,[], 'all') ])

[h, p] = ttest(MBintensity(:, 1), MBintensity(:, 2))
% [h, p] = ttest(MBintensity(:, 2), MBintensity(:, 3))
% [h, p] = ttest(MBintensity(:, 1), MBintensity(:, 3))

saveas(gcf, append(path, f,'boxplot locustag intensity', probe3, '.pdf'));


figure;

scatter(M3intensity(:, 1), MBintensity(:, 1), 200,  '.', 'MarkerFaceColor', [0.11 0.7 0.32]);
ylabel('mB intensity');
xlabel ('m3 intensity');

box 'on'


tmp = corrcoef(M3intensity(:, 1), MBintensity(:, 1));

str=sprintf('r= %1.2f',tmp(1,2));
T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str); 
set(T, 'fontsize', 14, 'verticalalignment', 'top', 'horizontalalignment', 'left');
l = lsline;
set(l,'LineWidth', 2)
% xlim([0, 150])
% ylim([0, 1300])

orient(gcf,'landscape');

 saveas(gcf, append(path, f, "correlation ", 'm3 locustag vs mB', '  intensity', ".pdf"));


