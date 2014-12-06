function [ laplacian ] = makeLaplacian( width, height, img )
    % Make the Laplacian operator.  Uses memoization to make this easier.
    global laplacianInputs;
    global laplacianOutputs;
    brightnessCutoff = 0.1;
    
    function [ laplacian ] = inner(width, height, img)

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
        
        dx = conv2(img, [-1 1], 'same');
        dy = conv2(img, [-1 1].', 'same');

        for x = 1:width
            for y = 1:height
                thisIdx = getSparseIdx(x, y);
                % Determine weighting on x and y derivatives.
                % Derivatives don't get much weighting on an edge in that
                % direction.
%                 xWeight = 0.9999*(abs(dx(y, x)) < brightnessCutoff) + 0.0001;
%                 yWeight = 0.9999*(abs(dy(y, x)) < brightnessCutoff) + 0.0001;
                xWeight = 1;
                yWeight = 1;
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

    % Try to locate the answer in cache.
    % Grrr, matlab doesn't have hashmaps, so we have to do this nonsense.
    if isempty(laplacianInputs)
        findCol = 0;
    else
        findCol = ismember(laplacianInputs, [width, height], 'rows');
    end
    if sum(findCol) > 0
        laplacian = laplacianOutputs{find(findCol)};
    else
        laplacian = inner(width, height, img);
        laplacianInputs = [laplacianInputs; [width, height]];
        laplacianOutputs{length(laplacianOutputs) + 1} = laplacian;
    end
end

