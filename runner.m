addpath('./flow-code-matlab');

im1 = double(rgb2gray(imread('other-data/RubberWhale/frame10.png')))/255;
im2 = double(rgb2gray(imread('other-data/RubberWhale/frame11.png')))/255;
global groundTruth;
groundTruth = readFlowFile('./other-gt-flow/RubberWhale/flow10.flo');
groundTruth(abs(groundTruth) > 1000) = 0;

numLevels = 5;
ratio = .5;
sigma = 1;

[u, v] = computeFlow(im1,im2,numLevels,ratio,sigma);
imshow(VisualizeFlow(-u, -v, 6));
scoreFlow(-u, -v, groundTruth)
