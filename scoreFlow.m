function [ score ] = scoreFlow( flowX, flowY, groundTruth )
    groundTruthX = groundTruth(:,:,1);
    groundTruthY = groundTruth(:,:,2);
    [width, height] = size(flowX);
    
    errorDist = ((flowX - groundTruthX).^2 + (flowY - groundTruthY).^2).^0.5;
    score = sum(sum(errorDist)) / width / height;

end

