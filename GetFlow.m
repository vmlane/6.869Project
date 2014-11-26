function [ u, v ] = GetFlow( img1, img2, prevU, prevV)
    
    % img1 and img2 assumed to be grayscale floating point images

    [height, width] = size(img1);
    % compute spatial & temporal partial derivatives
    dx = conv2(img1, [-1 1], 'same');
    dy = conv2(img1, [-1 1].', 'same');
    dt = img2 - img1;
    lambda = 0.01;
    
    % Some little helper functions
    function [ idx ] = getSparseIdx(x, y)
        idx = y + height*(x-1);
    end

    function [ sparseM ] = diagSparse( M )
        Mrow = reshape(M, [], 1);
        sparseM = spdiags(Mrow, 0, length(Mrow), length(Mrow));
    end

    % Make laplacian operator
    totalSize = 5*(width-2)*(height-2) + 4*(2*width + 2*height - 4) + 3*4;
    laplacianX = zeros(totalSize, 1);
    laplacianY = zeros(totalSize, 1);
    laplacianValues = zeros(totalSize, 1);
    nextIdx = 1;
    function [] = laplacianAppend(x, y, value)
        laplacianX(nextIdx) = x;
        laplacianY(nextIdx) = y;
        laplacianValues(nextIdx) = value;
        nextIdx = nextIdx + 1;
    end

    for x = 1:width
        if mod(x, 100) == 0
            x
        end
        for y = 1:height
            thisIdx = getSparseIdx(x, y);
            laplacianAppend(thisIdx, thisIdx, 4);
            if x > 1
                laplacianAppend(thisIdx, getSparseIdx(x-1, y), -1);
            end
            if x < width
                laplacianAppend(thisIdx, getSparseIdx(x+1, y), -1);
            end
            if y > 1
                laplacianAppend(thisIdx, getSparseIdx(x, y-1), -1);
            end
            if y < height
                laplacianAppend(thisIdx, getSparseIdx(x, y+1), -1);
            end
        end
    end
    
    laplacianX = laplacianX(1:(nextIdx - 1));
    laplacianY = laplacianY(1:(nextIdx - 1));
    laplacianValues = laplacianValues(1:(nextIdx - 1));
    
    laplacian = sparse(laplacianX, laplacianY, laplacianValues, width*height, width*height);
    
    % Compute linear flow operator
    A = [diagSparse(dx.*dx) + lambda * laplacian, diagSparse(dx .* dy);
         diagSparse(dx .* dy), diagSparse(dy.^2) + lambda * laplacian];
    b = -[reshape(dx .* dt, [], 1) + lambda*laplacian*reshape(prevU, [], 1); ...
          reshape(dy .* dt, [], 1) + lambda*laplacian*reshape(prevV, [], 1)];
    deltaFlow = A \ b; % solve linear equation
    u = prevU + reshape(deltaFlow(1:height*width, :), height, width);
    v = prevV + reshape(deltaFlow(height*width+1:2*height*width, :), height, width);
    u = medfilt2(u);
    v = medfilt2(v);
end

