function [ laplacian ] = makeLaplacian( width, height, u, v, options )

    function [ idx ] = getSparseIdx(x, y)
        idx = y + height*(x-1);
    end
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

    function [grad] = grad(vector)
        grad = (conv2(vector, [-1 1], 'same').^2 + conv2(vector, [-1 1].', 'same').^2).^0.5;
    end

    gradU = grad(u);
    gradV = grad(v);
    epsilon = 0.01;

    for x = 1:width
        for y = 1:height
            thisIdx = getSparseIdx(x, y);
            % Determine weighting on x and y derivatives.
            % Derivatives don't get much weighting on an edge in that
            % direction.
            if options.charbonnier == 1
                xWeight = 1;
                yWeight = 1;
            else
                xWeight = gradU(y, x)*(gradU(y, x)^2 + epsilon) .^ -0.5 + epsilon;
                yWeight = gradV(y, x)*(gradV(y, x)^2 + epsilon) .^ -0.5 + epsilon;
            end
            laplacianAppend(thisIdx, thisIdx, 2*xWeight + 2*yWeight);
            if x > 1
                laplacianAppend(thisIdx, getSparseIdx(x-1, y), -xWeight);
            end
            if x < width
                laplacianAppend(thisIdx, getSparseIdx(x+1, y), -xWeight);
            end
            if y > 1
                laplacianAppend(thisIdx, getSparseIdx(x, y-1), -yWeight);
            end
            if y < height
                laplacianAppend(thisIdx, getSparseIdx(x, y+1), -yWeight);
            end
        end
    end

    laplacianX = laplacianX(1:(nextIdx - 1));
    laplacianY = laplacianY(1:(nextIdx - 1));
    laplacianValues = laplacianValues(1:(nextIdx - 1));

    laplacian = sparse(laplacianX, laplacianY, laplacianValues, width*height, width*height);
end

