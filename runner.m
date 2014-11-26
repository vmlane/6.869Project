im1 = double(rgb2gray(imread('other-data/RubberWhale/frame10.png')))/255;
im2 = double(rgb2gray(imread('other-data/RubberWhale/frame11.png')))/255;

im1 = imresize(im1, 0.2);
im2 = imresize(im2, 0.2);

numLevels = 5;
ratio = .5;
sigma = 1.5;
pyramid1 = makeImagePyramid(im1,numLevls,ratio,sigma);

u = zeros(size(pyramid1(numLevels)));
v = zeros(size(pyramid1(numLevels)));

for k=numLevels:-1:1
    u = imresize(u,size(pyramid1{k}))*(1/ratio);
    v = imresize(v,size(pyramid1{k}))*(1/ratio);
end
[u, v] = GetFlow(im1, im2);
imshow(VisualizeFlow(u, v));

addpath('./flow-code-matlab');
groundTruth = readFlowFile('./other-gt-flow/RubberWhale/flow10.flo');

scoreFlow(u, v, groundTruth);