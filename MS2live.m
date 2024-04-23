f = filesep;
path = uigetdir();



graybetween = [77,77,77]./ 255;
grayexp = [153, 153, 153]./ 255;



warning('on')
directory = dir([path, f, '*.csv']);
directoryonlycsv = {directory.name};

Timescale = [];
Intensity = [];


for n = 1:length(directoryonlycsv)
    tempdata = [];

    disp(directoryonlycsv{n})
    
    opts = detectImportOptions([path, '/', directoryonlycsv{n}]);
    opts.VariableNamesLine = 2;
    
   
    
    tempdata = readtable([path, '/', directoryonlycsv{n}], 'HeaderLines',1);
    
    tempdata.Properties.VariableNames{:,1} = 'time';
    tempdata.Properties.VariableNames{:,2} = 'intensity';
    

   
    Timescale = padconcatenation(Timescale, tempdata.time, 2);
    Intensity = padconcatenation(Intensity, tempdata.intensity, 2);
end    


figure('Renderer', 'painters', 'Position', [10 10 1000 600])
 
hold on

AllPlot = plot(Timescale, Intensity,  '-');

xlim([min(Timescale, [],"all") max(Timescale, [],"all")]);
ylim([min(Intensity, [],"all") max(Intensity, [],"all")]);

set(AllPlot,'LineWidth',1)

yticks([0:0.25:2])
xticks([0:10:max(Timescale, [],"all")])

ylabel('enrichment of MS2 MCP signal')
xlabel('time (seconds)')

 orient(gcf,'landscape');

 grid on


 figure

 j = tiledlayout(5,2,'TileSpacing','Compact');;


 for t = 1:size(Timescale, 2)
     nexttile

indvPlot = plot(Timescale(:, t), Intensity(:, t),  '-',  'color', graybetween);

xlim([min(Timescale(:, t), [],"all") max(Timescale(:, t), [],"all")]);
ylim([0 2]);
xticks([0:20:max(Timescale, [],"all")])

set(indvPlot,'LineWidth',1.5)

grid on

 end

xlabel(j, 'enrichment of MS2 MCP signal')
ylabel(j, 'time (seconds)')