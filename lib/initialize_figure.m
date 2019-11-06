function [rgb, isRemoveColor, isCarouselMode, X, map, hMark] = initialize_figure(fileName, nColors)

    rgb=imread(fileName);
    isRemoveColor = ones(nColors,1);
    isCarouselMode = 0;
    [X, map] = update_figures(rgb, nColors, isRemoveColor, isCarouselMode);
    hMark = zeros(nColors);

end % initialize_figure()

