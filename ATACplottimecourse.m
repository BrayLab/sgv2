clear all
close all


f = filesep;
fontname = 'Lato'; 



MyColorMap = [180, 30, 26; 
              6, 98, 80] ./255; 


path = uigetdir();


listConditions = {'24 hrs ON', '24 hrs ON, 8 hrs OFF'};



  parentdirectory = dir(append(path, f, '*.csv'));


cpvalues = [];
primerslist = [];
conditionsnames = [];

    for t = 1:length({parentdirectory.name}) %this loop will go over every folder that has the name nameNotchstatus on it
    
        
        disp(parentdirectory(t).name);
        
        cpvaluestemp = readtable(append(parentdirectory(t).folder, f, parentdirectory(t).name));
        conditionsnames = [conditionsnames; cpvaluestemp(:, 2:end).Properties.VariableNames];
        primerslist = [primerslist, cpvaluestemp{:, 1}];

        cpvalues = cat(3, cpvalues, cpvaluestemp{:, 2:end});

    end

cpvaluesrelative = 2.^(-cpvalues);

cpvaluesnormrab11 = [];

for s = 1:size(cpvaluesrelative, 3)
    for z = 1:size(cpvaluesrelative, 2 )

        cpvaluesnormrab11(:,z, s) = cpvaluesrelative(:,z, s) ./ cpvaluesrelative(5, z, s);

    end
end


% cpvaluesrelativenorm = 2.^(-cpvaluesnormrab11);
Xlabels = reordercats(categorical(primerslist(:, 1).'), primerslist(:, 1).');


figure('Name', 'ATAC', 'Position', [0 0 400 300]); 


y = [mean(cpvaluesnormrab11(:,2, :), 3, 'omitnan'), mean(cpvaluesnormrab11(:,1, :), 3, 'omitnan')];

hb = bar(y,...
    'EdgeColor', 'none');

hold on

err = [std(cpvaluesnormrab11(:,1, :), 0, 3, 'omitnan'), ...
    std(cpvaluesnormrab11(:,2, :), 0, 3, 'omitnan')]./ sqrt(size(cpvaluesnormrab11, 3));

for k = 1:size(y,2)
    % get x positions per group
    xpos = hb(k).XData + hb(k).XOffset;
    % draw errorbar
    errorbar(xpos, y(:,k), err(:,k), 'LineStyle', 'none', ... 
        'Color', 'k', 'LineWidth', 1);
end

set(gca,'xticklabel', primerslist(:, 1)); 

[h, p] = ttest(cpvaluesnormrab11(1,1, :), cpvaluesnormrab11(1, 2, :))

[h, p] = ttest(cpvaluesnormrab11(2, 1, :), cpvaluesnormrab11(2, 2, :))
cpvaluesnormrab11(:,1, :)

set(gca, 'YScale', 'linear')
legend(listConditions,'Location','northeast');

orient(gcf,'landscape');
ylim([0, 6])
% saveas(gcf, append(path,'/ATACall linear', '.pdf'));



figure('Name', 'ATAC', 'Position', [0 0 400 300]); 


y = [mean(cpvaluesnormrab11(:,2, :), 3, 'omitnan'), mean(cpvaluesnormrab11(:,1, :), 3, 'omitnan')];

hb = bar(y,...
    'EdgeColor', 'none');

hold on

err = [std(cpvaluesnormrab11(:, 2, :), 0, 3, 'omitnan'), ...
    std(cpvaluesnormrab11(:, 1, :), 0, 3, 'omitnan')]./ sqrt(size(cpvaluesnormrab11, 3));

for k = 1:size(y,2)
    % get x positions per group
    xpos = hb(k).XData + hb(k).XOffset;
    % draw errorbar
    errorbar(xpos, y(:,k), err(:,k), 'LineStyle', 'none', ... 
        'Color', 'k', 'LineWidth', 1);
end

set(gca,'xticklabel', primerslist(:, 1)); 


pvalues = [];

for l = 1:size(cpvaluesnormrab11, 1)

[h, p] = ttest(cpvaluesnormrab11(l,1, :), cpvaluesnormrab11(l, 2, :));

pvalues = [pvalues; p];

end

 


cpvaluesnormrab11(:,1, :)
legend(listConditions,'Location','northeast');

set(gca, 'YScale', 'log')
orient(gcf,'landscape');
% ylim([0, 6])
% saveas(gcf, append(path,'/ATACall log', '.pdf'));

