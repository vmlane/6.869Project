function [u,v] = computeFlow(im1,im2,numLevels,ratio,sigma)
    pyramid1 = makeImagePyramid(im1,numLevels,ratio,sigma);
    pyramid2 = makeImagePyramid(im2,numLevels,ratio,sigma);

    u = zeros(size(pyramid1{numLevels}));
    v = zeros(size(pyramid1{numLevels}));

    for k=numLevels:-1:1
        u = imresize(u,size(pyramid1{k}))*(1/ratio);
        v = imresize(v,size(pyramid1{k}))*(1/ratio);
        [u, v] = GetFlow(pyramid1{k}, pyramid2{k}, u, v);
    end