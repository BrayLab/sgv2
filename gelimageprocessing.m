


f = filesep
path = uigetdir();


warning('on')
directory = dir([path, f, '*.csv']);

directoryonlycsv = {directory.name};


figure('Renderer', 'painters', 'Position', [10 10 1000 600])

hold on
for n = 1:length(directoryonlycsv)
    
    
    disp(directoryonlycsv{n})
    
    opts = detectImportOptions([path, f, directoryonlycsv{n}]);
    opts.VariableNamesLine = 2;
    geldata = readtable([path, f, directoryonlycsv{n}], 'HeaderLines',1);
    plot(geldata{:,1}, geldata{:,2})

end


orient(gcf,'landscape');
saveas(gcf, append(path, f,' quantified individual tracks.pdf'));
