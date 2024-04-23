clear all
close all


f = filesep;
fontname = 'Lato'; 






path = uigetdir();


listConditions = {'LacZ, LacZ', 'LacZ, MamDN', 'NDECD, LacZ', 'NDECD, MamDN'};



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


y = [mean(cpvaluesnormrab11(:, 1, :), 3, 'omitnan'),...
    mean(cpvaluesnormrab11(:, 2, :), 3, 'omitnan'),...
    mean(cpvaluesnormrab11(:, 3, :), 3, 'omitnan'),...
    mean(cpvaluesnormrab11(:, 4, :), 3, 'omitnan')];

hb = bar(y,...
    'EdgeColor', 'none');

hold on

err = [std(cpvaluesnormrab11(:,1, :), 0, 3, 'omitnan'), ...
       std(cpvaluesnormrab11(:,2, :), 0, 3, 'omitnan'), ...
       std(cpvaluesnormrab11(:,3, :), 0, 3, 'omitnan'), ...
       std(cpvaluesnormrab11(:,4, :), 0, 3, 'omitnan')]./ sqrt(size(cpvaluesnormrab11, 3));

for k = 1:size(y,2)
    % get x positions per group
    xpos = hb(k).XData + hb(k).XOffset;
    % draw errorbar
    errorbar(xpos, y(:,k), err(:,k), 'LineStyle', 'none', ... 
        'Color', 'k', 'LineWidth', 1);
end

set(gca,'xticklabel', primerslist(:, 1)); 


figure('Name', 'ATAC', 'Position', [0 0 400 300]); 


y = [mean(cpvaluesnormrab11(:, 1, :), 3, 'omitnan'),...
    mean(cpvaluesnormrab11(:, 2, :), 3, 'omitnan'),...
    mean(cpvaluesnormrab11(:, 3, :), 3, 'omitnan'),...
    mean(cpvaluesnormrab11(:, 4, :), 3, 'omitnan')];

y = y([1, 2, 3, 6], :);

hb = bar(y,...
    'EdgeColor', 'none');

hold on

cpvaluesnormrab11 = cpvaluesnormrab11
err = [std(cpvaluesnormrab11(:,1, :), 0, 3, 'omitnan'), ...
       std(cpvaluesnormrab11(:,2, :), 0, 3, 'omitnan'), ...
       std(cpvaluesnormrab11(:,3, :), 0, 3, 'omitnan'), ...
       std(cpvaluesnormrab11(:,4, :), 0, 3, 'omitnan')]./ sqrt(size(cpvaluesnormrab11, 3));

err = err([1, 2, 3, 6], :);

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


legend(listConditions,'Location','northeast');


set(gca, 'YScale', 'linear')

orient(gcf,'landscape');


ylim([0, 6.5])
saveas(gcf, append(path,'/ATACall linear selected', '.pdf'));


figure('Name', 'ATAC', 'Position', [0 0 400 300]); 


% y = [mean(cpvaluesnormrab11(:,2, :), 3, 'omitnan'), mean(cpvaluesnormrab11(:,1, :), 3, 'omitnan')];

hb = bar(y,...
    'EdgeColor', 'none');

hold on
% 
% err = [std(cpvaluesnormrab11(:, 2, :), 0, 3, 'omitnan'), std(cpvaluesnormrab11(:, 1, :), 0, 3, 'omitnan')];

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

set(gca, 'YScale', 'log')


legend(listConditions,'Location','northeast');
orient(gcf,'landscape');
% ylim([0, 6])
saveas(gcf, append(path,'/ATACall log', '.pdf'));


% % ANOVA test

% pvalues = [];
% 
% 
% for l = 1:size(cpvaluesnormrab11, 1) %this look will go thourgh each set of primers
% 
% 
%     cpvaluesnormrab11invector = [];
%     
%     for  b = 1:size(cpvaluesnormrab11, 2)
%         cpvaluesnormrab11invector = cat(1,cpvaluesnormrab11invector, permute(cpvaluesnormrab11(l, b, :), [3 2 1]));
%     end   
%     cpvaluesnormrab11invector
% 
% 
%     conditionsinvector = [];
% 
%     for  b = 1:size(conditionsnames, 2)
%         conditionsinvector = cat(1, conditionsinvector, repmat(conditionsnames(l, b),[1, size(cpvaluesnormrab11, 3)]).');
%     end   
%     
%     conditionsinvector
%  
%     [p,t,stats] = anova1(cpvaluesnormrab11invector, conditionsinvector)
% 
%     [c,m,h,gnames] = multcompare(stats);
% end

%%pairwise pvalues table


pvalues = [];


for b = 1:size(cpvaluesnormrab11, 1)

    
    
    [h, p1v2] = ttest(permute(cpvaluesnormrab11(b,1, :), [3 2 1]), permute(cpvaluesnormrab11(b,2, :), [3 2 1]));
    [h, p1v3] = ttest(permute(cpvaluesnormrab11(b,1, :), [3 2 1]), permute(cpvaluesnormrab11(b,3, :), [3 2 1]));
    [h, p1v4] = ttest(permute(cpvaluesnormrab11(b,1, :), [3 2 1]), permute(cpvaluesnormrab11(b,4, :), [3 2 1]));
    [h, p2v3] = ttest(permute(cpvaluesnormrab11(b,2, :), [3 2 1]), permute(cpvaluesnormrab11(b,3, :), [3 2 1]));
    [h, p2v4] = ttest(permute(cpvaluesnormrab11(b,2, :), [3 2 1]), permute(cpvaluesnormrab11(b,4, :), [3 2 1]));
    [h, p3v4] = ttest(permute(cpvaluesnormrab11(b,2, :), [3 2 1]), permute(cpvaluesnormrab11(b,4, :), [3 2 1]));

    pvalues(:,:, b) = [NaN p1v2, p1v3, p1v4; ...
                       p1v2, NaN, p2v3, p2v4; ...
                       p1v3, p2v3, NaN, p3v4; ...
                       p1v4, p2v4, p3v4, NaN];

    
end

p = ranksum(x,y)
 