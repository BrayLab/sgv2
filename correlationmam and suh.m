mkdir('/Users/fjavierdha/Documents/MATLAB')
f = filesep;
warning ('on','all')


blue = [0 0.5 1];
red = [1 0.2 0.2];
green = [0.11 0.7 0.32];
orange = [1 0.58 0.01];
purple = [0.74 0.01 1];
listConditions = {'Mam', 'Mam'};%, 'kto', 'med1'};
listColor = cat(1, green, purple);



path = uigetdir()


parentdirectory = dir(append(path, '/*middle pixels*.txt'));
MeansofConditions = []

% 
% MS2intensity = readmatrix(append(parentdirectory(1).folder, '/', parentdirectory(5).name));
% Mamintensity = readmatrix(append(parentdirectory(2).folder, '/', parentdirectory(6).name));

MS2intensity = AllMatrix(:,2)
Mamintensity = AllMatrix2(:,2);



figure;

scatter(MS2intensity, Mamintensity, 200,  '.', 'MarkerFaceColor', [0.11 0.7 0.32]);
ylabel('MamGFP ');
xlabel ('CSLmCherry');

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

 saveas(gcf, append(path, f, "correlation ", 'MS2 and MamHalo polynomial fit raw intensity)', '  intensity', ".pdf"));

 
 figure;
 
 % Get coefficients of a line fit through the data.
 
 x = MS2intensity;
 y = Mamintensity;
coefficients = polyfit(x, y, 1);
% Create a new x axis with exactly 1000 points (or whatever you want).
xFit = linspace(min(x), max(x), 1000);
% Get the estimated yFit value for each of those 1000 new x locations.
yFit = polyval(coefficients , xFit);
% Plot everything.
plot(x, y, 'b.', 'MarkerSize', 15); % Plot training data.
hold on; % Set hold on so the next plot does not blow away lslithe one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
grid on;

