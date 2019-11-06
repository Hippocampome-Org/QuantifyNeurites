function [X_no_dither, map, pixelCounts] = update_figures(rgb, nColors, isRemoveColor, carouselModeValue)

    figure(1);
    clf;
    imshow(rgb);
    [X_no_dither,map]= rgb2ind(rgb,nColors,'nodither');
    if (size(map,1) < nColors)
        map(nColors,1:3) = [0 0 0];
    end

    whiteColors = find(isRemoveColor == 1);
    for i = 1:length(whiteColors)
        map(whiteColors(i),1:3) = [1, 1, 1];
    end

    figure(1);
    clf;
    imshow(X_no_dither,map);

    if (carouselModeValue > 0)
        h = imhist(X_no_dither, map);
        idx = find(isRemoveColor == 0);
        
%         if ((sum(map(idx,:)) == 0) || (sum(map(idx,:)) > 2.9))
        if (sum(map(idx,:)) > 2.9)
            pixelCounts = 0;
        else
            pixelCounts = h(idx);
        end
        strng = sprintf('Color #%d is [%d %d %d] with %d pixels', carouselModeValue, 255*map(idx,1), 255*map(idx,2), 255*map(idx,3), pixelCounts);
        title(strng);
    end
end