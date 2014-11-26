function [ score ] = scoreFlow( flowX, flowY, groundTruth )
    groundTruthX = groundTruth(:,:,1);
    groundTruthY = groundTruth(:,:,2);
    [height, width] = size(flowX);
    
    groundTruthX(abs(groundTruthX) > 1000) = 0;
    groundTruthY(abs(groundTruthY) > 1000) = 0;
    
    errorDist = ((flowX - groundTruthX).^2 + (flowY - groundTruthY).^2).^0.5;
    score = sum(sum(errorDist)) / width / height;

end

