function [ u, v ] = flowNIter(im1, im2, u, v, options)
[height,width] = size(im1);

for i = 1:options.numWarpIters
    % compute the partial derivatives
    [dt, dx, dy] = applyFlow(im1,im2,u,v);
    
    % Make laplacian operator
    laplacian = makeLaplacian(width, height, u, v, options);

    [du, dv] = FlowIter(height,width,laplacian,dt,dx,dy, options.alpha);
    % apply median filtering
    u2 = u + du;
    v2 = v + dv;
    u2 = medfilt2(u2,[5,5],'symmetric');
    v2 = medfilt2(v2,[5,5],'symmetric');
    du = u2 - u;
    dv = v2 - v;
    % update u and v
    u = u + du;
    v = v + dv;
end

end

