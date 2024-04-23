
f = filesep;
fontname = 'Lato'; 
set(0,'DefaultAxesFontName',fontname,'DefaultTextFontName',fontname);

ChosenD1 = 'Bound particles';
ChosenD4 = "Diffusive particles";



path = uigetdir();

suhgreenoff = [139, 191, 72]./ 255;
suhgreenon = [104, 143, 54]./ 255;
mampurpleoff = [218, 124, 163]./ 255;
mampurpleon = [193, 37, 101]./ 255;


listConditions = {'d1Mam', 'd2Mam'};
listColor = cat(1, mampurpleoff, mampurpleon);


Ringanalysis = [];

for a = 1:(length(listConditions))

currentCondition = listConditions{a};
    disp(currentCondition);

    parentdirectory = dir(append(path, f, '*',  currentCondition, '*.csv'));


    try 
      CSV = readtable(append(parentdirectory(1).folder, f, parentdirectory(1).name));
    end
      
Ringanalysis(:,:, a) =  CSV{:,:};

   
    
end

RingBoxplot = figure('Name', 'Ring analysis Boxplot', 'Position', [0 0 800 500]);


AllMatrix = []

for y = 1:(size(Ringanalysis, 2))
    
   if  isempty(AllMatrix)
     AllMatrix = Ringanalysis(:, y, 1);
   else
       AllMatrix = padconcatenation(AllMatrix , Ringanalysis(:, y, 1), 2);
   end

   AllMatrix = padconcatenation(AllMatrix , Ringanalysis(:, y, 2), 2);

 AllMatrix = padconcatenation(AllMatrix , [NaN], 2);


end


 figure('Position', [0 0 850 600]);
 

    
    listConditions= {'locustag', 'locustag', 'locustag', 'locustag','locustag', 'locustag', 'locustag', 'locustag', 'locustag', 'locustag', 'locustag', 'locustag', 'locustag', 'locustag', 'locustag'}
    listColor = repmat(cat(1, mampurpleon, mampurpleoff, mampurpleoff), 5, 1);
hold on
yline([ 0.5324 0.4676],'--',{'Nuclear bound levels','Nuclear diffusive levels'}) %mam
% yline([ 0.0899588571428571 0.320294285714286],'--',{'Nuclear bound levels','Nuclear diffusive levels'}) %csl

    plotBoxplotMATLABlike(AllMatrix, listConditions, listConditions, 0.5 , 0.40, '10 middle pixels', 14, 20, listColor, 0.3, 3, 18, [0.1, 1])

% plotBoxplot(All,Nicknames,ExpLabels,Jitter,BarW,Title,FontSize,DotSize,CMAP,FaceAlpha,LineWidth,FontSizeTitle,Ylim)
%  saving this plot

orient(gcf,'landscape');
% 
    saveas(gcf, append(path, f , 'mam ringanalysis d1d2new colours', '.pdf'));
   
%%%%SMTenrichment%%



suhgreenoff = [139, 191, 72]./ 255;
suhgreenon = [104, 143, 54]./ 255;
mampurpleoff = [218, 124, 163]./ 255;
mampurpleon = [193, 37, 101]./ 255;

f = filesep;
fontname = 'Lato'; 
set(0,'DefaultAxesFontName',fontname,'DefaultTextFontName',fontname);



path = uigetdir();


parentdirectory = dir(append(path, f, '*.csv'));

CSLCSV = readtable(append(parentdirectory(1).folder, f, parentdirectory(1).name));
MAMCSV = readtable(append(parentdirectory(1).folder, f, parentdirectory(2).name));

CSL =  CSLCSV{:,:}
MAM =  MAMCSV{:,:}



red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
listColor = cat(1, red, green);

 figure('Name', append('SPT enrichment'), 'Position', [0 0 500 400]);

%  tl = tiledlayout(1, 2,'TileSpacing','Compact');
% 
% nexttile
 listConditions = {'Notch OFF CSL', 'Notch ON CSL', 'Notch OFF Mam', 'Notch ON Mam'}
 listColor = cat(1, suhgreenoff, suhgreenon ,mampurpleoff, mampurpleon);

% All = padconcatenation(CSL(:, [2,1]), [NaN], 2);
% All = padconcatenation(All, MAM(:, [2,1]), 2);
All = padconcatenation(CSL(:, [2,1]), MAM(:, [2,1]), 2);

plotBoxplotMATLABlike(All, listConditions, listConditions, 0.8 , 0.3,  'trajectories at the locus', 14, 17, listColor, 0.3, 3, 18, [0, 16])

nexttile
 listConditions = {c}
 listColor = cat(1, mampurpleoff, mampurpleon);


plotBoxplotMATLABlike(MAM(:, [2,1]), listConditions, listConditions, 0.8 , 0.3, 'Mam trajectories at the locus', 14, 17, listColor, 0.3, 3, 18, [0, 16])

% plotBoxplot(All,Nicknames,ExpLabels,Jitter,BarW,Title,FontSize,DotSize,CMAP,FaceAlpha,LineWidth,FontSizeTitle,Ylim)


saveas(gcf, append(path, f , 'spt enrichment together nospacenarrow', '.pdf'));

