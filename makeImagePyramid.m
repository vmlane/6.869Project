function pyramid = makeImagePyramid(im,numLevels,ratio,sigma)
    %% Create an image pyramid using a gaussian filter
    % im = input image
    % numLevels = number of pyramid levels
    % ratio = size of pyramid image / original image
    % sigma = std deviation of gaussian filter
    
    pyramid = cell(numLevels,1);
    pyramid{1} = im;  
    out = im;
    
    filter = fspecial('gaussian',2*round(sigma*1.5)+1,sigma);
    
    for i=2:numLevels
        % Apply Gaussian Filter
        out = imfilter(out,filter,'symmetric');
        out =  imresize(out,ratio,'bilinear', 'Antialiasing',false);
        % resize image
        pyramid{i} = out;
    end