function update_figures(rgb, nColors, isRemoveColor)

    figure(1);
    clf;
    imshow(rgb);
    [X_no_dither,map]= rgb2ind(rgb,nColors,'nodither');
    whiteColors = find(isRemoveColor == 1);
    for i = 1:length(whiteColors)
        map(whiteColors(i),1:3) = [1, 1, 1];
    end
    figure(3);
    clf;
    imshow(X_no_dither,map);

end