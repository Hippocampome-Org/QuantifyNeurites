function [isRemoveColor,X,map] = save_figures(isRemoveColor,rgb,nColors,isCarouselMode,base,layer,neurite)
    idx = find(isRemoveColor == 0);
    nOutColors = length(idx);
    tagline = {'', '_inverted'};
    [X, map] = update_figures(rgb, nColors, isRemoveColor, isCarouselMode);
    
    for i = 1:2
        
        outFileName = sprintf('./output/%s_%s_%dcolors_%s_%dcolors%s.png', base, layer, nColors, neurite, nOutColors, tagline{i});
        figure(1);
        orient(gcf, 'portrait');
        print(gcf, '-dpng', outFileName);
        
        isRemoveColor = ~isRemoveColor;
        [X, map] = update_figures(rgb, nColors, isRemoveColor, isCarouselMode);
        
    end % i

end % save_figures()
