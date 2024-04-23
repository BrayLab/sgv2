function[Out] = findpixelsizeinmetadataseries(Info)
    Out = NaN;
    try
        
        PhysicalSizePixel = Info(find(cellfun(@(x) isempty(x), strfind(Info, 'PhysicalSizeX')) == 0));
        PhysicalSizePixel = PhysicalSizePixel(1:2:end);
        
        
        
        for w  = 1:size(PhysicalSizePixel, 1)
            if w == 1
                Out = str2num(extractBefore(extractAfter(PhysicalSizePixel{1}, '"'), '"'));
            else
             Out(w) = str2num(extractBefore(extractAfter(PhysicalSizePixel{w}, '"'), '"'));
             
            end
        end
                
    end
end