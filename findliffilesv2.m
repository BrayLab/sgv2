function [Listdirectory]=findliffiles()

%the lifs have to be contained within a folder, ideally with the same name
%as the lif file. This makes all the analysis more organised

pathtolif = uigetdir(); 

f = filesep;

parentdirectory = dir(pathtolif);

Listdirectory = [];
    
for t = 1:length({parentdirectory.name}) %this loop is to get the folder that will contain many folders at the same time with the diffrent replicates
    
    if  parentdirectory(t).name(1) == "." %this avoids all the folders that are part of the system and begin with ".", ie '.DS_Store'
    
    else   Listdirectory = [Listdirectory, dir(append(parentdirectory(t).folder, f, parentdirectory(t).name, f, '*.lif'))];
    
    end

    
end

end
