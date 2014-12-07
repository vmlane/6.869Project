function [u,v] = computeFlow(im1,im2,numLevels,ratio,sigma)
    global groundTruth;
    pyramid1 = makeImagePyramid(im1,numLevels,ratio,sigma);
    pyramid2 = makeImagePyramid(im2,numLevels,ratio,sigma);

    u = zeros(size(pyramid1{numLevels}));
    v = zeros(size(pyramid1{numLevels}));

    for k=numLevels:-1:1
        k
        u = imresize(u,size(pyramid1{k}))*(1/ratio);
        v = imresize(v,size(pyramid1{k}))*(1/ratio);
        im1 = applyFlow(pyramid1{k}, u, v);
        [du, dv] = flowNIter(im1, pyramid2{k}, 10);
        u = u + du;
        v = v + dv;
        u = medfilt2(u);
        v = medfilt2(v);
        remapU = -imresize(u, size(im2)) * (1/ratio)^(k-1);
        remapV = -imresize(v, size(im2)) * (1/ratio)^(k-1);
        scoreFlow(remapU, remapV, groundTruth)
        imshow(VisualizeFlow(remapU, remapV, 6));
        pause
    end