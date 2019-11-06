function [isRemoveColor,isCarouselMode,hMark,X,map,nPixelsTotal] = carousel_mode(X,map,nColors,rgb)
    isRemoveColor = ones(nColors,1);
    hMark = zeros(nColors,1);
    
    h = imhist(X, map);
    
    for i = 1:nColors
        isRemoveColor(i) = ~isRemoveColor(i);
        isCarouselMode = i;
        [X, map, pixelCounts] = update_figures(rgb, nColors, isRemoveColor, isCarouselMode);
%         ch = getkey;
        
%         if (ch == 109) % 'm'
        if (pixelCounts > 0)
            hMark(i) = h(i);
        end
        
        isRemoveColor(i) = ~isRemoveColor(i);
    end
    
    nPixelsTotal = display_histogram_of_marked_color_channels(hMark);
    
    isRemoveColor = ~hMark;
    isCarouselMode = 0;

end % carousel_mode()