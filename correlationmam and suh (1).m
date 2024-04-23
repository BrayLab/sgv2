mkdir('/Users/fjavierdha/Documents/MATLAB')
f = filesep;
warning ('on','all')


blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];
listConditions = {'MS2', 'Mam'};%, 'kto', 'med1'};
listColor = cat(1, green, purple);



path = uigetdir()


parentdirectory = dir(append(path, '/*middle pixels*.txt'));
MeansofConditions = []


MS2intensity = readmatrix(append(parentdirectory(1).folder, '/', parentdirectory(5).name));
Mamintensity = readmatrix(append(parentdirectory(2).folder, '/', parentdirectory(6).name));



figure;

scatter(MS2intensity, Mamintensity, 200,  '.', 'MarkerFaceColor', [0.11 0.7 0.32]);
ylabel('Su(H) intensity');
xlabel ('Mam intensity');

box 'on'


tmp = corrcoef(MS2intensity, Mamintensity);

str=sprintf('r= %1.2f',tmp(1,2));
T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str); 
set(T, 'fontsize', 14, 'verticalalignment', 'top', 'horizontalalignment', 'left');
l = lsline;
set(l,'LineWidth', 2)
% xlim([0, 4096])
% ylim([0, 4096])

orient(gcf,'landscape');

 saveas(gcf, append(path, f, "correlation ", 'MS2 and MamHalo)', '  intensity', ".pdf"));


