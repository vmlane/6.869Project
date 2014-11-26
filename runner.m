im1 = double(rgb2gray(imread('other-data/RubberWhale/frame10.png')))/255;
im2 = double(rgb2gray(imread('other-data/RubberWhale/frame11.png')))/255;

numLevels = 5;
ratio = .5;
sigma = 1.5;
computeFlow(im1,im2,numLevels,ratio,sigma);
imshow(VisualizeFlow(u, v));

% scoreFlow(u, v, groundTruth);
