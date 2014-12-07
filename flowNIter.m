function [ u, v ] = flowNIter(im1, im2, n, mode)
% Calls FlowIter n times.
% mode: 1 = quadratic, 2 = charbonnier
[height, width] = size(im1);
u = zeros(size(im1));
v = zeros(size(im1));
warpedIm1 = im1;
global groundTruth;
laplacian = makeLaplacian(width, height, u, v, mode);

for i = 1:n
    if mode ~= 1
        laplacian = makeLaplacian(width, height, u, v, mode);
    end
    [du, dv] = FlowIter(warpedIm1, im2, laplacian, mode);
    u = u + du;
    v = v + dv;
    u = medfilt2(u);
    v = medfilt2(v);
    warpedIm1 = applyFlow(im1, u, v);
    scoreFlow(-u, -v, groundTruth)
end

end

