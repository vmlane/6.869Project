function [u,v] = computeFlow(im1,im2,options)
    global groundTruth;
    
    %TODO: texture decomposition
    
    % Make image pyramids
    options.numPyramidLevels = 1 + floor( log(min(size(im1,1), size(im1,2))/16) / log(1/options.ratio) );
    pyramid1 = makeImagePyramid(im1,options.numPyramidLevels,options.ratio,options.sigma);
    pyramid2 = makeImagePyramid(im2,options.numPyramidLevels,options.ratio,options.sigma);
    
    % Make image pyramids
    gncPyramid1 = makeImagePyramid(im1,options.numGncLevels,options.gncRatio,options.gncSigma);
    gncPyramid2 = makeImagePyramid(im2,options.numGncLevels,options.gncRatio,options.gncSigma);

    % initialize flow with all zeros
    u = zeros(size(pyramid1{options.numPyramidLevels}));
    v = zeros(size(pyramid1{options.numPyramidLevels}));
    
    lastSize = 1;
    fullSize = size(im2, 1);
    for gncIter = 1:options.numGncIters
        display(gncIter);    
        if gncIter == 1
            numLevels = options.numPyramidLevels;
            pyr1 = pyramid1;
            pyr2 = pyramid2;
        else
            numLevels = options.numGncLevels;
            pyr1 = gncPyramid1;
            pyr2 = gncPyramid2;
        end
        
        for k=numLevels:-1:1
            display(k);
            thisSize = size(pyr1{k}, 1);
            % Scale the flow
            u = imresize(u,size(pyr1{k}))*(thisSize / lastSize);
            v = imresize(v,size(pyr1{k}))*(thisSize / lastSize);

            % Compute the flow for a single pyramid level
            [u, v] = flowNIter(pyr1{k},pyr2{k},u,v,options);
            % score the flow
            remapU = imresize(u, size(im2)) * fullSize / thisSize;
            remapV = imresize(v, size(im2)) * fullSize / thisSize;
            scoreFlow(remapU, remapV, groundTruth)
            imshow(VisualizeFlow(remapU, remapV, 6));
            lastSize = thisSize;
        end
%         pause
%         if options.numGncIters > 1
%             newAlpha = 1 - gncIter/(options.numGncIters-1);
%             options.alpha = max(0,min(options.alpha,newAlpha));
%         end
    end