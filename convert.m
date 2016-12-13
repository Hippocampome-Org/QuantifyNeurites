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

        disp('         s) Save figure and inverted figure');

        disp('         x) Execute conversion of figures to histograms');

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
                    
                case 's'
                    idx = find(fileName == '_');
                    i = length(idx);
                    neurite = fileName(idx(i)+1:idx(i)+2);
                    i = i - 2;
                    layer = fileName(idx(i)+1:idx(i+1)-1);
                    base = fileName(1:idx(i)-1);
                    idx = find(isWhiteColor == 0);
                    nColors = length(idx);
                    outFileName = sprintf('%s_%s_16colors_%s_%dcolors.png', base, layer, neurite, nColors);
                    figure(3);
                    orient(gcf, 'portrait');
                    print(gcf, '-dpng', outFileName);
                    for i = 1:nColors
                        isWhiteColor(i) = ~isWhiteColor(i);
                    end
                    figure(1);
                    [X_no_dither,map]= rgb2ind(rgb,nColors,'nodither');
                    whiteColors = find(isWhiteColor == 1);
                    for i = 1:length(whiteColors)
                        map(whiteColors(i),1:3) = [1, 1, 1];
                    end
                    outFileNameInverted = sprintf('%s_%s_16colors_%s_%dcolors_inverted.png', base, layer, neurite, nColors);
                    figure(3), imshow(X_no_dither,map);
                    title(fileName);
                    orient(gcf, 'portrait');
                    print(gcf, '-dpng', outFileNameInverted);
                    reply = [];
                    
                    
                case 'x'
                    histogramStr = sprintf('%s_%s_16colors_%s_%dcolors.txt', base, layer, neurite, nColors);
                    commandStr = sprintf('convert %s_%s_16colors_%s_%dcolors.png -format %%c histogram:info:%s', base, layer, neurite, nColors, histogramStr);
                    status = system(commandStr);
                    histogramInvertedStr = sprintf('%s_%s_16colors_%s_%dcolors_inverted.txt', base, layer, neurite, nColors);
                    commandStr = sprintf('convert %s_%s_16colors_%s_%dcolors_inverted.png -format %%c histogram:info:%s', base, layer, neurite, nColors, histogramInvertedStr);
                    status = system(commandStr);
                    
                    fid = fopen(histogramInvertedStr, 'r');
                    backgroundInverted = fscanf(fid, '%d:');
                    fclose(fid);
                    disp(['inverted background count = ', num2str(backgroundInverted)]);
                    
                    fid = fopen(histogramStr, 'r');
                    backgroundCell = textscan(fid, '%d: (%d, %d, %d) #%s %s');
                    fclose(fid);
                    disp(['regular background count = ', num2str(backgroundCell{1}(1))]);
                    summedCount = sum(backgroundCell{1})-backgroundCell{1}(end);
                    disp(['summed count = ', num2str(summedCount)]);
                    
                case '!'
                    %exit
                    
                otherwise
                    reply = [];
                    
            end % switch
        
        end % if isEnterSwitch
            
    end % while loop

    clean_exit()% exit
    
end
