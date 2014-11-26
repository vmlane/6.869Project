function [ u, v ] = GetFlow( img1, img2 )
    
    % img1 and img2 assumed to be grayscale floating point images

    [height, width] = size(img1);
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
    
    % Make laplacian matrix
    laplacian = spalloc(width*height, width*height, 5*width*height);
    for x = 1:width
        for y = 1:height
            thisIdx = getSparseIdx(x, y);
            laplacian(thisIdx, thisIdx) = 4;
            if x > 1
                laplacian(thisIdx, getSparseIdx(x-1, y)) = -1;
            end
            if x < width
                laplacian(thisIdx, getSparseIdx(x+1, y)) = -1;
            end
            if y > 1
                laplacian(thisIdx, getSparseIdx(x, y-1)) = -1;
            end
            if y < height
                laplacian(thisIdx, getSparseIdx(x, y+1)) = -1;
            end
        end
    end
    
    A = [diagSparse(dx.*dx) + lambda * laplacian, diagSparse(dx .* dy);
         diagSparse(dx .* dy), diagSparse(dy.^2) + lambda * laplacian];
    b = -[reshape(dx .* dt, [], 1); reshape(dy .* dt, [], 1)];
    flow = A \ b;
    u = reshape(flow(1:height*width, :), height, width);
    v = reshape(flow(height*width+1:2*height*width, :), height, width);

end

