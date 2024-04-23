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

listConditions = {'24 hrs ON0'};
listColor = cat(1, red, blue, orange);


M3locustagcount = [];
M3cytocount = [];

MBlocustagcount = [];
MBcytocount = [];




for a = 1:(length(listConditions))
    
    currentCondition = listConditions{a};
    disp(currentCondition);
    
    
parentdirectory = dir(append(path, f, '*', f, '*',  currentCondition, '*'));

M3cytointensitycond = [];
MBcytointensitycond = [];

M3locintensitycond = [];
MBlocintensitycond = [];

    for t = 1:length({parentdirectory.name}) %this loop will go over every folder that has the name nameNotchstatus on it
    
        
        disp(parentdirectory(t).name);
        
        
      m3locCSVDirectory = dir(append(parentdirectory(t).folder, f, parentdirectory(t).name, f, '*c4*.csv'));
      
      mBlocCSVDirectory = dir(append(parentdirectory(t).folder, f, parentdirectory(t).name, f, '*c5*.csv'));
       
      try 
      m3CSV1 = readtable(append(m3locCSVDirectory(1).folder, f, m3locCSVDirectory(1).name));
      end
      
      try 
          
      m3CSV2 = readtable(append(m3locCSVDirectory(2).folder, f, m3locCSVDirectory(2).name));
      end
      try
      mBCSV1 = readtable(append(mBlocCSVDirectory(1).folder, f, mBlocCSVDirectory(1).name));
      end
    try 
        mBCSV2 = readtable(append(mBlocCSVDirectory(2).folder, f, mBlocCSVDirectory(2).name));
    end
     
      M3cytointensitycond(t*2 -1) =  size(m3CSV1, 1);
      try
        M3cytointensitycond(t*2) =  size(m3CSV2, 1);
      end
      MBcytointensitycond(t*2 - 1) =  size(mBCSV1, 1);
      try
      MBcytointensitycond(t*2) =  size(mBCSV2, 1);
      end


      [filepath,parentdirectoryfilename, ext] = fileparts(parentdirectory(t).name);
      
      m3locCSVDirectory = dir(append(parentdirectory(t).folder,f, parentdirectory(t).name, f, 'locustag', f, '*cl4*.csv'));
      
   
      
      mBlocCSVDirectory = dir(append(parentdirectory(t).folder,f, parentdirectory(t).name, f, 'locustag', f, '*cl5*.csv'));
       
      
      m3locCSV = readtable(append(m3locCSVDirectory.folder, f, m3locCSVDirectory.name));
      mBlocCSV = readtable(append(mBlocCSVDirectory.folder, f, mBlocCSVDirectory.name));
      
      
      M3locintensitycond(t) =  sum(m3locCSV{:,'IntDen'});
      MBlocintensitycond(t) =  sum(mBlocCSV{:,'IntDen'});
  end
     
    if isempty(M3cytocount)  
        M3cytocount = M3cytointensitycond.';
    else
        M3cytocount = padconcatenation(M3cytocount, M3cytointensitycond.', 2);
    end
    
    if isempty(MBcytocount)

        MBcytocount = MBcytointensitycond.';
    else
        MBcytocount = padconcatenation(MBcytocount, MBcytointensitycond.', 2);
    end
    


    if isempty(M3locustagcount)  
        M3locustagcount = M3locintensitycond.';
    else
        M3locustagcount = padconcatenation(M3locustagcount, M3locintensitycond.', 2);
    end
    

    if isempty(MBlocustagcount)  
        MBlocustagcount = MBlocintensitycond.';
    else
        MBlocustagcount = padconcatenation(MBlocustagcount, MBlocintensitycond.', 2);
    end    



end
% 
% size(M3cytocountavgd)
% size(M3cytocount)
% size(MBlocustagcount)
% size(MBcytocount)



M3cytocountavgd = [];

for y = 1:2:size(M3cytocount, 1)

M3cytocountavgd = [M3cytocountavgd; mean([M3cytocount(y, 1), M3cytocount(y+1, 1)])];

end



M3locusdupli = [];

for r = 1:size(M3locustagcount, 1)

M3locusdupli = [M3locusdupli; [M3locustagcount(r, 1); M3locustagcount(r, 1)]];

end
size(M3locusdupli)

MBcytocountavgd = [];

for i = 1:2:size(MBcytocount, 1)

MBcytocountavgd = [MBcytocountavgd; mean([MBcytocount(i, 1), MBcytocount(i+1, 1)])];

end

size(MBcytocountavgd)


MBlocusdupli = [];

for g = 1:size(MBlocustagcount, 1)

MBlocusdupli = [MBlocusdupli; [MBlocustagcount(r, 1); MBlocustagcount(r, 1)]];

end
size(MBlocusdupli)

figure;

scatter(MBcytocount, MBlocusdupli, 200,  '.', 'MarkerFaceColor', [0.11 0.7 0.32]);
ylabel('locustag intensity');
xlabel ('m3 spots intensity');

box 'on'


tmp = corrcoef(M3cytocount, M3locusdupli);

str=sprintf('r= %1.2f',tmp(1,2));
T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str); 
set(T, 'fontsize', 14, 'verticalalignment', 'top', 'horizontalalignment', 'left');
l = lsline;
set(l,'LineWidth', 2)
% xlim([0, 4096])
% ylim([0, 4096])

orient(gcf,'landscape');

 saveas(gcf, append(path, f, "correlation ", 'mB locustagdupli vs cytoplasmic', '  intensity', ".pdf"));


figure;

scatter(M3cytocountavgd, M3locustagcount, 200,  '.', 'MarkerFaceColor', [0.11 0.7 0.32]);
ylabel('locustag intensity');
xlabel ('m3 spots intensity');

box 'on'


tmp = corrcoef(M3cytocountavgd, M3locustagcount);

str=sprintf('r= %1.2f',tmp(1,2));
T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str); 
set(T, 'fontsize', 14, 'verticalalignment', 'top', 'horizontalalignment', 'left');
l = lsline;
set(l,'LineWidth', 2)
% xlim([0, 4096])
% ylim([0, 4096])

orient(gcf,'landscape');

 saveas(gcf, append(path, f, "correlation ", 'm3 locustag vs cytoplasmicavgd', '  intensity', ".pdf"));




figure;

scatter(MBcytocountavgd, MBlocustagcount, 200,  '.', 'MarkerFaceColor', [0.11 0.7 0.32]);
ylabel('locustag intensity');
xlabel ('mB spots intensity');

box 'on'


tmp = corrcoef(MBcytocountavgd, MBlocustagcount);

str=sprintf('r= %1.2f',tmp(1,2));
T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str); 
set(T, 'fontsize', 14, 'verticalalignment', 'top', 'horizontalalignment', 'left');
l = lsline;
set(l,'LineWidth', 2)
% xlim([0, 4096])
% ylim([0, 4096])

orient(gcf,'landscape');

 saveas(gcf, append(path, f, "correlation ", 'mB locustag vs cytoplasmic avgd', '  intensity', ".pdf"));
