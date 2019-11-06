function convert()

    addpath data lib
    
    nColors = 16;
    directory = './data/';
    suffix = 'png';
    
    [fileName] = get_file_name(directory, suffix);
      
    if ~strcmp(fileName, '!')
        
        [base, layer, neurite] = parse_file_name(fileName);
    
        [rgb, isRemoveColor, isCarouselMode, X, map, hMark] = initialize_figure(fileName, nColors);

        reply = [];
        
        nLayers = 0;
        
        % main loop to display menu choices and accept input
        % terminates when user chooses to exit
        while (isempty(reply))
            %% display menu %%
            
            clc;
            
            hMarkNo = length(find(hMark > 0));
            
            strng = sprintf('Please enter a selection from the menu below ');
            disp(strng);
            
            for i = 1:nColors
                strng = sprintf('        %2d) Remove color #%d?: %s', i, i, bin2str(isRemoveColor(i)));
                disp(strng);
            end
            
            disp('         c) Carousel mode (type ''m'' to mark color channel)');
            
            disp('         e) Export to an Excel file');
            
            disp('         f) Flip all toggles');
            
            strng = sprintf('         h) Display histogram of the %d marked color channels', hMarkNo);
            disp(strng);
            
            disp('         l) Load a new .PNG figure file');
            
            strng = sprintf('         m) Set all %d marked color-channel responses to NO', hMarkNo);
            disp (strng);
            
            disp('         n) Set all 16 responses to NO');
            
            disp('         p) Plot figure');
            
            disp('         s) Save figure and inverted figure');
            
            disp('         x) Execute conversion of figure to a histogram');
            
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
                    
                    case ''
                        disp('YO');
                        reply = [];
                    
                    case 'c' % carousel mode
                        [isRemoveColor,isCarouselMode,hMark,X,map] = carousel_mode(X,map,nColors,rgb);
                        reply = [];
                        
                    case 'e' % export to an Excel file
                        nLayers = nLayers + 1;
                        nPixelsExport(nLayers) = nPixelsTotal;
                        subregionsExport(nLayers) = menu_subregion();
                        export_to_excel(nColors, nPixelsExport, subregionsExport, base, layer, neurite, isRemoveColor);
                        reply = [];
                        
                    case 'f' % flip all toggles
                        for i = 1:nColors
                            isRemoveColor(i) = ~isRemoveColor(i);
                        end
                        reply = [];
                        
                    case 'h' % display histogram of marked color channels
                        nPixelsTotal = display_histogram_of_marked_color_channels(hMark);
                        reply = [];
                        
                    case 'l' % load new .PNG figure file
                        [fileName] = get_file_name(directory, suffix);
                        [base, layer, neurite] = parse_file_name(fileName);
                        [rgb, isRemoveColor, isCarouselMode, X, map, hMark] = initialize_figure(fileName, nColors);

                        reply = [];
                        
                    case 'm' % set all marked responses to NO
                        isRemoveColor = ~hMark;
                        reply = [];
                        
                    case 'n' % set all 16 responses to NO
                        isRemoveColor = zeros(nColors,1);
                        reply = [];
                        
                    case 'p' % plot figure
                        [X, map] = update_figures(rgb, nColors, isRemoveColor, isCarouselMode);
                        reply = [];
                        
                    case 's' % save figure and its inverse
                        [isRemoveColor,X,map] = save_figures(isRemoveColor,rgb,nColors,isCarouselMode,base,layer,neurite);
                                               
                        reply = [];
                        
                    case 'x' % Execute conversion of figure to a histogram
                        idx = find(isRemoveColor == 0);
                        nOutColors = length(idx);
                        
                        nPixelsTotal = display_histogram_of_marked_color_channels(hMark);
                        
                        listFileName = sprintf('%s_%s_%dcolors_%s_%dcolors_list.txt', base, layer, nColors, neurite, nOutColors);
                        fid = fopen(listFileName, 'w');
                        for i = 1:nColors
                            if ~isRemoveColor(i)
                                fprintf(fid, '%d\n', i);
                            end
                        end
                        fclose(fid);
                        
                        reply = [];
                        
                    case '!'
                        %exit
                        
                    otherwise
                        reply = [];
                        
                end % switch
                
            end % if isEnterSwitch
            
        end % while loop

    end % if ~strcmp(fileName, '!')
        
    clean_exit()% exit
    
end % convert()