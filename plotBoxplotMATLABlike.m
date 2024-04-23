function[] = plotBoxplot(All,Nicknames,ExpLabels,Jitter,BarW,Title,FontSize,DotSize,CMAP,FaceAlpha,LineWidth,FontSizeTitle,Ylim)
%set(gcf,'defaultAxesColorOrder',CMAP)


Cat = repmat([1:1:length(Nicknames)],2,1)+[-BarW;+BarW];
RepAll = ones(size(All));

CatX = repmat([1:1:length(Nicknames)],size(All,1),1);

gscatter(CatX(:)+(rand(length(CatX(:)),1)-0.5).*Jitter, All(:), CatX(:),CMAP,'.',DotSize); hold on

%boxes, be careful with the colormap as there shouldnt be more values than
%the ones you use
p = patch([Cat;flip(Cat)],[repmat(quantile(All,0.25),2,1);repmat(quantile(All,0.75),2,1)],[1:length(Nicknames)]','EdgeColor','none','FaceAlpha',FaceAlpha) ; hold on
colormap(gca, CMAP);

%error bars with the STD
% 
% eb = errorbar([1:1:length(Nicknames);nan(1,length(Nicknames))],[nanmean(All);nanmean(All)],...
%             [nanstd(All);nanstd(All)], [nanstd(All);nanstd(All)],...
%             'LineStyle','-','LineWidth',LineWidth./2);
% 
% set(eb, {'color'}, num2cell(CMAP, 2));
% 
% 


%error bars with the STD starting from the top the box

MAXvaluesnotoulier = max(~isoutlier(All, 'quartiles') .* All,[], 1, 'omitnan');
MINvaluesnotoulierint = ~isoutlier(All, 'quartiles');
MINvaluesnotoulierint = double(MINvaluesnotoulierint);
try 
    MINvaluesnotoulierint(MINvaluesnotoulierint==0) = NaN;

end
MINvaluesnotoulier = min(MINvaluesnotoulierint .* All,[], 1, 'omitnan');


upperwhisker = plot(repmat(1:1:length(Nicknames),2,1), [MAXvaluesnotoulier; quantile(All,0.75)], '-','DisplayName', 'median','LineWidth',LineWidth/2);
set(upperwhisker, {'color'}, num2cell(CMAP, 2));



upperhat = plot([[1:1:length(Nicknames)] - BarW/5; [1:1:length(Nicknames)] + BarW/5],  repmat(MAXvaluesnotoulier, 2, 1), ...
       '-','DisplayName', 'median','LineWidth',LineWidth/2);
set(upperhat, {'color'}, num2cell(CMAP, 2));


lowerwhisker =  plot(repmat(1:1:length(Nicknames),2,1), [MINvaluesnotoulier; quantile(All,0.25)], '-','DisplayName', 'median','LineWidth',LineWidth/2);
set(lowerwhisker, {'color'}, num2cell(CMAP, 2));

lowerhat = plot([[1:1:length(Nicknames)] - BarW/5; [1:1:length(Nicknames)] + BarW/5],  repmat(MINvaluesnotoulier, 2, 1), ...
       '-','DisplayName', 'median','LineWidth',LineWidth/2);
set(lowerhat, {'color'}, num2cell(CMAP, 2));

%Bar with the median
MedianPlot = plot(Cat,repmat(nanmedian(All),2,1),'-','DisplayName','median','LineWidth',LineWidth);

for i = 1:size(CMAP, 1)
    MedianColorMap(i, :) = [CMAP(i, :), FaceAlpha];  
end


set(MedianPlot, {'color'}, num2cell(MedianColorMap, 2))
MeanPlot = gscatter([1:1:length(Nicknames)],[nanmean(All)], [1:1:length(Nicknames)], CMAP,'x',DotSize, 'LineWidth', 20);


for o = 1:1:size(MeanPlot, 1)
    MeanPlot(o).LineWidth = LineWidth/2;
end




%plot(Cat,repmat(quantile(NumOn,0.25)*100,2,1),'-','DisplayName','Q1','Color',[0.6980,0.0941,0.1686,0.8],'LineWidth',LineWidth)
%plot(Cat,repmat(quantile(NumOn,0.75)*100,2,1),'-','DisplayName','Q3','Color',[0.6980,0.0941,0.1686,0.8],'LineWidth',LineWidth)
%plot(Cat,repmat(nanmedian(All),2,1),'-','DisplayName','mean','LineWidth',LineWidth)
% errorbar([1:1:length(Nicknames);nan(1,length(Nicknames))],[nanmean(All);nanmean(All)],...
%     [nanstd(All);nanstd(All)], [nanstd(All);nanstd(All)],'LineStyle','-','LineWidth',LineWidth./2)
% 


legend off
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)
%set(findobj(gca, 'type', 'line'), 'linew',2)
%set(findall(gca,'type','text'),'fontSize',4,'fontWeight','bold')
set(gca,'FontSize',FontSize)
title(Title,'FontSize',FontSizeTitle); box off; 
    xlim([BarW,length(Nicknames)+1-BarW])
    ylim([Ylim])

set(gca, 'Color', 'None')

end