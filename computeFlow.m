function [u,v] = computeFlow(im1,im2,numLevels,ratio,sigma)
    pyramid1 = makeImagePyramid(im1,numLevels,ratio,sigma);
    pyramid2 = makeImagePyramid(im2,numLevels,ratio,sigma);

    u = zeros(size(pyramid1{numLevels}));
    v = zeros(size(pyramid1{numLevels}));

    for k=numLevels:-1:1
        u = imresize(u,size(pyramid1{k}))*(1/ratio);
        v = imresize(v,size(pyramid1{k}))*(1/ratio);
        im1 = applyFlow(pyramid1{k}, u, v);
        [du, dv] = FlowIter(im1, pyramid2{k});
        u = u + du;
        v = v + dv;
        u = medfilt2(u);
        v = medfilt2(v);
    end