function convert()

    nColors = 16;
    
    pngFileNames = dir('*.png');
    nPngFileNames = length(pngFileNames);
    for i=1:nPngFileNames
        allPngFileNames{i,1} = pngFileNames(i).name;
    end
        
    nAllPngFileNames = length(allPngFileNames);
 
    if (nAllPngFileNames == 1)
        fileName = allPngFileNames{1};
    elseif (nAllPngFileNames > 1)
        [fileName, reply] = menu_file_name(allPngFileNames);
        if strcmp(reply, '!')
            return
        end
    end

%     fileName = 'BC2_SO_As.png';
    
    rgb=imread(fileName);
    
    figure(1);
    
    clf;
    
    imshow(rgb);
    
    [X_no_dither,map]= rgb2ind(rgb,nColors,'nodither');
    
    figure(2), imshow(X_no_dither,map);
    
    title(fileName);
    
       
    isWhiteColor = ones(nColors,1);
    
    figure(1);
    [X_no_dither,map]= rgb2ind(rgb,nColors,'nodither');
    whiteColors = find(isWhiteColor == 1);
    for i = 1:length(whiteColors)
        map(whiteColors(i),1:3) = [1, 1, 1];
    end
    figure(3), imshow(X_no_dither,map);
    title(fileName);
    
    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        %% display menu %%
        
        clc;
        
        strng = sprintf('Please enter a selection from the menu below ');
        disp(strng);

        for i = 1:nColors
        
            strng = sprintf('        %2d) Remove color #%d?: %s', i, i, bin2str(isWhiteColor(i)));
            disp(strng);

        end
        
        disp('         f) Flip all toggles');

        disp('         p) Plot figure');

        disp('         !) Exit');
        
        reply = lower(input('\nYour selection: ', 's'));

        isEnterSwitch = 1;
        for i = 1:nColors
            if (str2double(reply) == i)
                isWhiteColor(i) = ~isWhiteColor(i);
                isEnterSwitch = 0;
                reply = [];
            end
        end
        
        if isEnterSwitch

            switch reply
                
                case 'f'
                    for i = 1:nColors
                        isWhiteColor(i) = ~isWhiteColor(i);
                    end
                    reply = [];
                    
                case 'p'
                    figure(1);
                    [X_no_dither,map]= rgb2ind(rgb,nColors,'nodither');
                    whiteColors = find(isWhiteColor == 1);
                    for i = 1:length(whiteColors)
                        map(whiteColors(i),1:3) = [1, 1, 1];
                    end
                    figure(3), imshow(X_no_dither,map);
                    title(fileName);
                    reply = [];
                    
                case '!'
                    %exit
                    
                otherwise
                    reply = [];
                    
            end % switch
        
        end % if isEnterSwitch
            
    end % while loop

    clean_exit()% exit
    
end
