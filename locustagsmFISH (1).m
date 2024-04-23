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

listConditions = {'LacZ, LacZ', 'LacZ, NDECD', 'MamDN, NDECD'};
listColor = cat(1, grayexp, graybetween, blackcontrol);



M3intensity = [];
% MBintensity = [];


fxfor a = 1:(length(listConditions))
    
    currentCondition = listConditions{a};
    disp(currentCondition);
    
    
parentdirectory = dir(append(path, f, '*', f, '*',  currentCondition, '*'));

M3intensitycond = [];
% MBintensitycond = [];

    for t = 1:length({parentdirectory.name}) %this loop will go over every folder that has the name nameNotchstatus on it
    
        
        disp(parentdirectory(t).name);
        
        
      m3CSVDirectory = dir(append(parentdirectory(t).folder, f, parentdirectory(t).name, f, 'locustag', f, '*cl4*.csv'));
      
%       mBCSVDirectory = dir(append(parentdirectory(t).folder, f, parentdirectory(t).name, f, 'locustag', f, '*cl5*.csv'));
       
      
      m3CSV = readtable(append(m3CSVDirectory.folder, f, m3CSVDirectory.name));
%       mBCSV = readtable(append(mBCSVDirectory.folder, f, mBCSVDirectory.name));
      
      
      M3intensitycond(t) =  sum(m3CSV{:,'IntDen'});
%       MBintensitycond(t) =  sum(mBCSV{:,'IntDen'});
      
    end
    
    if isempty(M3intensity)  
        M3intensity = M3intensitycond.';
    else
        M3intensity = padconcatenation(M3intensity, M3intensitycond.', 2);
    end
%     
%     if isempty(MBintensity)
%         
%         MBintensity = MBintensitycond.';
%     else
%         MBintensity = padconcatenation(MBintensity, MBintensitycond.', 2);
%     end
%     
    

end


M3intensity
% MBintensity

figure('Name', probe1, 'Position', [0 0 300 400]);


hold on
MyColorMap = [green; red; blue];

plotBoxplot(M3intensity, listConditions, listConditions, 0.5 , 0.25, 'Locustag IntDen signal', 14, 14, MyColorMap, 0.3, 5, 18, [-100, 1.2 * max(M3intensity,[], 'all') ])


[h, p] = ttest(M3intensity(:, 1), M3intensity(:, 2))
[h, p] = ttest(M3intensity(:, 2), M3intensity(:, 3))
[h, p] = ttest(M3intensity(:, 1), M3intensity(:, 3))

% saveas(gcf, append(path, f,'boxplot locustag intensity', probe1, '.pdf'));  

% figure('Name', probe3, 'Position', [0 0 300 400]);
% 
% 
% 
% 
% hold on
% MyColorMap = [green; red; blue];
% 
% plotBoxplot(MBintensity, listConditions, listConditions, 0.5 , 0.25, 'Locustag IntDen signal', 14, 14, MyColorMap, 0.3, 5, 18, [-50,  1.2 * max(MBintensity,[], 'all') ])
% 
% [h, p] = ttest(MBintensity(:, 1), MBintensity(:, 2))
% [h, p] = ttest(MBintensity(:, 2), MBintensity(:, 3))
% [h, p] = ttest(MBintensity(:, 1), MBintensity(:, 3))
% 
% % saveas(gcf, append(path, f,'boxplot locustag intensity', probe3, '.pdf'));
% 
