%%plotting lines across 


[mamfile, mampath]  = uigetfile('*.csv')

[suhfile, suhpath] = uigetfile('*.csv')


   
  mamdata = readtable([mampath, mamfile], 'HeaderLines',1)
  
  mamdata.Properties.VariableNames{:,1} = 'time';
  mamdata.Properties.VariableNames{:,2} = 'intensity';
  
  
 mamdata{:,2}=  ((mamdata{:,2} - min(mamdata{:,2})) ./ max((mamdata{:,2} - min(mamdata{:,2}))))
  
   
  suhdata = readtable([suhpath, suhfile], 'HeaderLines',1)
  
  suhdata.Properties.VariableNames{:,1} = 'time';
  suhdata.Properties.VariableNames{:,2} = 'intensity';
  
   suhdata{:,2}=  ((suhdata{:,2} - min(suhdata{:,2})) ./ max((suhdata{:,2} - min(suhdata{:,2}))))
  
   
 hold on

plot( mamdata{:,1},  mamdata{:,2}, 'Color',  [0 1 1], 'LineWidth',  2);
xlim([mamdata{1,1}, mamdata{end,1}]);

ylabel('skdYFP normalised intensity', 'FontSize', 14, 'color',   [0 1 1]);

xlabel('distance (um)', 'FontSize', 14)
grid on

yyaxis right;

ylabel('MamHalo normalised intensity', 'FontSize', 14, 'color', [1 0 1]);


plot( suhdata{:,1},  suhdata{:,2}, 'Color',  [1 0 1], 'LineWidth',  2);
xlim([suhdata{1,1}, suhdata{end,1}]);


orient(gcf,'landscape');
saveas(gcf, append(mampath,'normalised intenseties.pdf'));



  