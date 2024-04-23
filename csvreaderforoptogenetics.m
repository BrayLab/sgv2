warning ('on','all')

f = filesep



path = uigetdir()



listConditions = {'naive activation', 'preactivated'};

blackcontrol = [0, 0, 0]./ 255;
grayexp = [153, 153, 153]./ 255;


listColor = cat(1, blackcontrol, grayexp);


 for a = 1:(length(listConditions))

    nameNotchstatus = listConditions{a};
    notchstatus = listConditions{a}


nuclearlevelstable = [];
bandlevelstable = [];

CSVDirectory = dir(append(path, f, nameNotchstatus, f, '*.csv'));
       
    CSVDirectoryfullpath = [];
    
    for u = 1:length(CSVDirectory);
        
        CSVDirectoryfullpath =  [CSVDirectoryfullpath, cellstr(append(CSVDirectory(u).folder, f, CSVDirectory(u).name))];
    
    end
    

     for n = 1:length(CSVDirectoryfullpath)
    if isequal("bandmam", regexp(CSVDirectoryfullpath{n}, 'bandmam', 'match'))
        bandtable = readtable(CSVDirectoryfullpath{n});
        disp(CSVDirectoryfullpath{n})
        bandlevelstable(:, :, round(n/2, 0, TieBreaker="plusinf")) = bandtable{:,:};
    elseif isequal("nuclearmam", regexp(CSVDirectoryfullpath{n}, 'nuclearmam', 'match'))
        nucleartable = readtable(CSVDirectoryfullpath{n});
        nuclearlevelstable(:, :, round(n/2, 0, TieBreaker="plusinf")) = nucleartable{:,:};
        disp(CSVDirectoryfullpath{n})
    else
        disp(parentdirectory(t).name);
        disp(append('There is a CSV file with no appropriate name in the folder', CSVDirectoryfullpath{n}))
    end
     end
size(nuclearlevelstable)
size(bandlevelstable)

if a == 1

    nuclearlevelstable1 = nuclearlevelstable;
    bandlevelstable1 = bandlevelstable;
elseif a == 2


    nuclearlevelstable2 = nuclearlevelstable;
    bandlevelstable2 = bandlevelstable;

end

 end


figure('Name', notchstatus, 'Position', [0 0 600 600]); %for two images, (4/6)

 tl = tiledlayout(4, 2,'TileSpacing','Compact');


ylabel(tl,'fluorescence intensity/enrichment');

xlabel(tl,'time (minutes, in 10s)');

nexttile
plot(permute(bandlevelstable1(:, 3, :), [1 3 2]))
 title('Band intensity (raw)');
nexttile
plot(permute(bandlevelstable2(:, 3, :), [1 3 2]))
title('Band intensity (raw)');
nexttile
plot(permute(nuclearlevelstable1(:, 3, :), [1 3 2]))
title('Nuclear intensity (raw)');
nexttile
plot(permute(nuclearlevelstable2(:, 3, :), [1 3 2]))
title('Nuclear intensity (raw)');
nexttile

FoldChangeMean1 = bandlevelstable1(:, 3, :) - nuclearlevelstable1(:, 3, :);
FoldChangeMean1 = permute(FoldChangeMean1, [1 3 2]);
hold on
plot(FoldChangeMean1)


plot(mean(FoldChangeMean1, 2), 'LineWidth', 2) 
 title('Band enrichment');


nexttile

FoldChangeMean2 = bandlevelstable2(:, 3, :) - nuclearlevelstable2(:, 3, :);
FoldChangeMean2 = permute(FoldChangeMean2, [1 3 2]);
 hold on
plot(FoldChangeMean2)

plot(mean(FoldChangeMean2, 2), 'LineWidth', 2) 

 title('Band enrichment');
nexttile

  
FoldChangeMean1Norm1 = ((FoldChangeMean1 - FoldChangeMean1(1, :)  )./ (max(FoldChangeMean1,[],1) - FoldChangeMean1(1, :) ));

hold on
plot(FoldChangeMean1Norm1);


plot(mean(FoldChangeMean1Norm1, 2), 'LineWidth', 2) 

 title('Band enrichment norm');

ylim([0 1])
% xlim([1 7])
nexttile

FoldChangeMean2Norm1 = ((FoldChangeMean2 - FoldChangeMean2(1, :) )./ (max(FoldChangeMean2,[],1) - FoldChangeMean2(1, :) ));
hold on

plot(FoldChangeMean2Norm1);

plot(mean(FoldChangeMean2Norm1, 2), 'LineWidth', 2) 
 title('Band enrichment norm');

ylim([0 1])
% xlim([1 7])



% orient(gcf,'landscape');
% saveas(gcf, append(path, f, 'normalisation.pdf'));




figure('Name', 'first 60 mins', 'Position', [0 0 700 400]);
hold on

timescale = 0:10:170;


SEM1 = std(FoldChangeMean1Norm1, 0, 2, 'omitnan') ./ sqrt(size(FoldChangeMean1Norm1, 2));
SEM2 = std(FoldChangeMean2Norm1, 0, 2, 'omitnan') ./ sqrt(size(FoldChangeMean2Norm1, 2));

topcurve1 = (mean(FoldChangeMean1Norm1, 2, 'omitnan') + SEM1).';
lowercurve1 = (mean(FoldChangeMean1Norm1, 2, 'omitnan') - SEM1).';

topcurve2 = (mean(FoldChangeMean2Norm1, 2, 'omitnan') + SEM2).';
lowercurve2 = (mean(FoldChangeMean2Norm1, 2, 'omitnan') - SEM2).';


plot(timescale, mean(FoldChangeMean1Norm1, 2, 'omitnan'), '-',  'color', listColor(2, :));

pfill1 = fill([timescale fliplr(timescale)], [topcurve1 fliplr(lowercurve1)], ...
             listColor(2, :), 'linestyle', 'none', 'FaceAlpha', .1);

plot(timescale, mean(FoldChangeMean2Norm1, 2, 'omitnan'), '-',  'color', listColor(1, :));

pfill2 = fill([timescale fliplr(timescale)], [topcurve2 fliplr(lowercurve2)], ...
             listColor(1, :) , 'linestyle', 'none', 'FaceAlpha', .1);

xlim([0 50])
ylim([0 1])

grid on


ylabel('Mam enrichment');

xlabel('time (minutes)');


orient(gcf,'landscape');
% saveas(gcf, append(path, f, 'first 50 minutes.pdf'));

xlim([0 180])
ylim([0 1])

orient(gcf,'landscape');
% saveas(gcf, append(path, f, 'whole thing.pdf'));

[Row, Column] = find(FoldChangeMean1Norm1 == 1);

AllMatrix = Row;


[Row, Column] = find(FoldChangeMean2Norm1 == 1);

AllMatrix = padconcatenation(AllMatrix, Row, 2);

AllMatrix = AllMatrix .* 10;

boxplot = figure('Name', 'boxplot plot', 'Position', [0 0 400 600]);

MyColorMap = [listColor(2, :); listColor(1, :)];

hold on


plotBoxplotMATLABlike(AllMatrix, listConditions, listConditions, 0.5 , 0.25, '10 middle pixels', 14, 14, MyColorMap, 0.3, 5, 18, [0,  140])

 
ylabel('Time to reach max Mam level (minutes)')% 

% saveas(gcf, append(path, f , 'BoxPlot time to reach maximum intensity', '.pdf'));




