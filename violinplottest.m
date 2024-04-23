
data = {AllMatrix(:,1), AllMatrix(:,2)}


xvalues = linspace( prctile(data,1), prctile(data,99), 100 );

[f,xi] = ksdensity( data(:),xvalues,'Bandwidth',50, ...
    'BoundaryCorrection','reflection');

figure;
patch( 0-[f,zeros(1,numel(xi),1),0],[xi,fliplr(xi),xi(1)],'r' )



% Imagine how your plot will look!
boxwidth = 0.7; % How wide should the boxes be? (between 0.5 and 1)
linewidth = 2; % How thick will the lines be on the box and the violin?
linecolor = 'k'; % What color should the outlines be?
palette = parula( numel(data) ); % What palette will you use for the violins?

% Set up a figure with as many subplots as you have data categories
figure('color','w'); plts = arrayfun( @(x) subplot(1,numel(data),x,'nextplot','add'), [1:numel(data)] );

% Calculate statistics for the box-plot to place next to the violin
stat_fxn = @(x) [prctile(x,25),median(x),prctile(x,75),prctile(x,5),prctile(x,95)];


[f,xi] = deal({},{});
for i = 1:numel(data)
    x = data{i};
    [f{i},xi{i}] = ksdensity( x, linspace( prctile(x,1),prctile(x,99), 100 ) );
    patch( 0-[f{i},zeros(1,numel(xi{i}),1),0],[xi{i},fliplr(xi{i}),xi{i}(1)],palette(i,:),'parent',plts(i) )
end

% Use this function to calculate the maximum extent of each violin so you get symmetrical boxes
maxval = max(cellfun( @(x) max(x), f ));

for i = 1:numel(data)
    stats = stat_fxn(data{i});
    line([maxval/2,maxval/2],[stats(4),stats(5)],'parent',plts(i) );
    patch( rescale([0,maxval,maxval,0,0],maxval*(1-boxwidth),maxval*boxwidth),...
        [stats(1),stats(1),stats(3),stats(3),stats(1)], palette(i,:), 'parent', plts(i) );
    line([maxval*(1-boxwidth),maxval*boxwidth],[stats(2),stats(2)], 'parent', plts(i) );    
end

% Grab each object and customize it using arrayfun
lines = findobj(gcf,'Type','Line');
arrayfun( @(line) set(line,'LineWidth',linewidth,'Color',linecolor), lines );

patches = findobj(gcf,'Type','Patch');
arrayfun( @(patch) set(patch,'LineWidth',linewidth,'EdgeColor',linecolor), patches );

[x0,x1] = deal(-maxval,maxval);
arrayfun(@(x) set(x,'XLim',[x0,x1],'xlabel',[],'ylabel',[],'xcolor','w','ycolor','w'),...
    plts )