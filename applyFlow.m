function [ dt, dx,dy ] = applyFlow( im1, im2, u, v )
% Returns the result when the flow field <u, v> is applied to im.
    [height, width] = size(im1);
    [inputPtsX, inputPtsY] = meshgrid(1:width, 1:height);
    inputPtsX = inputPtsX + u;
    inputPtsY = inputPtsY + v;
    warpIm = interp2(im2, inputPtsX, inputPtsY);
    outOfBounds = isnan(warpIm);
    
    dt = warpIm - im1;
    dt(outOfBounds) = 0;
    
    filt = [1 -8 0 8 -1]/12; % Wedel "improved TV L1"
    dx = imfilter(im1, filt, 'symmetric');
    dy = imfilter(im1, filt', 'symmetric');
    
    dx(outOfBounds) = 0;
    dy(outOfBounds) = 0;
    
end

