function out = medianFilter(im, height, width)
    %% Apply a median filter to the image
    % im = input image
    % width = window width (optional)
    % height = window height (optional)
    % output = the image after a median filter is applied
    if nargin < 2
        width = 5;
    end
    if nargin < 3;
        height = 5;
    end
    out = im;
    halfx = floor(width / 2); % half the window width
    halfy = floor(height / 2); % half the window height
    for y = halfy: size(im,1) - halfy + 1
        for x = halfx: size(im,2) - halfx + 1
           window = im(y + 1 - halfy: y + height - halfy, x + 1 - halfx : x + width - halfx);
           out(y,x) = median(window);
        end
    end