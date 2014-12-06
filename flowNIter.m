function [ u, v ] = flowNIter(im1, im2, n)
% Calls FlowIter n times.

u = zeros(size(im1));
v = zeros(size(im1));
warpedIm1 = im1;

for i = 1:n
    [du, dv] = FlowIter(warpedIm1, im2);
    u = u + du;
    v = v + dv;
    warpedIm1 = applyFlow(im1, u, v);
end

end

