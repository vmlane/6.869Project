function pyramid = makeImagePyramid(im,numLevels,ratio,sigma)
    %% Create an image pyramid using a gaussian filter
    % im = input image
    % numLevels = number of pyramid levels
    % ratio = size of pyramid image / original image
    % sigma = std deviation of gaussian filter
    pyramid = cell(numLevels,1);
    P{1} = im;
    for i=2:numLevels
        % Apply Gaussian Filter
        filter = fspecial('gaussian',2*round(sigma*1.5),sigma);
        out = imfilter(im,filter,'symmetric');
        % resize image
        P{i} = imresize(out,ratio,'bilinear', 'Antialiasing',false);
    end