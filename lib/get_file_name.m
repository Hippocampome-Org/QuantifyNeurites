function [fileName] = get_file_name(directory, suffix)

    if ~strcmp(directory(end), '/')
        directory = sprintf('%s/', directory);
    end
    
    if strcmp(suffix(1), '.')
        suffix = sprintf('%s', suffix(2:end));
    end
    
    allFilesDir = sprintf('%s*.%s', directory, suffix);
    
    fileNames = dir(allFilesDir);
    fileNames = fileNames(~strncmpi('~', {fileNames.name}, 1));
    
    if isempty(fileNames)
        error('\nError. \nThere are no .%s files in the %s directory.', suffix, directory);
        fileName = '!';
        allFileNames = '';
    else
        nFileNames = length(fileNames);
        for i=1:nFileNames
            allFileNames{i,1} = fileNames(i).name;
        end
        
        if (nFileNames == 1)
            fileName = allFileNames{1,1};
        elseif (nFileNames > 1)
            fileName = menu_file_name(allFileNames);
        end
    end % if isempty(fileNames)
    
end % get_file_name()

