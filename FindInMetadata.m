function[Out] = FindInMetadata(Info,String)
    Out = NaN;
    try
        Index = find(cellfun(@(x) isempty(x), strfind(Info,String)) == 0);
        D = Info{Index}; D = strsplit(D,'='); 
        if isempty(str2num(D{2})) %% this will try making D{2} a number, if it isn't one it will be empty
                Out = D{2};
        else
            Out = str2num(D{2});
        end 
       
    end
end