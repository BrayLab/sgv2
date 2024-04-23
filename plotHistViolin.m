function[] = plotHistViolin(All,RepAll,Nicknames,ExpLabels,BinWidthHist,Jitter,BarW,Title,FontSize,DotSize,CMAP,FaceAlpha,LineWidth,FontSizeTitle)
    Cat = repmat([1:1:length(Nicknames)],2,1)+[-BarW./2;0];

    Probs = {};
    Bins = {};
    for i = 1:length(Nicknames)
        h = histogram(All(~isnan(All(:,i)),i),'BinWidth',BinWidthHist,'Normalization','probability','FaceAlpha',0.3,'LineStyle','none','Visible','off'); hold on;
        Probs{i} = [0,h.Values];
        Bins{i} = [h.BinEdges];
    end
    Probs = Cell2Mat(Probs);
    Bins = Cell2Mat(Bins);
    %Bins(end-1,:) = [];
    %Bins(Probs==0) = NaN;
    %Probs(Probs==0) = NaN;

    CatX = repmat([1:1:length(Nicknames)],length(All),1);
    h = gscatter(CatX(:)+(rand(length(CatX(:)),1)*0.5-0.5).*Jitter, All(:), RepAll(:),CMAP,'.',DotSize);hold on
    patch([Cat;flip(Cat)],[repmat(quantile(All,0.25),2,1);repmat(quantile(All,0.75),2,1)],'red','EdgeColor','none','FaceAlpha',FaceAlpha); hold on
    plot(Cat,repmat(nanmean(All),2,1),'-','DisplayName','mean','Color',[0.6980,0.0941,0.1686],'LineWidth',LineWidth)
    %plot(Cat,repmat(quantile(BLenAll,0.25)*TimeRes/60,2,1),'-','DisplayName','Q1','Color',[0.6980,0.0941,0.1686,0.8],'LineWidth',LineWidth)
    %plot(Cat,repmat(quantile(BLenAll,0.75)*TimeRes/60,2,1),'-','DisplayName','Q3','Color',[0.6980,0.0941,0.1686,0.8],'LineWidth',LineWidth)
    %errorbar([1:1:length(Nicknames)],nanmean(BLenAll*TimeRes/60), nanstd(BLenAll*TimeRes/60)*0, nanstd(BLenAll*TimeRes/60),'Color',[0.6980,0.0941,0.1686,0.8],'LineStyle','none','LineWidth',0.5)
    Probs = medfilt1(Probs,3);
    Probs(isnan(Bins)) = NaN;
        Bins(isnan(Probs)) = NaN;
%         Bins(end+1,:) = 0;
%         Probs(end+1,:) = 0;


    for i = 1:size(Probs,2)
        %SmoothProbs(:,i) = smooth(Probs(:,i));
                %SmoothProbs(:,i) = Probs(:,i);
        Poly = polyshape(Probs(:,i).*BarW./max(Probs(:,i))+i,Bins(:,i))
        plot(Poly);hold on
    end
        %area(SmoothProbs*BarW./max(SmoothProbs+[1:1:length(Nicknames)],Bins,'FaceAlpha',FaceAlpha)

    %    plot(SmoothProbs.*BarW./max(SmoothProbs)+[1:1:length(Nicknames)],Bins)

    legend off
    xticks([1:1:length(Nicknames)])
    xticklabels(ExpLabels)
    set(gca,'FontSize',FontSize)
    %set(gca, 'YScale', 'log')
    title(Title,'FontSize',FontSizeTitle); box off;xlim([0+Jitter,length(Nicknames)+Jitter]); 
    %set(findobj(gca, 'type', 'line'), 'linew',2)
    ylim([0 inf])
end