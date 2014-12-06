function [ u, v ] = flowNIter(im1, im2, n)
% Calls FlowIter n times.
[height, width] = size(im1);
u = zeros(size(im1));
v = zeros(size(im1));
warpedIm1 = im1;
% Make laplacian operator
laplacian = makeLaplacian(width, height, im1);
    
for i = 1:n
    [du, dv] = FlowIter(warpedIm1, im2, laplacian);
    u = u + du;
    v = v + dv;
    warpedIm1 = applyFlow(im1, u, v);
end

end

