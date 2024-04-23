function Listdirectory = findliffiles(directoryPath)
    % Finds ".lif" files in a specified directory, excluding system folders.
    % Inputs:
    %   - directoryPath: Path to the directory to search in.
    % Outputs:
    %   - Listdirectory: List of ".lif" files found in the directory.

    % If the directory path is not provided, allow the user to select one.
    if nargin < 1
        directoryPath = uigetdir();
    end

    f = filesep;

    % Get the list of files and folders in the specified directory.
    parentDirectory = dir(directoryPath);

    Listdirectory = cell(1, numel(parentDirectory));
    count = 0;

    % Loop through the files and folders in the parent directory.
    for t = 1:length(parentDirectory)
        folderName = parentDirectory(t).name;

        % Exclude system folders that start with "." (e.g., '.DS_Store').
        if ~startsWith(folderName, '.')
            lifFiles = dir(fullfile(directoryPath, folderName, ['*' f '*.lif']));

            % Append the found ".lif" files to the list.
            if ~isempty(lifFiles)
                count = count + 1;
                Listdirectory{count} = lifFiles;
            end
        end
    end

    % Remove any empty cells and convert to a structure array.
    Listdirectory = cat(1, Listdirectory{1:count});
end