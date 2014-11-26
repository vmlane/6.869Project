addpath('./flow-code-matlab');
im1 = double(rgb2gray(imread('./other-data/RubberWhale/frame10.png')))/255;
im2 = double(rgb2gray(imread('./other-data/RubberWhale/frame11.png')))/255;
% 
% im1 = imresize(im1, 0.2);
% im2 = imresize(im2, 0.2);
groundTruth = readFlowFile('./other-gt-flow/RubberWhale/flow10.flo');

[u, v] = GetFlow(im1, im2);
imshow(VisualizeFlow(u, v));

scoreFlow(u, v, groundTruth);