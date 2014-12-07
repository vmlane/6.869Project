function [ u, v ] = FlowIter( img1, img2, laplacian, mode)
    
    % img1 and img2 assumed to be grayscale floating point images

    [height, width] = size(img1);
    % compute spatial & temporal partial derivatives
    dx = conv2(img1, [-1 1], 'same');
    dy = conv2(img1, [-1 1].', 'same');
    dt = img2 - img1;
    alpha = 0.1;
    
    % Some little helper functions

    function [ sparseM ] = diagSparse( M )
        Mrow = reshape(M, [], 1);
        sparseM = spdiags(Mrow, 0, length(Mrow), length(Mrow));
    end
    function [ out ] = charb(x)
        epsilon = 0.01;
        out = x .* (x.^2 + epsilon) .^ -0.5;
    end
    function [ out ] = quad(x)
        out = x;
    end
    if mode == 2
        psi = @(x) charb(x);
    else
        psi = @(x) quad(x);
    end
    % Compute linear flow operator
    A = [diagSparse(psi(dx.*dx)) + alpha * laplacian, diagSparse(psi(dx .* dy));
         diagSparse(psi(dx .* dy)), diagSparse(psi(dy.^2)) + alpha * laplacian];
    b = -[reshape(psi(dx .* dt), [], 1); ...
          reshape(psi(dy .* dt), [], 1)];
    deltaFlow = A \ b; % solve linear equation
    u = reshape(deltaFlow(1:height*width, :), height, width);
    v = reshape(deltaFlow(height*width+1:2*height*width, :), height, width);

end

