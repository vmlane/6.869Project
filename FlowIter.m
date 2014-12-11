function [ du, dv ] = FlowIter( height, width, laplacian, dt, dx, dy, options)
    
    % img1 and img2 assumed to be grayscale floating point images
    
    % Some little helper functions

    function [ sparseM ] = diagSparse( M )
        Mrow = reshape(M, [], 1);
        sparseM = spdiags(Mrow, 0, length(Mrow), length(Mrow));
    end

    alpha = options.alpha;
    % Compute linear flow operator
    
    A = [diagSparse(dx.*dx) + alpha * laplacian, diagSparse(dx .* dy);
         diagSparse(dx .* dy), diagSparse(dy.^2) + alpha * laplacian];
    b = -[reshape(dx .* dt, [], 1); ...
          reshape(dy .* dt, [], 1)];
    deltaFlow = A \ b; % solve linear equation
    du = reshape(deltaFlow(1:height*width, :), height, width);
    dv = reshape(deltaFlow(height*width+1:2*height*width, :), height, width);

    % limit the incremental flow
    if options.limit
        du(du > 1) = 1;
        du(du < -1) = -1;
        dv(dv > 1) = 1;
        dv(dv < -1) = -1;
    end
end

