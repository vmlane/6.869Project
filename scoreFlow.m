function [ score ] = scoreFlow( flowX, flowY, groundTruth )
    groundTruthX = groundTruth(:,:,1);
    groundTruthY = groundTruth(:,:,2);
    [height, width] = size(flowX);

    sum(sum(abs(groundTruthX)))
    sum(sum(abs(flowX)))
    
    errorDist = ((flowX - groundTruthX).^2 + (flowY - groundTruthY).^2).^0.5;
    score = sum(sum(errorDist)) / width / height;

end

