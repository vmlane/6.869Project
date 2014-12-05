function [im] = VisualizeFlow( u, v, maxFlow )
    % Magnitude is a number between 0 and 1
    [height, width] = size(u);
    flowMag = (u.^2 + v.^2).^0.5;
    flowMag = flowMag / maxFlow;
    
    % Convert direction to a color.
    flowDir = atan2(v, u);
    hue = (flowDir + pi) / 2 / pi;  % Hue between 0 and 1
    hsvMap = [];
    hsvMap(:, :, 1) = hue;
    hsvMap(:, :, 2) = ones(height, width);
    hsvMap(:, :, 3) = flowMag;
    
    im = hsv2rgb(hsvMap);
end

