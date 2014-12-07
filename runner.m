addpath('./flow-code-matlab');

im1 = double(rgb2gray(imread('other-data/RubberWhale/frame10.png')))/255;
im2 = double(rgb2gray(imread('other-data/RubberWhale/frame11.png')))/255;
global groundTruth;
groundTruth = readFlowFile('./other-gt-flow/RubberWhale/flow10.flo');
groundTruth(abs(groundTruth) > 1000) = 0;

options = struct();

options.numPyramidLevels = 4;
options.numGncLevels = 2;
options.ratio = .5;
options.sigma = sqrt(1/options.ratio)/sqrt(2);
options.gncRatio = 1/1.25;
options.gncSigma = sqrt(1/options.gncRatio)/sqrt(2);
options.alpha = 0.1;

options.numGncIters = 1;
options.numWarpIters = 10;

[u, v] = computeFlow(im1,im2,options);
imshow(VisualizeFlow(-u, -v, 6));
score = scoreFlow(-u, -v, groundTruth)
