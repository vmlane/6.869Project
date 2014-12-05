function [ outIm ] = applyFlow( im, u, v )
% Returns the result when the flow field <u, v> is applied to im.
    [height, width] = size(im);
    [inputPtsX, inputPtsY] = meshgrid(1:width, 1:height);
    inputPtsX = inputPtsX + u;
    inputPtsY = inputPtsY + v;
    outIm = interp2(im, inputPtsX, inputPtsY);
    outIm(isnan(outIm)) = 0;

end

