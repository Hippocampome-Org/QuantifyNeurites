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
    
    isRemoveColor = ones(nColors,1);
    
    update_figures(rgb, nColors, isRemoveColor)
    
    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        %% display menu %%
        
        clc;
        
        strng = sprintf('Please enter a selection from the menu below ');
        disp(strng);

        for i = 1:nColors
            strng = sprintf('        %2d) Remove color #%d?: %s', i, i, bin2str(isRemoveColor(i)));
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
                isRemoveColor(i) = ~isRemoveColor(i);
                isEnterSwitch = 0;
                reply = [];
            end
        end
        
        if isEnterSwitch

            switch reply
                
                case 'f'
                    for i = 1:nColors
                        isRemoveColor(i) = ~isRemoveColor(i);
                    end
                    reply = [];
                    
                case 'p'
                    update_figures(rgb, nColors, isRemoveColor)
                    reply = [];
                    
                case 's'
                    idx = find(fileName == '_');
                    i = length(idx);
                    neurite = fileName(idx(i)+1:idx(i)+2);
                    i = i - 2;
                    layer = fileName(idx(i)+1:idx(i+1)-1);
                    base = fileName(1:idx(i)-1);
                    idx = find(isRemoveColor == 0);
                    nOutColors = length(idx);
                    
                    outFileName = sprintf('%s_%s_%dcolors_%s_%dcolors.png', base, layer, nColors, neurite, nOutColors);
                    figure(3);
                    orient(gcf, 'portrait');
                    print(gcf, '-dpng', outFileName);
                    
                    for i = 1:nColors
                        isRemoveColor(i) = ~isRemoveColor(i);
                    end
                    update_figures(rgb, nColors, isRemoveColor)

                    outFileNameInverted = sprintf('%s_%s_%dcolors_%s_%dcolors_inverted.png', base, layer, nColors, neurite, nOutColors);
                    title(fileName);
                    orient(gcf, 'portrait');
                    print(gcf, '-dpng', outFileNameInverted);
                    
                    for i = 1:nColors
                        isRemoveColor(i) = ~isRemoveColor(i);
                    end
                    update_figures(rgb, nColors, isRemoveColor)

                    reply = [];
                                       
                case 'x'
                    histogramStr = sprintf('%s_%s_%dcolors_%s_%dcolors.txt', base, layer, nColors, neurite, nOutColors);
                    commandStr = sprintf('convert %s_%s_%dcolors_%s_%dcolors.png -format %%c histogram:info:%s', base, layer, nColors, neurite, nOutColors, histogramStr);
                    status = system(commandStr);
                    
                    histogramInvertedStr = sprintf('%s_%s_%dcolors_%s_%dcolors_inverted.txt', base, layer, nColors, neurite, nOutColors);
                    commandStr = sprintf('convert %s_%s_%dcolors_%s_%dcolors_inverted.png -format %%c histogram:info:%s', base, layer, nColors, neurite, nOutColors, histogramInvertedStr);
                    status = system(commandStr);
                    
                    listFileName = sprintf('%s_%s_%dcolors_%s_%dcolors_list.txt', base, layer, nColors, neurite, nOutColors);
                    fid = fopen(listFileName, 'w');
                    for i = 1:nColors
                        if ~isRemoveColor(i)
                            fprintf(fid, '%d\n', i);
                        end
                    end
                    fclose(fid);
                    
                    fid = fopen(histogramInvertedStr, 'r');
                    backgroundInverted = textscan(fid, '%d: (%d, %d, %d) #%s %s');
                    fclose(fid);
                    
                    backgroundColorInvertedStr = cell2mat(backgroundInverted{6}(1));
                    
                    disp(' ');
                    
                    if strcmp(backgroundColorInvertedStr, 'black')

                        backgroundCountInverted = backgroundInverted{1}(1);
                        
%                         strng = sprintf('inverted background count = %d', backgroundInverted{1}(1));
%                         strng = sprintf('%s  %s', strng, cell2mat(backgroundInverted{6}(1)));
%                         disp(strng);
                        
                        fid = fopen(histogramStr, 'r');
                        backgroundCell = textscan(fid, '%d: (%d, %d, %d) #%s %s');
                        fclose(fid);
                        
                        backgroundColorStr = cell2mat(backgroundCell{6}(1));
                        backgroundCount = backgroundCell{1}(1);
                        
                        if strcmp(backgroundColorStr, 'black')
                           
                            if (backgroundCount < backgroundCountInverted)
                                disp('*** Regular background count is less than inverted background count! ***');
                            else
                                disp(['background count = ', num2str(backgroundCountInverted)]);
                                % sum = sum(all counts) - white counts - inverted black counts
                                summedCount = sum(backgroundCell{1})-backgroundCell{1}(end)-backgroundCountInverted;
                                disp(['summed count = ', num2str(summedCount)]);
                            end
                            
                        else
                        
%                             strng = sprintf('regular background count = %d  %s', backgroundCell{1}(1), cell2mat(backgroundCell{6}(1)));
%                             disp(strng);
                            
                            disp('backgound count = 0');
                            % sum = sum(all counts) - white counts
                            summedCount = sum(backgroundCell{1})-backgroundCell{1}(end);
                            disp(['summed count = ', num2str(summedCount)]);
                            
                        end
                    
                    else
                        
                        disp('*** Inverted background color is not black! ***');
                        
                    end
                    
                case '!'
                    %exit
                    
                otherwise
                    reply = [];
                    
            end % switch
        
        end % if isEnterSwitch
            
    end % while loop

    clean_exit()% exit
    
end
