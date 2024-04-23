function Out = findpixelsizeinmetadataseries(Info)
    % Extract physical size information from metadata.
    % Inputs:
    %   - Info: Metadata information.
    % Output:
    %   - Out: Extracted physical size values.

    Out = [];  % Initialize the output as an empty array

    try
        % Find the lines containing "PhysicalSizeX"
        indices = find(cellfun(@(x) ~isempty(x), strfind(Info, 'PhysicalSizeX')));

        % Extract the physical size values
        for index = 1:numel(indices)
            line = Info{indices(index)};

            % Extract the value between double quotes
            value = extractBetween(line, '"', '"');

            % Convert the value to a number
            pixelSize = str2double(value);

            % Append the pixelSize to the output
            Out = [Out, pixelSize];
        end
    catch
        % Handle any errors (e.g., invalid input data)
        % You can choose to return NaN or raise an error here.
        Out = NaN;
    end
end
