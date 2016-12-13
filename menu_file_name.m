function [fileName, reply] = menu_file_name(HippFileNames)
% modified 20100917 by Diek W. Wheeler, Ph.D

    nPngFileNames = length(HippFileNames);

    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        %% display menu %%
        
        clc;
        
        strng = sprintf('Please select a png file from the selections below.');
        disp(strng);

        for i = 1:nPngFileNames
            strng = sprintf('    %d) %s', i, HippFileNames{i});
            disp(strng);
        end % for i
        
        disp('    @) Use UI to select file');
        disp('    !) Exit');
        
        reply = input('\nYour selection: ', 's');

        
        %% process input %%
        
        num = str2double(reply);

        if num <= nPngFileNames
            fileName = HippFileNames{num};             
        
        else
            switch reply               
                case '@'
                    [fileName filePath] = uigetfile( '*.png', 'Select PNG file' );
                    
                    if isequal(fileName, 0)
                        disp(' !! NO VALID PNG FILE SELECTED !! ');
                        pause
                        reply = [];

                    else
                        dotLocats = strfind(fileName, '.');
                        extension = fileName(dotLocats(end):length(fileName));
                        
                        if ~(isequal(extension, '.png'))
                            disp(' !! PLEASE SELECT A FILE WITH .png EXTENSION !! ');
                            pause
                            reply = [];
                        end
                        
                    end
                    
                case '!'
                    fileName = '';
                    
                otherwise
                    reply = [];
                
            end % switch
            
        end % if num

    end % while loop
    
end % menu_file_name